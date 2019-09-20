local term = require("term")
local text = require("text")
local args = {...}
local devices = computer.getDeviceInfo()

if #args == 0 then
    for address, device in pairs(devices) do
        term.print(string.format(
            "%s (%s) - %s",
            address:sub(1, 8), device.class, device.description
        ))
    end
else
    local address = args[1]
    if #address ~= 8 then
        term.print("lshw: invalid component address: expected 8 characters, got " .. #address .. ".")
        return
    end
    
    local deviceAddr
    for fullAddress in pairs(devices) do
        if fullAddress:sub(1, 8) == address then
            deviceAddr = fullAddress
            break
        end
    end

    if not deviceAddr then
        term.print("lshw: no such component " .. address)
        return
    end

    for k, v in pairs(devices[deviceAddr]) do
        term.print(k .. " = " .. v)
    end
end