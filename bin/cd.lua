local term = require("term")
local path = require("path")
local args = {...}
local invoke = component.invoke
local fs = computer.getBootAddress()

if #args < 1 then
    term.print("Usage: cd <path>")
    return
end

local resolvedPath = path.parse(args[1])

if not invoke(fs, "isDirectory", path.stringify(resolvedPath)) then
    term.print("No such directory.")
    return
end

_OSENV.cwd = resolvedPath