-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library

local beautiful = require("beautiful")
-- Notification library

local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")


-- {{{ Config starts
require("error_handling")

require("layouts")

beautiful.init(gears.filesystem.get_configuration_dir() .. "theme/theme.lua")
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)

require("bindings")

require("rules")

require("signals")
-- }}}

