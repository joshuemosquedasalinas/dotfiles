local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.color_scheme = "rose-pine-moon"
config.font = wezterm.font("CommitMono Nerd Font") 
config.font_size = 12.0
config.line_height = 1.1
config.colors = {background = "#16161a"}
config.window_background_opacity = 0.5
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "TITLE | RESIZE"
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
config.enable_tab_bar = true              -- required for status areas
config.show_tabs_in_tab_bar = false       -- ...but no actual tabs
config.show_new_tab_button_in_tab_bar = false
config.use_fancy_tab_bar = false          -- retro style = uses your terminal font
config.tab_bar_at_bottom = true           -- sit it at the bottom like a status line
config.max_fps = 120
config.enable_kitty_graphics = true
config.scrollback_lines = 10000
config.default_cursor_style = "BlinkingBar"
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
wezterm.on("format-window-title", function(tab, pane, tabs, panes)
  local dir = "~"
  local cwd = tab.active_pane.current_working_dir
  if cwd then
    dir = (cwd.file_path or ""):gsub("/+$", ""):match("([^/]+)$") or "/"
  end
  local parts = { wezterm.nerdfonts.cod_folder .. " " .. dir }
  if #panes > 1 then  -- how many splits in this tab
    table.insert(parts, wezterm.nerdfonts.cod_multiple_windows .. " " .. #panes)
  end
  if tab.active_pane.is_zoomed then  -- zoom state
    table.insert(parts, wezterm.nerdfonts.md_fullscreen)
  end
  return "  " .. table.concat(parts, "  ") .. "  "
end)
wezterm.on("update-status", function(window, pane)
  local c = { pine = "#3e8fb0", iris = "#c4a7e7", muted = "#6e6a86" }
  local leader = ""
  if window:leader_is_active() then
    leader = wezterm.format({
      { Foreground = { Color = c.iris } },
      { Text = " " .. wezterm.nerdfonts.oct_rocket .. " LEADER " },
    })
  end
  window:set_left_status(leader)
  local dir = "~"
  local cwd = pane:get_current_working_dir()
  if cwd then
    dir = (cwd.file_path or ""):gsub("/+$", ""):match("([^/]+)$") or "/"
  end
  window:set_right_status(wezterm.format({
    { Foreground = { Color = c.pine } },
    { Text = wezterm.nerdfonts.cod_folder .. " " .. dir .. "   " },
    { Foreground = { Color = c.muted } },
    { Text = wezterm.strftime("%H:%M ") },
  }))
end)
return config
