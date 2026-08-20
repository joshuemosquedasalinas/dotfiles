local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.color_scheme = "rose-pine-moon"
config.font = wezterm.font("CommitMono Nerd Font") 
config.font_size = 12.0
config.line_height = 1.1
config.window_background_opacity = 0.5
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "TITLE | RESIZE"
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
config.enable_tab_bar = true              
config.show_tabs_in_tab_bar = false       
config.show_new_tab_button_in_tab_bar = false
config.use_fancy_tab_bar = false          
config.tab_bar_at_bottom = true          
config.max_fps = 120
config.enable_kitty_graphics = true
config.scrollback_lines = 10000
config.default_cursor_style = "BlinkingBar"
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.inactive_pane_hsb = { saturation = 0.7, brightness = 0.3, }
config.colors = {background = "#16161a", split = "#363636",}
config.keys = {
  { key = "[", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),},
  { key = "]", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),},
  { key = "h",  mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
  { key = "j",  mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },
  { key = "k",    mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
  { key = "l", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
  { key = "LeftArrow", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
  { key = "DownArrow", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
  { key = "UpArrow", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
  { key = "RightArrow", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
  { key = "x", mods = "LEADER",action = wezterm.action.CloseCurrentPane({ confirm = true }),}, }
wezterm.on("format-window-title", function() return "" end)
wezterm.on("update-status", function(window, pane)
  local c = { pine = "#3e8fb0", iris = "#c4a7e7", muted = "#6e6a86" }
  local leader = ""
  if window:leader_is_active() then
    leader = wezterm.format({{ Foreground = { Color = c.iris }},
    { Text = " " .. wezterm.nerdfonts.oct_rocket .. " LEADER " },}) end
    window:set_left_status(leader)
  local dir = "~" local cwd = pane:get_current_working_dir()
  if cwd then dir = (cwd.file_path or ""):gsub("/+$", ""):match("([^/]+)$") or "/" end
  window:set_right_status(wezterm.format({
    { Foreground = { Color = c.pine } },
    { Text = wezterm.nerdfonts.cod_folder .. " " .. dir .. "   " },
    { Foreground = { Color = c.muted } },
    { Text = wezterm.strftime("%H:%M ") }, })) end)
return config
