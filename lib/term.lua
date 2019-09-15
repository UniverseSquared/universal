local event = require("event")
local gpu = component.proxy(component.list("gpu")())
local w, h = gpu.getResolution()
local term = {}

_OSENV.term = _OSENV.term or {
    x = 1, y = 1
}

-- event.every(0.5, function()
--     local cursorVisible = not _OSENV.term.cursorVisible

--     if cursorVisible then
--         gpu.setBackground(0xFFFFFF)
--     else
--         gpu.setBackground(0x000000)
--     end

--     gpu.set(_OSENV.term.x, _OSENV.term.y, ' ')
--     gpu.setBackground(0x000000)

--     _OSENV.term.cursorVisible = cursorVisible
-- end)

function term.setCursorPos(x, y)
    _OSENV.term.x = x or _OSENV.term.x
    _OSENV.term.y = y or _OSENV.term.y
end

function term.write(str)
    local str = tostring(str)
    
    for i = 1, #str do
        local c = str:sub(i, i)

        if c == '\n' then
            term.setCursorPos(1, _OSENV.term.y + 1)

            if _OSENV.term.y > h then
                gpu.copy(1, 2, w, h, 0, -1)
                gpu.fill(1, h, w, 1, ' ')
                _OSENV.term.y = _OSENV.term.y - 1
            end
        elseif c == '\r' then
            term.setCursorPos(1)
        elseif c == '\t' then
            term.write('    ')
        else
            gpu.set(_OSENV.term.x, _OSENV.term.y, c)
            term.setCursorPos(_OSENV.term.x + 1)
        end
    end
end

function term.print(str)
    local str = str or ""
    
    term.write(str .. '\n')
end

function term.read()
    local startX = _OSENV.term.x
    local buffer = ""

    while true do
        local event = event.pull(nil, { "key_down" })
        
        if event[4] == 0x1C then -- enter
            break
        elseif event[4] == 0x0E then -- backspace
            if #buffer > 0 then
                buffer = buffer:sub(1, #buffer - 1)
                gpu.set(startX + #buffer, _OSENV.term.y, ' ')
                term.setCursorPos(_OSENV.term.x - 1)
            end
        else
            local code = event[3]

            if code >= 0x20 and code <= 0x7E then
                local char = string.char(event[3])

                term.write(char)
                buffer = buffer .. char
            end
        end
    end

    term.write('\n')
    return buffer
end

return term