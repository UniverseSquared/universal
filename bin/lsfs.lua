local term = require("term")

for fs in component.list("filesystem") do
    local fs = component.proxy(fs)
    local used = fs.spaceUsed()
    local total = fs.spaceTotal()
    local percentage = used / total

    term.print(string.format(
        "%s - %.2f/%.2f used (%.3f%%)",
        fs.address:sub(1, 8), used / 1024, total / 1024, percentage
    ))
end