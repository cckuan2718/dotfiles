--
-- luakit userconf.lua
--

--
-- Libraries
--

local settings = require("settings")
local downloads = require("downloads")
local modes = require("modes")
local window = require("window")
local webview = require("webview")
local select = require("select")
local follow = require("follow")

--
-- General Configurations
--

settings.window.home_page = "https://www.google.com/"
settings.window.new_tab_page = "https://www.google.com/"

settings.window.search_engines = {
   aw = "https://wiki.archlinux.org/index.php?search=%s",
   gh = "https://github.com/search?q=%s",
   gm = "https://www.google.com/maps?q=%s",
   gg = "https://www.google.com/search?q=%s",
   mba = "https://musicbrainz.org/search?query=%s&type=artist",
   mbr = "https://musicbrainz.org/search?query=%s&type=release",
   op = "https://openports.se/search.php?so=%s",
   so = "https://stackoverflow.com/search?q=%s",
   utd = "https://www.uptodate.com/contents/search?search=%s&searchType=PLAIN_TEXT&source=USER_INPUT&searchControl=TOP_PULLDOWN&autoComplete=false",
   wk = "https://www.wikipedia.org/w/index.php?title=Special:Search&search=%s",
   yt = "https://www.youtube.com/results?search_query=%s",
}
settings.window.default_search_engine = "gg"

settings.webview.media_playback_requires_gesture = true
downloads.default_dir = os.getenv("HOME") .. "/downloads"

--
-- User interface
--

settings.webview.zoom_level = 125
settings.application.prefer_dark_mode = true

--
-- Key bindings
--

-- follow/select mode
follow.ignore_case = true
select.label_maker = function ()
   local chars = charset("aoeuidhtns")
   return trim(sort(reverse(chars)))
end

-- Add binds to special mode "all" which adds its binds to all modes.
modes.add_binds("all", {
   { "<C-g>", "Return to `normal` mode.", function (w)
        if not w:is_mode("passthrough") then
           w:set_prompt()
           w:set_mode()
        end
        return not w:is_mode("passthrough")
   end },
   { "<Mod1-w>", "Copy selected text.", function ()
       luakit.selection.clipboard = luakit.selection.primary
   end},
   {"<C-y>", "Insert contents of clipboard at cursor position.", function (w)
       local str = luakit.selection.clipboard
       if not str then return end
       local i = w.ibar.input
       local text = i.text
       local pos = i.position
       local left, right = string.sub(text, 1, pos), string.sub(text, pos+1)
       i.text = left .. str .. right
       i.position = pos + #str
   end},
})

-- normal mode
local actions = { scroll = {
   up = {
      desc = "Scroll the current page up.",
      func = function (w, m) w:scroll{ yrel = -settings.get_setting("window.scroll_step")*(m.count or 1) } end,
   },
   down = {
      desc = "Scroll the current page down.",
      func = function (w, m) w:scroll{ yrel =  settings.get_setting("window.scroll_step")*(m.count or 1) } end,
   },
   left = {
      desc = "Scroll the current page left.",
      func = function (w, m) w:scroll{ xrel = -settings.get_setting("window.scroll_step")*(m.count or 1) } end,
   },
   right = {
      desc = "Scroll the current page right.",
      func = function (w, m) w:scroll{ xrel =  settings.get_setting("window.scroll_step")*(m.count or 1) } end,
   },
   left_most = {
      desc = "Scroll to the absolute left of the document.",
      func = function (w) w:scroll{ x =  0 } end,
   },
   right_most = {
      desc = "Scroll to the absolute right of the document.",
      func = function (w) w:scroll{ x =  -1 } end,
   },
   page_up = {
      desc = "Scroll the current page up a full screen.",
      func = function (w, m) w:scroll{ ypagerel = -(m.count or 1) } end,
   },
   page_down = {
      desc = "Scroll the current page down a full screen.",
      func = function (w, m) w:scroll{ ypagerel =  (m.count or 1) } end,
   },
}, go = {
   top = {
      desc = "Scroll to the top of the document.",
      func = function (w) w:scroll{ y = 0 } end,
   },
   bottom = {
      desc = "Scroll to the bottom of the document.",
      func = function (w) w:scroll{ y = -1 } end,
   },
   percent = {
      desc = "Go to `[count]` percent of the document.",
      func = function (w, m) w:scroll{ ypct = m.count } end,
   }
}, zoom = {
   zoom_in = {
      desc = "Zoom in to the current page.",
      func = function (w, m) w:zoom_in(settings.get_setting("window.zoom_step") * (m.count or 1)) end,
   },
   zoom_out = {
      desc = "Zoom out from the current page.",
      func = function (w, m) w:zoom_out(settings.get_setting("window.zoom_step") * (m.count or 1)) end,
   },
   zoom_set = {
      desc = "Zoom to a specific percentage when specifying a count, and reset the page zoom otherwise.",
      func = function (w, m)
         local zoom_level = m.count or settings.get_setting_for_view(w.view, "webview.zoom_level")
         w:zoom_set(zoom_level/100)
      end,
   },
}}

