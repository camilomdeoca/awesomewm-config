local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local bevel_container = require("containers.bevel_container")

local setmetatable = setmetatable
local gtable = gears.table

local spacer = { mt = {} }

local function new(_)
    local ret = wibox.widget {
        only_top_bottom_borders = true,
        widget = bevel_container,
    }

    gtable.crush(ret, spacer, true)

    return ret
end

function spacer.mt:__call(...)
    return new(...)
end

return setmetatable(spacer, spacer.mt)
