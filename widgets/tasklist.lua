local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local bevel_container = require("containers.bevel_container")
local spacer = require("widgets.spacer")

local function update_task_widget(task_widget, client, index, objects)
    task_widget:set_active(client.active)
end

local function create_taglist(screen)
    local taglist = awful.widget.tasklist {
        screen  = screen,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = {
            awful.button({ }, 1, function (c)
                c:activate { context = "tasklist", action = "toggle_minimization" }
            end),
            awful.button({ }, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
            awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
            awful.button({ }, 5, function() awful.client.focus.byidx( 1) end),
        },
        layout = {
            layout  = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                {
                    {
                        {
                            id = "icon_role",
                            widget = wibox.widget.imagebox,
                        },
                        height = 12,
                        widget = wibox.container.constraint,
                    },
                    fill_vertical = true,
                    widget = wibox.container.place,
                },
                {
                    id = "text_role",
                    forced_width = 180,
                    widget = wibox.widget.textbox,
                },
                spacing = 5,
                layout = wibox.layout.fixed.horizontal,
            },
            create_callback = update_task_widget,
            update_callback = update_task_widget,
            widget = bevel_container,
        },
    }

    --taglist:set_update_callback(update_taglist)

    return taglist
end

return create_taglist
