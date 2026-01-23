local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local bevel_container = require("containers.bevel_container")

local function update_tag_widget(tag_widget, tag, index, objects)
    local w = tag_widget:get_children_by_id("index_role")[1]
    --w.markup = "<b> "..(tag.selected and "●" or "○").." </b>"
    w.widget.markup = tag.index
    w.fg = (tag.selected or #tag:clients() > 0) and beautiful.fg_normal or beautiful.fg_disabled
    tag_widget:set_active(tag.selected)
end

local function create_taglist(screen)
    local taglist = awful.widget.taglist {
        screen  = screen,
        filter  = awful.widget.taglist.filter.all,
        buttons = {
            awful.button({ }, 1, function(t) t:view_only() end),
            awful.button({ modkey }, 1, function(t)
                                            if client.focus then
                                                client.focus:move_to_tag(t)
                                            end
                                        end),
            awful.button({ }, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3, function(t)
                                            if client.focus then
                                                client.focus:toggle_tag(t)
                                            end
                                        end),
            awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
        },
        layout = {
            --spacing = 8,
            layout  = wibox.layout.fixed.horizontal,
        },
        widget_template = {
            {
                id = "index_role",
                {
                    halign = "center",
                    widget = wibox.widget.textbox
                },
                widget = wibox.container.background
            },
            forced_width = 25,
            --active = true,
            create_callback = function (self, c3, index, objects)
                update_tag_widget(self, c3, index, objects)
            end,
            update_callback = function (self, c3, index, objects)
                update_tag_widget(self, c3, index, objects)
            end,
            widget = bevel_container,
        },
    }

    --taglist:set_update_callback(update_taglist)

    return taglist
end

return create_taglist
