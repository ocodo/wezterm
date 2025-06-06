local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"
config.colors = {background = "#001218"}

config.font = wezterm.font("OcodoMono Nerd Font", { weight = "Bold"})
config.font_size = 12

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  config.wsl_domains = {
    { name = 'WSL:Ubuntu', distribution = 'Ubuntu' },
  }
  config.default_domain = 'WSL:Ubuntu'
  config.default_prog = { 'powershell.exe' }
end

config.mouse_bindings = {
    -- Right-Click paste
    {
        event = {Down = {streak = 1, button = "Right"}},
        mods = "NONE",
        action = wezterm.action {PasteFrom = "Clipboard"}
    },
    -- CTRL-Left Click open hyperlinks
    {
        event = {Up = {streak = 1, button = "Left"}},
        mods = "CTRL",
        action = "OpenLinkAtMouseCursor"
    },
    -- Left-Click select instant copy
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'NONE',
        action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'Clipboard',
    },
}

-- Scroll to prev / next prompt entry
config.keys = {
  { key = 'UpArrow', mods = 'SHIFT', action = wezterm.action.ScrollToPrompt(-1) },
  { key = 'DownArrow', mods = 'SHIFT', action = wezterm.action.ScrollToPrompt(1) },
}

wezterm.on( "update-right-status", function(window)
    local cal = wezterm.nerdfonts.cod_calendar
    local clock = wezterm.nerdfonts.md_clock_outline
    local date = wezterm.strftime(cal .. "  %d %h  " .. clock .. " %H:%M:%S  ")
    window:set_right_status(
        wezterm.format(
            {
                {Text = date}
            }
        )
    )
end)

wezterm.on('format-tab-title', function (_, _, _, _, _)
    local tab_icon = wezterm.nerdfonts.md_tab
    return {
        { Text = ' ' .. tab_icon .. '       ' },
    }
end)

config.integrated_title_buttons = {
  'Maximize',
  'Hide',
  'Close'
}

local window_min = ' ' .. wezterm.nerdfonts.cod_chevron_down ..  ' '
local window_max = ' ' .. wezterm.nerdfonts.cod_chevron_up .. ' '
local window_close = ' ' .. wezterm.nerdfonts.cod_close .. ' '
local new_tab = ' ' .. wezterm.nerdfonts.md_plus .. ' '
local new_tab_hover = '  ' .. wezterm.nerdfonts.md_tab_unselected .. '   '

config.tab_bar_style = {
    new_tab = new_tab,
    new_tab_hover = new_tab_hover,
    window_hide = window_min,
    window_hide_hover = window_min,
    window_maximize = window_max,
    window_maximize_hover = window_max,
    window_close = window_close,
    window_close_hover = window_close,
}

config.window_close_confirmation = "NeverPrompt"

config.use_fancy_tab_bar = false
config.window_decorations="INTEGRATED_BUTTONS|RESIZE"
config.harfbuzz_features = {"calt=0", "clig=0", "liga=0"}
config.check_for_updates = true
config.text_background_opacity = 0.80
config.window_background_opacity = 0.96

config.window_padding = {
  left = "6px",
  right = "6px",
  top = "6px",
  bottom = "6px"
}

return config
