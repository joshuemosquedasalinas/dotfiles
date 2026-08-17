local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- === Appearance ===
config.color_scheme = "rose-pine-moon"
config.font = wezterm.font("CommitMono Nerd Font") 
config.font_size = 12.0
config.line_height = 1.1
config.colors = {background = "#16161a"}
wezterm.on("format-window-title", function(tab)
  local cwd = tab.active_pane.current_working_dir
  local dir = "~"
  if cwd then
    -- Extract just the folder name from the path
    dir = cwd.file_path:gsub("(.*/)(.*)/?$", "%2")
  end
  return "  " .. dir .. "  "
end)

-- === Window ===
config.window_background_opacity = 0.5
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "TITLE | RESIZE"
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
config.enable_tab_bar = false
config.max_fps = 120
config.enable_kitty_graphics = true

-- === Behavior ===
config.scrollback_lines = 10000
config.default_cursor_style = "BlinkingBar"

--  PANES & KEYBINDINGS
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
  {
    key = "[",
    mods = "LEADER",
    action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "]",
    mods = "LEADER",
    action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  { key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
  { key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
  { key = "LeftArrow",  mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
  { key = "DownArrow",  mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },
  { key = "UpArrow",    mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
  { key = "RightArrow", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
  {
    key = "x",
    mods = "LEADER",
    action = wezterm.action.CloseCurrentPane({ confirm = true }),
  },
}

return config
