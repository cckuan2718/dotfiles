local naughty = require("naughty")
local nconf = naughty.config

local beautiful = require("beautiful")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local xct = xresources.get_current_theme()

local helpers = require("helpers")

nconf.defaults.border_width = beautiful.border_width
nconf.defaults.font = beautiful.font
nconf.defaults.icon_size = dpi(100)
nconf.defaults.margin = dpi(5)
nconf.defaults.ontop = true
nconf.defaults.opacity = 100
nconf.defaults.position = "top_right"
nconf.defaults.shape = helpers.rrect(beautiful.border_radius)
nconf.defaults.text = "foo bar"

nconf.defaults.bg = xct.background
nconf.defaults.fg = xct.color11
nconf.defaults.border_color = xct.color11
nconf.defaults.timeout = 5

nconf.presets.low.bg = xct.background
nconf.presets.low.fg = xct.color10
nconf.presets.low.border_color = xct.color10
nconf.presets.low.timeout = 3

nconf.presets.critical.bg = xct.background
nconf.presets.critical.fg = xct.color9
nconf.presets.critical.border_color = xct.color9
nconf.presets.critical.timeout = 0

nconf.spacing = dpi(3)
nconf.notify_callback = function(args)
   local syn_list = { mpc = 1 }
   local syn_str = args.freedesktop_hints.synchronous
   if syn_str then
      args.replaces_id = syn_list[syn_str] or 0
   end
   return args
end
