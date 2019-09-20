local term = require("term")

for fs in component.list("filesystem") do
    local fs = component.proxy(fs)
    local used = fs.spaceUsed()
    local total = fs.spaceTotal()
    local percentage = used / total
    local label = fs.getLabel()
    label = label and " (" .. label .. ")" or ""

    term.print(string.format(
        "%s%s - %.2f/%.2f KiB used (%.3f%%)",
        fs.address:sub(1, 8), label , used / 1024, total / 1024, percentage
    ))
end