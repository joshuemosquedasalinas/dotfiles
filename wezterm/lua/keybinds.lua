-- Leader key and all keybindings. Leader is Cmd+a on macOS, Ctrl+a on Linux.
local wezterm = require("wezterm")
local pal = require("palette")
local music = require("music")

local M = {}

-- LEADER s → pick a split direction, then open it already SSH'd into pop-os.
local function ssh_split_picker()
  return wezterm.action.InputSelector({
    title = "SSH (pop-os) — Select Split Direction",
    choices = {
      {
        id = "h",
        label = wezterm.format({
          { Attribute = { Intensity = "Bold" } },
          { Foreground = { Color = pal.blue } },
          { Text = "  1. Horizontal Split  " },
          { Attribute = { Intensity = "Normal" } },
          { Foreground = { Color = pal.fg_muted } },
          { Text = "— Side-by-side (Left / Right)" },
        }),
      },
      {
        id = "v",
        label = wezterm.format({
          { Attribute = { Intensity = "Bold" } },
          { Foreground = { Color = pal.cyan } },
          { Text = "  2. Vertical Split    " },
          { Attribute = { Intensity = "Normal" } },
          { Foreground = { Color = pal.fg_muted } },
          { Text = "— Stacked (Top / Bottom)" },
        }),
      },
    },
    action = wezterm.action_callback(function(window, pane, id, label)
      if not id then
        return
      end
      if id == "h" then
        window:perform_action(
          wezterm.action.SplitHorizontal({ args = { "ssh", "pop-os" } }),
          pane
        )
      elseif id == "v" then
        window:perform_action(
          wezterm.action.SplitVertical({ args = { "ssh", "pop-os" } }),
          pane
        )
      end
    end),
  })
end

function M.apply(config, ctx)
  config.leader = {
    key = "a",
    mods = ctx.is_mac and "CMD" or "CTRL",
    timeout_milliseconds = 1000,
  }

  config.keys = {
    -- Splits
    { key = "[", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "]", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
    -- Resize active pane
    { key = "h", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
    { key = "j", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },
    { key = "k", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
    { key = "l", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
    -- Move between panes
    { key = "LeftArrow",  mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
    { key = "DownArrow",  mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
    { key = "UpArrow",    mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
    { key = "RightArrow", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
    -- Close pane
    { key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
    -- SSH split picker
    { key = "s", mods = "LEADER", action = ssh_split_picker() },
    -- Apple Music: play/pause, next, previous, restart current track
    { key = "p", mods = "LEADER", action = music.control(ctx, "playpause") },
    { key = "n", mods = "LEADER", action = music.control(ctx, "next track") },
    { key = "b", mods = "LEADER", action = music.control(ctx, "previous track") },
    { key = "0", mods = "LEADER", action = music.control(ctx, "set player position to 0") },
    -- LEADER m → prompt, then hand the line to the `music` fuzzy-search CLI
    { key = "m", mods = "LEADER", action = music.search(ctx) },
  }
end

return M
