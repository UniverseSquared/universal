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

function args.generateHelp(argList, options, programName)
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

function args.parse(argList, options, programName)
    local parsed = {
        options = {},
        others = {}
    }

    local function getArgType(arg)
        if arg:sub(1, 3) == "---" then
            return nil
        elseif arg:sub(1, 2) == "--" then
            return "long"
        elseif arg:sub(1, 1) == "-" then
            return "short"
        end
    end

    for _, arg in pairs(argList) do
        local argType = getArgType(arg)

        if argType == nil then
            table.insert(parsed.others, arg)
        else
            local argName = arg:sub(argType == "long" and 3 or 2)

            local option
            for _, opt in pairs(options) do
                if argType == "short" and opt.short == argName then
                    option = opt
                elseif argType == "long" and opt.long == argName then
                    option = opt
                end
            end

            if not option then
                return false, programName .. ": Invalid argument '" .. arg .. "'"
            end

            if argType ~= nil then
                if parsed.options[option.short] then
                    return false, programName .. ": Duplicate option '" .. arg .. "'"
                end

                parsed.options[option.short] = true
            end
        end
    end

    for _, option in pairs(options) do
        if not option.optional and not parsed.options[option.short] then
            return false, args.generateHelp(argList, options, programName)
        end
    end

    return true, parsed
end

return args
