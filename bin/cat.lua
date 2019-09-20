local term = require("term")
local path = require("path")
local args = {...}
local fs = component.proxy(computer.getBootAddress())

if #args < 1 then
    term.print("Usage: cat <path...>")
    return
end

for _, file in pairs(args) do
    local path = path.resolve(file)

    if not fs.exists(path) then
        term.print(path .. ": no such file or directory")
    else
        local handle, reason = fs.open(path)
        if not handle then
            term.print(path .. ": failed to open (" .. reason .. ")")
            goto a
        end

        local buffer = ""
        repeat
            local data = fs.read(handle, math.huge)
            buffer = buffer .. (data or "")
        until data == nil

        fs.close(handle)

        term.write(buffer)
    end

    ::a::
end