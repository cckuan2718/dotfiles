local gears = require("gears")

local helpers = {}

helpers.rrect = function(radius)
   return function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, radius)
   end
end

return helpers
