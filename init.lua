local invoke = component.invoke
local fs = computer.getBootAddress()

function loadfile(fs, path)
    local handle, reason = invoke(fs, "open", path)
    if not handle then
        return nil, reason
    end

    local buffer = ""
    repeat
        local data = invoke(fs, "read", handle, math.huge)
        buffer = buffer .. (data or "")
    until data == nil

    invoke(fs, "close", handle)

    return load(buffer, "=" .. path)
end

local boot, reason = loadfile(fs, "/boot/boot.lua")
if not boot then
    error("Failed to load /boot/boot.lua: " .. reason)
end

boot()