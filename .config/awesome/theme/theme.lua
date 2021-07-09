local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local xct = xresources.get_current_theme()
   
local gfs = require("gears.filesystem")

local theme = {}

theme.font      = "Iosevka 14"
theme.wallpaper = "~/.local/share/data/bg"

theme.bg_normal     = xct.background
theme.bg_focus      = xct.color11
theme.bg_urgent     = xct.color9
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = xct.foreground
theme.fg_focus      = xct.background
theme.fg_urgent     = xct.background

theme.useless_gap   = dpi(2)
theme.border_width  = dpi(1)
theme.border_normal = xct.color7
theme.border_focus  = xct.color11

theme.layout_txt_tile                           = "[t]"
theme.layout_txt_tileleft                       = "[tl]"
theme.layout_txt_tilebottom                     = "[tb]"
theme.layout_txt_tiletop                        = "[tt]"
theme.layout_txt_fairv                          = "[fv]"
theme.layout_txt_fairh                          = "[fh]"
theme.layout_txt_spiral                         = "[s]"
theme.layout_txt_dwindle                        = "[d]"
theme.layout_txt_max                            = "[m]"
theme.layout_txt_fullscreen                     = "[f]"
theme.layout_txt_magnifier                      = "[M]"
theme.layout_txt_floating                       = "[><>]"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- {{{ Wallpaper
local function set_wallpaper(s)
    -- Wallpaper
    if theme.wallpaper then
        local wallpaper = theme.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)
-- }}}

-- {{{ Screen nonspecific widget
local spr = wibox.widget.textbox(' ')

-- clock
--local mytextclock = wibox.widget.textclock("%Y-%m-%d %a %H:%M:%S", 1)
local mytextclock = awful.widget.watch("pl_clock", 1)
mytextclock.font = theme.font

-- }}}

local function update_txt_layoutbox(s)
    -- Writes a string representation of the current layout in a textbox widget
    local txt_l = theme["layout_txt_" .. awful.layout.getname(awful.layout.get(s))] or ""
    s.mytxtlayoutbox:set_text(txt_l)
end

function theme.at_screen_connect(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", }, s, awful.layout.layouts[3])

    -- tag list
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
    }

    -- Textual layoutbox
    s.mytxtlayoutbox = wibox.widget.textbox('')
    update_txt_layoutbox(s)
    awful.tag.attached_connect_signal(s, "property::selected", function () update_txt_layoutbox(s) end)
    awful.tag.attached_connect_signal(s, "property::layout",   function () update_txt_layoutbox(s) end)
    
    -- wibar
    s.mywibox = awful.wibar({
	  position = "top",
	  screen = s,
	  height = dpi(25),
    })

    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
	    spr,
	    s.mytxtlayoutbox,
        },
        nil, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mytextclock,
	    spr,
            wibox.widget.systray(),
        },
    }
end

return theme

