local term = require("term")
local path = require("path")
local fs = component.proxy(computer.getBootAddress())
local cwd = path.stringify(_OSENV.cwd)
local list = fs.list(cwd)

term.print(list.n .. " items")

for _, file in ipairs(list) do
    term.print(file)
end