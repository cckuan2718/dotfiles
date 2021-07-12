local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("helpers")


-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
                         c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- borders
client.connect_signal("focus",   function(c) c.border_color = beautiful.border_focus  end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- rounded corner
-- set border_radius in theme.lua
if beautiful.border_radius and beautiful.border_radius > 0 then
   client.connect_signal("manage", function (c, startup)
                            if not c.fullscreen and not c.maximized then
                               c.shape = helpers.rrect(beautiful.border_radius)
                            end
   end)

   -- Fullscreen and maximized clients should not have rounded corners
   local function no_round_corners (c)
      if c.fullscreen or c.maximized then
         c.shape = gears.shape.rectangle
      else
         c.shape = helpers.rrect(beautiful.border_radius)
      end
   end

   client.connect_signal("property::fullscreen", no_round_corners)
   client.connect_signal("property::maximized",  no_round_corners)

   beautiful.snap_shape = helpers.rrect(beautiful.border_radius * 2)
else
   beautiful.snap_shape = gears.shape.rectangle
end
