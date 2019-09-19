local text = {}

function text.serialize(value, indent)
    local t = type(value)

    if t == "string" then
        return '"' .. value .. '"'
    elseif t == "number" then
        return tostring(value)
    elseif t == "nil" then
        return "nil"
    elseif t == "table" then
        if #value == 0 then
            return "{}"
        end

        local buffer = "{\n"
        local indent = indent or 2

        for k, v in pairs(value) do
            local serializedValue

            if type(v) == "table" then
                serializedValue = text.serialize(v, indent + 2)
            else
                serializedValue = text.serialize(v)
            end

            buffer = buffer .. string.rep(' ', indent)

            if type(k) == "number" then
                buffer = buffer .. "[" .. k .. "]"
            else
                buffer = buffer .. k
            end

            buffer = buffer .. " = " .. serializedValue .. ",\n"
        end

        buffer = buffer:sub(1, #buffer - 2)
        buffer = buffer .. "\n" .. string.rep(' ', indent - 2) .. "}"
        return buffer
    end
end

function text.split(str, sep)
    checkArg(1, str, "string")
    checkArg(2, sep, "string")

    local sep, fields = sep or '/', {}
    local pattern = string.format("([^%s]+)", sep)
    str:gsub(pattern, function(c)
        table.insert(fields, c)
    end)
    return fields
end


return text