local term = require("term")
local gpu = component.proxy(component.list("gpu")())
local env = {}

term.print("Type an expression and press enter to evaluate it.")
term.print("Prefix the expression with '=' to print its return value.")
term.print("Type '.exit' to exit.")

while true do
    term.write("lua> ")
    local input = term.read()

    if input == ".exit" then
        break
    else
        local output = false

        if input:sub(1, 1) == '=' then
            output = true
            input = "return (" .. input:sub(2) .. ")"
        end

        local chunk, reason = load(input)
        if not chunk then
            gpu.setForeground(0xFF0000)
            term.print(reason)
            gpu.setForeground(0xFFFFFF)
        else
            local ret

            do
                local _ENV = env
                ret = chunk()
            end

            term.print(ret)
        end
    end
end