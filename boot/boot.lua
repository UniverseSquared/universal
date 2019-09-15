local invoke = component.invoke
local fs = computer.getBootAddress()
local gpu = component.proxy(component.list("gpu")())
local w, h = gpu.getResolution()

_OSENV = {
    cwd = {}
}

local function waitForKey()
    while true do
        local event = computer.pullSignal()
        if event == "key_down" then
            break
        end
    end
end

local x = 1
local y = 1
local function status(msg, newline)
    gpu.set(x, y, msg)

    if newline == nil or newline then
        y = y + 1
        x = 1
    else
        x = x + #msg
    end
end

local function loadConfig()
    local config, reason = loadfile(fs, "/boot/config.lua")
    if not config then
        return nil, reason
    end

    return config()
end

local function loadLibraries(config)
    for k, file in pairs(invoke(fs, "list", "/lib/boot")) do
        if k ~= "n" then
            status("Loading " .. file .. "... ", false)
            local path = "/lib/boot/" .. file
            local module, reason = loadfile(fs, path)
            if not module then
                status("failed!")
                status(reason)
                waitForKey()
                computer.shutdown(true)
            end

            module(loadfile, config)
            status("done.")
        end
    end
end

gpu.setBackground(0x000000)
gpu.setForeground(0xFFFFFF)
gpu.fill(1, 1, w, h, " ")

local config = loadConfig()
_OSENV.config = config

local resolution = config.resolution

if resolution == "max" or resolution == nil then
    resolution = { gpu.maxResolution() }
end

gpu.setResolution(resolution[1], resolution[2])

status("Loading system libraries...")
loadLibraries(config)

local term = require("term")

_OSENV.term.x = x
_OSENV.term.y = y

local shell, reason = loadfile(fs, "/bin/shell.lua")
if not shell then
    term.print("Failed to load shell: " .. reason)
    waitForKey()
    computer.shutdown(true)
end

shell()

computer.shutdown(true)