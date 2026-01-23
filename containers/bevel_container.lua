local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local cairo = require("lgi").cairo
local setmetatable = setmetatable
local gtable = gears.table

local create_color_image_images = {}
local function create_color_image(color)
    if create_color_image_images[color] then
        return create_color_image_images[color]
    end

    local img = cairo.ImageSurface.create(cairo.Format.ARGB32, 1, 1)
    local cr  = cairo.Context(img)
    cr:set_source(gears.color(color))
    cr:rectangle(0, 0, 1, 1)
    cr:fill()

    create_color_image_images[color] = img

    return img
end

local normal_background_image = gears.filesystem.get_configuration_dir() .. "BlueImage.jpeg"
local inverted_background_image = gears.filesystem.get_configuration_dir() .. "DarkBlueImage.jpeg"

local normal_border_images = {
    top_left     = create_color_image(beautiful.bevel_ll),
    top          = create_color_image(beautiful.bevel_l),
    top_right    = create_color_image(beautiful.bevel_ld),
    right        = create_color_image(beautiful.bevel_d),
    bottom_right = create_color_image(beautiful.bevel_dd),
    bottom       = create_color_image(beautiful.bevel_d),
    bottom_left  = create_color_image(beautiful.bevel_ld),
    left         = create_color_image(beautiful.bevel_l),
}
local inverted_border_images = {
    top_left     = create_color_image(beautiful.bevel_dd),
    top          = create_color_image(beautiful.bevel_d),
    top_right    = create_color_image(beautiful.bevel_ld),
    right        = create_color_image(beautiful.bevel_l),
    bottom_right = create_color_image(beautiful.bevel_ll),
    bottom       = create_color_image(beautiful.bevel_l),
    bottom_left  = create_color_image(beautiful.bevel_ld),
    left         = create_color_image(beautiful.bevel_d),
}

local only_top_bottom_normal_border_images = {
    top_left     = create_color_image(beautiful.bevel_l),
    top          = create_color_image(beautiful.bevel_l),
    top_right    = create_color_image(beautiful.bevel_l),
    bottom_right = create_color_image(beautiful.bevel_d),
    bottom       = create_color_image(beautiful.bevel_d),
    bottom_left  = create_color_image(beautiful.bevel_d),
}
local only_top_bottom_inverted_border_images = {
    top_left     = create_color_image(beautiful.bevel_dd),
    top          = create_color_image(beautiful.bevel_d),
    top_right    = create_color_image(beautiful.bevel_ld),
    bottom_right = create_color_image(beautiful.bevel_ll),
    bottom       = create_color_image(beautiful.bevel_l),
    bottom_left  = create_color_image(beautiful.bevel_ld),
}

local bevel_container = { mt = {} }

function bevel_container:set_widget(widget)
    self:get_children()[2]:get_widget():set_widget(widget)
end

function bevel_container:set_children(children)
    self:set_widget(children[1])
end

function bevel_container:set_active(active)
    self._private.active = active
    if self._private.only_top_bottom_borders then
        self:get_children()[2]:set_border_images(active and only_top_bottom_inverted_border_images or only_top_bottom_normal_border_images)
    else
        self:get_children()[2]:set_border_images(active and inverted_border_images or normal_border_images)
    end
    self:get_children()[1]:set_image(active and inverted_background_image or normal_background_image)
end

function bevel_container:get_active()
    return self._private.active
end

function bevel_container:set_only_top_bottom_borders(value)
    self._private.only_top_bottom_borders = value
    self:set_active(self:get_active())
end

function bevel_container:get_only_top_bottom_borders()
    return self._private.only_top_bottom_borders
end

local function new(widget)
    local ret = wibox.widget{
        {
            resize = false,
            horizontal_fit_policy = "repeat",
            vertical_fit_policy = "repeat",
            widget = wibox.widget.imagebox,
        },
        {
            {
                left = 5,
                right = 5,
                widget = wibox.container.margin,
            },
            borders = 1,
            border_images = normal_border_images,
            widget = wibox.container.border,
        },
        layout = wibox.layout.stack,
    }

    gtable.crush(ret, bevel_container, true)

    if widget then
        ret:set_widget(widget)
    end
    ret._private.only_top_bottom_borders = false
    ret:set_active(false)

    return ret
end

function bevel_container.mt:__call(...)
    return new(...)
end

return setmetatable(bevel_container, bevel_container.mt)
