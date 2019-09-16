local term = require("term")
local text = require("text")
local args = {...}
local filter = args[1] or ""
local devices = computer.getDeviceInfo()

for address, device in pairs(devices) do
    if address:sub(1, #filter) == filter then
        term.print(address)
        
        for k, v in pairs(device) do
            term.print("  " .. k .. " = " .. v)
        end
    end
end