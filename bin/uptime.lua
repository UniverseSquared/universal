local term = require("term")
local uptime = computer.uptime()

local seconds = tonumber(os.date("%S", uptime))
local minutes = tonumber(os.date("%M", uptime))
local hours = tonumber(os.date("%H", uptime))
local days = tonumber(os.date("%d", uptime))
local weekdays = math.floor(days % 7) - 1
local weeks = math.floor(days / 7)
local months = tonumber(os.date("%m", uptime)) - 1
local years = tonumber(os.date("%Y", uptime)) - 1970

local out = "uptime: "

if years > 0 then
    out = out .. years .. " years "
end

if months > 0 then
    out = out .. months .. " months "
end

if weeks > 0 then
    out = out .. weeks .. " weeks "
end

if weekdays > 0 then
    out = out .. weekdays .. " days "
end

if hours > 0 then
    out = out .. hours .. " hours "
end

if minutes > 0 then
    out = out .. minutes .. " minutes "
end

if seconds > 0 then
    out = out .. seconds .. " seconds "
end

term.print(out:gsub("%s+$", "") .. ".")