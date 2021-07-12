local awful = require("awful")
local naughty = require("naughty")
local wibox = require("wibox")

local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local xct = xresources.get_current_theme()

local batteryarc_widget = {}

local function worker()

   local font = "Iosevka 12"
   local arc_thickness = 2
   local show_current_level = true
   local size =  30
   local timeout = 10

   -- arc
   local bg_color = beautiful.bg_normal
   local low_level_color = xct.color9
   local medium_level_color = xct.color13
   local high_level_color = beautiful.fg_normal

   -- text
   local charging_color_bg = xct.color10
   local discharging_color_bg = xct.color11
   local charging_color_fg = beautiful.bg_normal
   local discharging_color_fg = beautiful.bg_normal

   local text = wibox.widget {
      font = font,
      align = 'center',
      valign = 'center',
      widget = wibox.widget.textbox
   }

   local text_with_background = wibox.container.background(text)

   batteryarc_widget = wibox.widget {
      text_with_background,
      max_value = 100,
      rounded_edge = true,
      thickness = arc_thickness,
      start_angle = 4.71238898, -- 2pi*3/4
      forced_height = size,
      forced_width = size,
      bg = bg_color,
      paddings = 2,
      widget = wibox.container.arcchart
   }

   local function update_widget(widget, stdout)
      local charge = 0
      local status = 0
      for s in stdout:gmatch("[^\r\n]+") do
         local status_str, charge_str = s:match('(%d+):(%d+)')
         if status_str ~= nil and charge_str ~= nil then
            local cur_status = tonumber(status_str)
            local cur_charge = tonumber(charge_str)
            if cur_charge > charge then
               status = cur_status
               charge = cur_charge
            end
         end
      end

      widget.value = charge

      if status == 1 then
         text_with_background.bg = charging_color_bg
         text_with_background.fg = charging_color_fg
      else
         text_with_background.bg = discharging_color_bg
         text_with_background.fg = discharging_color_fg
      end

      -- if battery is fully charged (100) there is not enough place for
      -- three digits, so we don't show any text
      if charge == 100 then
         text.text =  ''
      else
         text.text = string.format('%d', charge)
      end

      if charge < 15 then
         widget.colors = { low_level_color }
      elseif charge > 15 and charge < 40 then
         widget.colors = { medium_level_color }
      else
         widget.colors = { high_level_color }
      end
   end

   awful.widget.watch([[sh -c 'printf '%s:%s' "$(apm -a)" "$(apm -l)"']],
      timeout,
      update_widget,
      batteryarc_widget)

   return batteryarc_widget

end

return setmetatable(batteryarc_widget, { __call = function(_, ...)
                                            return worker(...)
                   end })
