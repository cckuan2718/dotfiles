local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

-- {{{ Config starts
require("error_handling")

require("layouts")

beautiful.init(gears.filesystem.get_configuration_dir() .. "theme/theme.lua")
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)

require("bindings")

require("rules")

require("signals")
-- }}}

