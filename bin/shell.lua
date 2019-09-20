local term = require("term")
local path = require("path")
local invoke = component.invoke
local binPath = _OSENV.config.path
local fs = computer.getBootAddress()

local function split(str)
    local parts = {}

    for part in str:gmatch("%S+") do
        table.insert(parts, part)
    end

    return parts
end

while true do
    term.write(path.stringify(_OSENV.cwd) .. ' > ')
    
    local line = term.read():gsub("^%s+", "")
    if #line > 0 then
        local parts = split(line)
        local program = table.remove(parts, 1)
        local found = false

        if program == "exit" then
            return
        end

        for _, searchPath in pairs(binPath) do
            local programPath = path.resolve(searchPath):gsub("?", program)
            if invoke(fs, "exists", programPath) then
                found = true

                local module, reason = loadfile(fs, programPath)
                if not module then
                    term.error(reason)
                    break
                end

                local ok, err = pcall(module, table.unpack(parts))
                if not ok then
                    term.error(err)
                end

                break
            end
        end

        if not found then
            term.print(program .. ": command not found")
        end
    end
end