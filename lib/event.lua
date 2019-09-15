local event = {}

_OSENV.event = {
    timers = {}
}

local function updateTimers()
    for k, timer in pairs(_OSENV.event.timers) do
        if computer.uptime() >= timer.started + timer.time then
            timer.callback()
            
            if timer.type == "after" then
                table.remove(_OSENV.event.timers, k)
            elseif timer.type == "every" then
                timer.started = computer.uptime()
            end
        end
    end
end

function event.after(time, callback)
    table.insert(_OSENV.event.timers, {
        type = "after",
        started = computer.uptime(),
        time = time,
        callback = callback
    })
end

function event.every(time, callback)
    table.insert(_OSENV.event.timers, {
        type = "every",
        started = computer.uptime(),
        time = time,
        callback = callback
    })
end

function event.pull(timeout, filter)
    local timeout = timeout or math.huge
    local deadline = computer.uptime() + timeout

    repeat
        local closestTimer = math.huge
        for _, timer in pairs(_OSENV.event.timers) do
            closestTimer = math.min(closestTimer, timer.started + timer.time)
        end

        local realDeadline = math.min(deadline, closestTimer)

        local signal = { computer.pullSignal(realDeadline - computer.uptime()) }
        
        updateTimers()
        
        if not filter then
            return signal
        else
            for _, v in pairs(filter) do
                if v == signal[1] then
                    return signal
                end
            end
        end
    until computer.uptime() > deadline
end

return event