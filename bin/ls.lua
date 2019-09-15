local term = require("term")
local path = require("path")
local args = {...}
local fs = component.proxy(computer.getBootAddress())
local cwd = path.stringify(_OSENV.cwd)
local list = fs.list(cwd)

local showHidden = args[1] == "-a" or args[1] == "--all"

local filteredList = {}

for _, file in ipairs(list) do
    if file:sub(1, 1) ~= '.' or showHidden then
        table.insert(filteredList, file)
    end
end

term.print(#filteredList .. " items")

for _, file in ipairs(filteredList) do
    term.print(file)
end