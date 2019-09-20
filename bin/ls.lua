local term = require("term")
local path = require("path")
local args = require("args")
local fs = component.proxy(computer.getBootAddress())
local cwd = path.stringify(_OSENV.cwd)
local list = fs.list(cwd)

local ok, parsedArgs = args.parse({...}, {
    { short = "a", long = "all", description = "Show all items.", optional = true }
}, "ls")

if not ok then
    term.print(parsedArgs)
    return
end

local filteredList = {}

for _, file in ipairs(list) do
    if file:sub(1, 1) ~= '.' or parsedArgs.switches.a then
        table.insert(filteredList, file)
    end
end

term.print(#filteredList .. " items")

for _, file in ipairs(filteredList) do
    term.print(file)
end