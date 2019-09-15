local loadfile, config = ...
local invoke = component.invoke
local fs = computer.getBootAddress()
local requirePath = config.requirePath

function require(module)
    for _, path in pairs(requirePath) do
        local modulePath = path:gsub("?", module)
        if invoke(fs, "exists", modulePath) then
            local module, reason = loadfile(fs, modulePath)
            if not module then
                return nil, reason
            end

            return module()
        end
    end
end