modes.remove_binds("normal", {"j", "k", "h", "l", "0", "^", "$", "i", "w", "y", "Y", "M", "u", "%",
                              "gg", "zi", "zo", "zz", "pp", "pt", "pw", "pp", "PP", "PT", "PW",
                              "gT", "gt", "g0", "g$", "gH", "gh", "gy", "ZZ", "ZQ",
                              "<Control-f>", "<Control-b>",
                              "<Control-e>", "<Control-y>", "<Control-d>", "<Control-u>",
                              "<Control-o>", "<Control-i>", "<Control-a>", "<Control-x>",
                              "<Control-w>", "<Control-c>", "<Control-R>",
                              "<Shift-h>", "<Shift-l>", "<Shift-w>", "<Shift-j>", "<Shift-k>", "<Shift-d>",
                              "<space>", "<Shift-space>",
                              "+", "<Minus>", "=",
                              "o", "t", "<Shift-o>", "<Shift-t>", "<Control-t>",
                              "d", "r", "ga", "gA", "gd", "gD",
                              "/", "?"})

modes.remap_binds("normal", {
                     {"b", "B", false},
                     {"B", "gB", false},
})

modes.add_binds("normal", {
   -- Scrolling
   { "<C-n>", actions.scroll.down },
   { "<C-p>", actions.scroll.up },
   { "<C-b>", actions.scroll.left },
   { "<C-f>", actions.scroll.right },
   { "<C-a>", actions.scroll.left_most },
   { "<C-e>", actions.scroll.right_most },
   { "<C-v>", actions.scroll.page_down },
   { "<Mod1-v>", actions.scroll.page_up },

   -- Specific scroll
   { "<Mod1-<>", actions.go.top },
   { "<Mod1->>", actions.go.bottom },
   { "<Mod1-g>", actions.go.percent },

    -- Zoom
   { "<C-=>", actions.zoom.zoom_in },
   { "<C-Minus>", actions.zoom.zoom_out },
   { "<C-0>", actions.zoom.zoom_set },

   -- Yanking/pasting
   {"w", "Yank current URI to clipboard.", function (w)
       local uri = string.gsub(w.view.uri or "", " ", "%%20")
       luakit.selection.clipboard = uri
       w:notify("Yanked uri (to clipboard): " .. uri)
   end },

    -- Commands
   { "G", "Open one or more URLs.", function (w) w:enter_cmd(":open ") end },
   { "<Mod1-Return>", "Open one or more URLs in a new tab.", function (w) w:enter_cmd(":tabopen ") end },

   { "l", "Go back in the browser history `[count=1]` items.", function (w, m) w:back(m.count) end },
   { "r", "Go forward in the browser history `[count=1]` times.", function (w, m) w:forward(m.count) end },

   { "<Mod1-p>", "Go back in the browser history.", function (w, m) w:back(m.count) end },
   { "<Mod1-n>", "Go forward in the browser history.", function (w, m) w:forward(m.count) end },

    -- Tab
   { "<Mod1-b>", "Go to previous tab.", function (w) w:prev_tab() end },
   { "<Mod1-f>", "Go to next tab.", function (w) w:next_tab() end },

   { "<C-k>", "Close current tab (or `[count]` tabs).",
        function (w, m) for _=1,m.count do w:close_tab() end end, {count=1} },

   { "g", "Reload current tab.", function (w) w:reload() end },

    -- Window
   { "<C-c>", "Quit and save the session.", function (w) w:save_session() w:close_win() end },

   -- search
   { "<C-s>", "Search for string on current page.",
     function (w) w:start_search("/") end },
   { "<C-r>", "Reverse search for string on current page.",
     function (w) w:start_search("?") end },

})

modes.add_binds("insert", {
   { "<C-z>", "Enter `passthrough` mode, ignores all luakit keybindings.",
     function (w) w:set_mode("passthrough") end },
})

modes.add_binds("passthrough", {
   { "<C-g>", "Return to `normal` mode.", function (w) w:set_prompt(); w:set_mode() end },
})

