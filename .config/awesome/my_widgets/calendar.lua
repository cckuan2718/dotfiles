local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")
local helpers = require("../helpers")

local calendar_widget = {}

local function worker()

   local calendar_themes = {
      bg = beautiful.bg_normal,
      fg = beautiful.fg_normal,
      focus_date_bg = beautiful.bg_focus,
      focus_date_fg = beautiful.fg_focus,
      header_fg = beautiful.fg_normal,
      border = beautiful.border_normal,
      radius = beautiful.border_radius
   }

   local styles = {}

   styles.month = {
      padding = 4,
      bg_color = calendar_themes.bg,
      border_width = 0,
   }

   styles.normal = {
      markup = function(t) return t end,
      shape = helpers.rrect(calendar_themes.radius)
   }

   styles.focus = {
      fg_color = calendar_themes.focus_date_fg,
      bg_color = calendar_themes.focus_date_bg,
      markup = function(t) return '<b>' .. t .. '</b>' end,
      shape = helpers.rrect(calendar_themes.radius)
   }

   styles.header = {
      fg_color = calendar_themes.header_fg,
      bg_color = calendar_themes.bg,
      markup = function(t) return '<b>' .. t .. '</b>' end
   }

   local function decorate_cell(widget, flag, date)
      if flag == 'monthheader' and not styles.monthheader then
         flag = 'header'
      end

      -- highlight only today's day
      if flag == 'focus' then
         local today = os.date('*t')
         if not (today.month == date.month and today.year == date.year) then
            flag = 'normal'
         end
      end

      local props = styles[flag] or {}
      if props.markup and widget.get_text and widget.set_markup then
         widget:set_markup(props.markup(widget:get_text()))
      end

      local ret = wibox.widget {
         {
            {
               widget,
               halign = 'center',
               widget = wibox.container.place
            },
            margins = (props.padding or 2) + (props.border_width or 0),
            widget = wibox.container.margin
         },
         shape = props.shape,
         shape_border_color = props.border_color or '#000000',
         shape_border_width = props.border_width or 0,
         fg = props.fg_color or calendar_themes.fg,
         bg = props.bg_color or default_bg,
         widget = wibox.container.background
      }

      return ret
   end

   local cal = wibox.widget {
      date = os.date('*t'),
      font = beautiful.get_font(),
      fn_embed = decorate_cell,
      long_weekdays = true,
      widget = wibox.widget.calendar.month
   }

   local popup = awful.popup {
      ontop = true,
      visible = false,
      shape = helpers.rrect(calendar_themes.radius),
      offset = { y = 5 },
      border_width = 1,
      border_color = calendar_themes.border,
      widget = cal
   }

   function calendar_widget.toggle()
      if popup.visible then
         -- to faster render the calendar refresh it and just hide
         cal:set_date(nil) -- the new date is not set without removing the old one
         cal:set_date(os.date('*t'))
         popup:set_widget(nil) -- just in case
         popup:set_widget(cal)
         popup.visible = not popup.visible
      else
         awful.placement.top_right(popup, { honor_workarea = true })
         popup.visible = true
      end
   end

   return calendar_widget

end

return setmetatable(calendar_widget, { __call = function(_, ...)
                                          return worker(...)
                   end })
