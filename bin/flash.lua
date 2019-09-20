local term = require("term")
local path = require("path")
local args = {...}
local eeprom = component.proxy(component.list("eeprom")())
local fs = component.proxy(computer.getBootAddress())

function printUsage()
    term.print("Usage: flash [-r/-w] <path> [eeprom data]")
end

if #args < 2 then
    printUsage()
    return
end

local mode = args[1]
local path = path.resolve(args[2])

if mode == "-r" then
    local handle, reason = fs.open(path, 'w')
    if not handle then
        term.print(path .. ": failed to open (" .. reason .. ")")
        return
    end

    local data = eeprom.get()

    if not fs.write(handle, data) then
        term.print(path .. ": failed to write data")
        fs.close(handle)
        return
    end

    fs.close(handle)
elseif mode == "-w" then
    local data = args[3]

    local handle, reason = fs.open(path)
    if not handle then
        term.print(path .. ": failed to open (" .. reason .. ")")
        return
    end

    local buffer = ""
    repeat
        local data = fs.read(handle, math.huge)
        buffer = buffer .. (data or "")
    until data == nil

    fs.close(handle)

    term.print("Flashing. Do not power off or reboot.")

    eeprom.set(buffer)

    if data ~= nil then
        eeprom.setData(data)
    end

    term.print("Done.")

    term.print("Input a label for the eeprom, or nothing to leave it unchanged:")
    local label = term.read()

    if #label > 0 then
        eeprom.setLabel(label)
    end
else
    printUsage()
    return
end