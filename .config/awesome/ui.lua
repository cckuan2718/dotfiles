local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local gfs = require("gears.filesystem")

local beautiful = require("beautiful")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local xct = xresources.get_current_theme()

local helpers = require("helpers")

-- {{{ Wallpaper
local function set_wallpaper(s)
   if beautiful.wallpaper then
      local wallpaper = beautiful.wallpaper
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
local function gen_watch_widget(command, timeout, callback, bose_widget)
   local wg, tm = awful.widget.watch(
      command,
      timeout or nil,
      callback or nil,
      base_widget or nil)
   wg.font = beautiful.font
   return {widget = wg, timer = tm}
end

local my_widgets = {
   battery  = gen_watch_widget("pl_battery",  10),
   iface    = gen_watch_widget("pl_iface",    10),
   volume   = gen_watch_widget("pl_volume",   60),
   backlight = gen_watch_widget("pl_backlight", 60),
   vmstatus = gen_watch_widget("pl_vmstatus", 10),
   sensors  = gen_watch_widget("pl_sensors",  10),
   diskio   = gen_watch_widget("pl_diskio",   10),
   mailbox  = gen_watch_widget("pl_mailbox",  60, function(widget, stdout)
                                  if stdout:find("nil") then
                                     widget:set_text("")
                                  else
                                     widget:set_text(stdout)
                                  end
   end),
   torrent  = gen_watch_widget("pl_torrent",  30, function(widget, stdout)
                                  if stdout:find("DOWN") then
                                     widget:set_text("")
                                  else
                                     widget:set_text(stdout)
                                  end
   end),
}

local spr = wibox.widget.textbox(' ')
spr.font = beautiful.font

local calendar_widget = require("my_widgets.calendar")
local batteryarc_widget = require("my_widgets.batteryarc")
local mytextclock = wibox.widget {
   format = "%Y-%m-%d %a %H:%M:%S",
   refresh = 1,
   widget = wibox.widget.textclock,
}
local cw = calendar_widget()
mytextclock:connect_signal("button::press", function(_, _, _, button)
                              if button == 1 then
                                 cw.toggle()
                              end
end)

-- }}}

local function update_txt_layoutbox(s)
   -- Writes a string representation of the current layout in a textbox widget
   local txt_l = beautiful["layout_txt_" .. awful.layout.getname(awful.layout.get(s))] or ""
   s.mytxtlayoutbox:set_text(txt_l)
end

awful.screen.connect_for_each_screen(function(s)
      -- Wallpaper
      set_wallpaper(s)

      -- Each screen has its own tag table.
      awful.tag({ "", "", "", "", "", }, s, awful.layout.layouts[3])

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
--            height = dpi(35),
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
            my_widgets.torrent.widget,
            spr,
            my_widgets.mailbox.widget,
            spr,
            my_widgets.diskio.widget,
            spr,
            my_widgets.sensors.widget,
            spr,
            my_widgets.vmstatus.widget,
            spr,
            my_widgets.backlight.widget,
            spr,
            my_widgets.volume.widget,
            spr,
            my_widgets.iface.widget,
            spr,
            batteryarc_widget(),
            spr,
            mytextclock,
            spr,
            wibox.widget.systray(),
         },
      }
end
)
