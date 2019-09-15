local term = require("term")
local args = {...}

for _, item in pairs(args) do
    term.write(item .. ' ')
end

term.print()