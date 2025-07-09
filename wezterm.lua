local wezterm = require 'wezterm'
local config = wezterm.config_builder()

local function file_exists(path)
    local f = io.open(path, "r")
    if f~=nil then io.close(f) return true else return false end
end

config.color_scheme = "Catppuccin Mocha"
config.colors = {
   background = "#001218"
}

config.font = wezterm.font("OcodoMonoDotZero Nerd Font Light", 
			   {
			      weight="Light",
			      stretch="Normal",
			      style="Normal"
})

config.font_size = 12

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
   config.wsl_domains = {{
	 name = 'WSL:Ubuntu',
	 distribution = 'Ubuntu'
   }}
   config.default_domain = 'WSL:Ubuntu'
   config.default_prog = {'C:/Program Files/PowerShell/7/pwsh.exe'}

   if file_exists("C:/msys64/msys2_shell.cmd") then
      local launch_msys2 = {
	 label = "MSYS2",
	 args = {"C:/msys64/msys2_shell.cmd",
		 "-defterm",
		 "-no-start",
		 "-use-full-path",
		 "-msys",
		 "-shell",
		 "zsh"},
	 cwd = "C:/msys64/home/" .. os.getenv('USERNAME'),
	 domain = {DomainName="local"},
      }

      config.launch_menu = {
	 launch_msys2,
      }
   end
end

config.mouse_bindings = { -- Right-Click paste
   {
      event = {
	 Down = {
            streak = 1,
            button = "Right"
	 }
      },
      mods = "NONE",
      action = wezterm.action {
	 PasteFrom = "Clipboard"
      }
   }, -- CTRL-Left Click open hyperlinks
   {
      event = {
	 Up = {
            streak = 1,
            button = "Left"
	 }
      },
      mods = "CTRL",
      action = "OpenLinkAtMouseCursor"
   }, -- Left-Click select instant copy
   {
      event = {
	 Up = {
            streak = 1,
            button = 'Left'
	 }
      },
      mods = 'NONE',
      action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'Clipboard'
}}

-- Scroll to prev / next prompt entry
config.keys = {{
      key = 'UpArrow',
      mods = 'SHIFT',
      action = wezterm.action.ScrollToPrompt(-1)
	       }, {
      key = 'DownArrow',
      mods = 'SHIFT',
      action = wezterm.action.ScrollToPrompt(1)
}}

wezterm.on("update-right-status", function(window)
	      local cal = wezterm.nerdfonts.cod_calendar
	      local clock = wezterm.nerdfonts.md_clock_outline
	      local date = wezterm.strftime(cal .. "  %d %h  " .. clock .. " %H:%M:%S  ")
	      window:set_right_status(wezterm.format({{
					       Text = date
	      }}))
end)

wezterm.on('format-tab-title', function(_, _, _, _, _)
	      local tab_icon = wezterm.nerdfonts.md_tab
	      return {{
		    Text = ' ' .. tab_icon .. '       '
	      }}
end)

wezterm.on('window-resized', function(window, pane)
	      local w_width = window:get_dimensions().pixel_width
	      local w_height = window:get_dimensions().pixel_height
	      local w_is_fs = window:get_dimensions().is_full_screen
	      local s_width = wezterm.gui.screens().active.width
	      local s_height = wezterm.gui.screens().active.height

	      if not w_is_fs then
		 if w_height == s_height and w_width == s_width then -- assume maximize
		    title_button_state({
			  maximized = true
		    })
		 else
		    title_button_state({
			  maximized = false
		    })
		 end
	      else
		 title_button_state({
		       fullscreen = true
		 })
	      end
end)

function title_button_state(state)

   if state then
      local is_fullscreen = state.fullscreen
      local is_maximized = state.maximized
   else
      local is_fullscreen = false
      local is_maximized = false
   end

   config.integrated_title_buttons = {'Hide','Maximize','Close'}

   local nf = wezterm.nerdfonts

   local window_min = ' ' .. nf.cod_chrome_minimize .. ' '
   local window_max = ' ' .. nf.cod_chrome_maximize .. ' '
   local window_close = ' ' .. nf.cod_close .. ' '
   local new_tab = ' ' .. nf.md_plus .. ' '
   local new_tab_hover = '  ' .. nf.md_tab_unselected .. '   '

   config.tab_bar_style = {
      new_tab = new_tab,
      new_tab_hover = new_tab_hover,
      window_hide = window_min,
      window_hide_hover = window_min,
      window_maximize = window_max,
      window_maximize_hover = window_max,
      window_close = window_close,
      window_close_hover = window_close
   }
end

title_button_state()

config.window_close_confirmation = "NeverPrompt"

config.use_fancy_tab_bar = false
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.harfbuzz_features = {"calt=0", "clig=0", "liga=0"}
config.check_for_updates = true
config.text_background_opacity = 0.97
config.window_background_opacity = 0.97

config.window_padding = {
   left = "6px",
   right = "6px",
   top = "6px",
   bottom = "6px"
}

return config
