local text = require("text")
local args = {}

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

return args
