-- TODO: function to calculate difference between paths
local path = {}

local function split(str, sep)
    checkArg(1, str, "string")
    checkArg(2, sep, "string")

    local sep, fields = sep or '/', {}
    local pattern = string.format("([^%s]+)", sep)
    str:gsub(pattern, function(c)
        table.insert(fields, c)
    end)
    return fields
end

function path.parse(path)
    checkArg(1, path, "string")

    if path == '/' then
        return {}
    end
    
    local parts = split(path, '/')
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