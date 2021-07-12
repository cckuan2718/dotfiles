local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local gears = require("gears")

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
   -- All clients will match this rule.
   { rule = { },
     properties = { border_width = beautiful.border_width,
                    border_color = beautiful.border_normal,
                    focus = awful.client.focus.filter,
                    raise = true,
                    keys = clientkeys,
                    buttons = clientbuttons,
                    screen = awful.screen.preferred,
                    placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                    size_hints_honor = false,
     }
   },

   -- Floating clients.
   { rule_any = {
        instance = {
           "pinentry",
           "wm_float",
        },
        name = {
           "Event Tester",  -- xev.
        },
     }, properties = { floating = true }
   },
   { rule = { instance = "tmux_default" },
     properties = { tag = awful.screen.focused().tags[1] }
   },
   { rule = { class = "Emacs" },
     properties = { tag = awful.screen.focused().tags[2] }
   },
   { rule = { class = "Firefox" },
     properties = { tag = awful.screen.focused().tags[5] }
   },
}

