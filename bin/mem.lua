local term = require("term")
local free = computer.freeMemory()
local total = computer.totalMemory()
local used = total - free
local percentage = used / total

term.print(string.format(
    "%.2f/%.2f KiB used (%.3f%%)",
    used / 1024, total / 1024, percentage
))