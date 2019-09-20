local text = require("text")
local args = {}

local function cloneTable(table)
    local output = {}
    
    for k, v in pairs(table) do
        if type(v) == "table" then
            output[k] = cloneTable(v)
        else
            output[k] = v
        end
    end

    return output
end

function args.generateHelp(options, programName)
    local buffer = "Usage: " .. programName .. " "
    
    for _, option in pairs(options) do
        local display = option.short or option.long

        if option.optional then
            buffer = buffer .. "[-" .. display .. "] "
        else
            buffer = buffer .. "<-" .. display .. "> "
        end
    end

    buffer = buffer .. "\n\n"
    longest = 0

    for _, option in pairs(options) do
        buffer = buffer .. "  "

        if option.short then
            buffer = buffer .. '-' .. option.short
            
            if option.long then
                buffer = buffer .. ", "
            else
                buffer = buffer .. "  "
            end
        else
            buffer = buffer .. "   "
        end

        if option.long then
            longest = math.max(longest, #option.long)

            buffer = buffer .. "--" .. option.long .. ' '
        else
            buffer = buffer .. "{gap} "
        end

        buffer = buffer .. option.description .. '\n'
    end

    return buffer:gsub("{gap}", string.rep(' ', longest + 2))
end

-- Wrapped by args.parse()
local function _parse(input, options, programName)
    local argList = { value = "", switches = {} }
    local namesMap = {}
    local types = { long = "long", short = "short", text = "text" }

    local switchName
    local switchValue = {}

    local function getArg(argument)
        if argument:match("%-%-[^-]+") then
            return types.long, argument:sub(3)
        elseif argument:match("%-[^-]+") then
            return types.short, argument:sub(2)
        end

        return types.text, argument
    end

    local function flushValue()
        if switchName == nil then
            argList.value = table.concat(switchValue, " ")
        else
            local acceptsMultiple = type(argList.switches[switchName]) == "table"

            if acceptsMultiple then
                table.concat(argList.switches[switchName], table.concat(switchValue, " "))
            else
                if argList.switches[switchName] ~= nil then
                    error({ code = 1, error = programName .. ": Duplicate option '" .. switchName .. "' (accepts single values only)" })
                end

                argList.switches[switchName] = type(switchValue) == "table" and table.concat(switchValue, " ") or true
            end
        end
    end

    for _, option in pairs(options) do
        local key = option.short or option.long

        if option.acceptsMultiple then
            argList.switches[key] = {}
        else
            argList.switches[key] = nil
        end

        if option.short and option.long then
            namesMap[option.short] = option.long
            namesMap[option.long] = option.short
        end
    end

    for _, arg in pairs(input) do
        local type, value = getArg(arg)

        if type == types.long and namesMap[value] then
            type = types.short
            value = namesMap[value]
        elseif type == types.long then
            flushValue()
            switchName = value
        end

        if type == types.short then
            flushValue()
            switchName = value
        end

        if type == types.text then
            table.insert(switchValue, value)
        end
    end

    flushValue()

    for _, option in pairs(options) do
        local key = option.short or option.long

        if argList.switches[key] == nil and not option.optional then
            error({ code = 2, error = args.generateHelp(options, programName) })
        end
    end

    return argList
end

-- Wrap errors in _parse
function args.parse(argList, options, programName)
    return pcall(_parse, argList, options, programName)
end

return args
