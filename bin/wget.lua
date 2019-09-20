local term = require("term")
local text = require("text")
local path = require("path")
local internet = component.proxy(component.list("internet")())
local fs = component.proxy(computer.getBootAddress())
local args = {...}

local function getFilename(url)
    local split = text.split(url, "/")
    return split[#split]
end

if #args < 1 then
    term.print("Usage: wget <url> [destination]")
    return
end

if not internet.isHttpEnabled() then
    term.print("This program requires HTTP access to the Internet.")
    term.print("To continue, enable HTTP in your OpenComputers config.")
    return
end

local url = args[1]
local destination = args[2] or getFilename(url)
destination = path.resolve(destination)

-- TODO: Support HTTP header Content-Disposition: filename="default_filename.txt"
local handle = internet.request(url)
handle.finishConnect()

local buffer = ""
repeat
    local data = handle.read(math.huge)
    buffer = buffer .. (data or "")
until data == nil

local file = fs.open(destination, "w")
fs.write(file, buffer)
fs.close(file)