-- TODO: function to calculate difference between paths
local text = require("text")
local path = {}

function path.parse(path)
    checkArg(1, path, "string")

    if path == '/' then
        return {}
    end
    
    local parts = text.split(path, '/')
    local result = {}
    
    if path:sub(1, 1) ~= '/' then
        result = { table.unpack(_OSENV.cwd) }
    end

    for _, part in pairs(parts) do
        if part == '.' then
        elseif part == '..' then
            table.remove(result)
        else
            table.insert(result, part)
        end
    end

    return result
end

function path.stringify(parts)
    checkArg(1, parts, "table")

    return '/' .. table.concat(parts, '/')
end

return path