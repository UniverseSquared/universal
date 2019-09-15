local term = require("term")
local path = require("path")
local args = {...}
local eeprom = component.proxy(component.list("eeprom")())
local fs = component.proxy(computer.getBootAddress())

if #args < 1 then
    term.print("Usage: flash <path> [eeprom data]")
    return
end

local path = path.stringify(path.parse(args[1]))
local data = args[2]

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

term.print("Done. It is now safe to reboot.")