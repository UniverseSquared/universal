local term = require("term")
local gpu = component.proxy(component.list("gpu")())

function error(error)
    gpu.setForeground(0xFF0000)
    term.print("Error: " .. error)
    term.print(debug.traceback())
    gpu.setForeground(0xFFFFFF)
end