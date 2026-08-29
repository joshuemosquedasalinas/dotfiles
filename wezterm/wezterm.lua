-- WezTerm config cross-platform (macOS + Linux)
local wezterm = require("wezterm")
local config = wezterm.config_builder()
local is_mac = wezterm.target_triple:find("darwin") ~= nil
config.front_end = is_mac and "WebGpu" or "OpenGL"
  if not is_mac then
  config.enable_wayland = false
end
config.ssh_domains = {
  {
    name = "pop-os",
    remote_address = "pop-os",
    username = "joshuemosquedasalinas",
  },
}

-- Appearance
local pal = {
  fg             = "#1a1a1a",
  fg_muted       = "#404040",
  fg_faint       = "#595959",
  divider        = "#a3a3a3",
  surface        = "#e4e4e4",
  surface_active = "#ececec",
  red            = "#8f2727",
  green          = "#225e31",
  yellow         = "#705214",
  blue           = "#204a87",
  magenta        = "#752c61",
  cyan           = "#175e5e",
  orange         = "#9c4314",
}
-- Paper-like background: a barely-there vertical gradient with per-pixel
local PAPER_LO    = "#d2d2d2"
local PAPER_HI    = "#d6d6d6"
local PAPER_NOISE = 200

-- IBM Plex Mono, Medium weight. Not a Nerd Font — WezTerm falls back to its
-- bundled symbols font for the status-bar glyphs.
config.font = wezterm.font("IBM Plex Mono", { weight = "Medium" })
config.font_size = is_mac and 13.0 or 12.0
config.line_height = 1.1
-- Window opacity: 1.0 = opaque. Lower it to let the desktop show through.
config.window_background_opacity = 1.0
config.background = {
  {
    source = {
      Gradient = {
        colors = { PAPER_LO, PAPER_HI },
        orientation = "Vertical",
        noise = PAPER_NOISE,
      },
    },
    width = "100%",
    height = "100%",
  },
}
config.window_decorations = is_mac and "INTEGRATED_BUTTONS | RESIZE" or "RESIZE"
-- Inactive panes recede: pigments drop to half saturation (accents go muddy)
-- and brightness eases to 88%.
config.inactive_pane_hsb = { saturation = 0.5, brightness = 0.88 }
config.default_cursor_style = "BlinkingBar"
config.adjust_window_size_when_changing_font_size = false
config.initial_cols = 120
config.initial_rows = 72
config.window_padding = {
  left = 8,
  right = 8,
  top = is_mac and 52 or 8,
  bottom = 4,
}
config.window_frame = {
  border_bottom_height = "0.5cell",
  border_bottom_color = PAPER_HI,
}
-- On a light background "white" and "bright white" foreground text must
-- render as ink, not paper — otherwise apps that colour text with ANSI 7/15
-- (e.g. the agy TUI) are unreadable. Hues stay saturated; only the greys move.
local ansi = {
  pal.fg,      -- 0 black
  pal.red,     -- 1 red
  pal.green,   -- 2 green
  pal.yellow,  -- 3 yellow
  pal.blue,    -- 4 blue
  pal.magenta, -- 5 magenta
  pal.cyan,    -- 6 cyan
  pal.fg,      -- 7 white  -> normal ink
}
local brights = {
  pal.fg_faint, -- 8  bright black -> a real dim grey
  pal.red,      -- 9  bright red
  pal.green,    -- 10 bright green
  pal.yellow,   -- 11 bright yellow
  pal.blue,     -- 12 bright blue
  pal.magenta,  -- 13 bright magenta
  pal.cyan,     -- 14 bright cyan
  pal.fg,       -- 15 bright white -> normal ink
}
config.colors = {
  foreground = pal.fg,
  cursor_bg = pal.orange,
  cursor_fg = pal.surface,
  cursor_border = pal.orange,
  selection_bg = pal.surface_active,
  selection_fg = pal.fg,
  split = pal.divider,
  scrollbar_thumb = pal.fg_faint,
  ansi = ansi,
  brights = brights,
  tab_bar = { background = "rgba(0,0,0,0)" },
}

-- Command palette / InputSelector overlay styling (fits the paper theme)
config.command_palette_bg_color = pal.surface
config.command_palette_fg_color = pal.fg
config.command_palette_font_size = is_mac and 13.0 or 12.0
config.command_palette_rows = 6

-- Tab bar (kept minimal / hidden chrome) 
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.show_tabs_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.tab_bar_at_bottom = true

-- Behavior 
config.window_close_confirmation = "NeverPrompt"
config.max_fps = 120
config.enable_kitty_graphics = true
config.scrollback_lines = 10000

--  Keybindings (Linux Leader = Ctrl+a | MacOS Leader = CMD+a)
config.leader = {
  key = "a",
  mods = is_mac and "CMD" or "CTRL",
  timeout_milliseconds = 1000,
}
-- Status helpers (async, file-backed)
local REFRESH_SECONDS = 1
local CACHE_DIR = (os.getenv("XDG_CACHE_HOME") or (wezterm.home_dir .. "/.cache")) .. "/wezterm"
local STATUS_FILE = CACHE_DIR .. "/status"

-- now-playing: Apple Music only.
local NOW_PLAYING_SNIPPET = is_mac and [[
np=""
out=$(osascript -e 'if application "Music" is running then
  tell application "Music"
    if player state is playing then
      return name of current track
    end if
  end tell
end if
return ""' 2>/dev/null || true)
[ -n "$out" ] && np="$out"
]] or 'np=""\n'

-- $1 is the current working directory (may be empty).
local STATUS_SCRIPT = table.concat({
  'dir="$1"',
  NOW_PLAYING_SNIPPET,
  'branch=""',
  'if [ -n "$dir" ]; then',
  '  branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null || true)',
  '  [ "$branch" = "HEAD" ] && branch=$(git -C "$dir" rev-parse --short HEAD 2>/dev/null || true)',
  'fi',
  'mkdir -p "' .. CACHE_DIR .. '"',
  'printf "%s\\n%s\\n" "$np" "$branch" > "' .. STATUS_FILE .. '.tmp" && mv "' .. STATUS_FILE .. '.tmp" "' .. STATUS_FILE .. '"',
}, "\n")

local function refresh_status(cwd_path)
  wezterm.background_child_process({ "sh", "-c", STATUS_SCRIPT, "sh", cwd_path or "" })
end

local function read_status()
  local f = io.open(STATUS_FILE, "r")
  if not f then return "", "" end
  local np = f:read("l") or ""
  local branch = f:read("l") or ""
  f:close()
  return np, branch
end

-- Apple Music transport control (macOS). 
local function music(applescript)
  return wezterm.action_callback(function(window, pane)
    if not is_mac then
      return
    end
    local cwd0 = pane:get_current_working_dir()
    local cwd_path = cwd0 and cwd0.file_path or ""
    wezterm.background_child_process({
      "sh",
      "-c",
      'osascript -e \'if application "Music" is running then tell application "Music" to '
        .. applescript
        .. '\' && sleep 0.15 && '
        .. STATUS_SCRIPT,
      "sh",
      cwd_path,
    })
    wezterm.GLOBAL.status_next = 0
  end)
end

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
  -- LEADER s → Choose Horizontal or Vertical split SSH'd into pop-os
  {
    key = "s",
    mods = "LEADER",
    action = wezterm.action.InputSelector({
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
            wezterm.action.SplitHorizontal({
              args = { "ssh", "pop-os" },
            }),
            pane
          )
        elseif id == "v" then
          window:perform_action(
            wezterm.action.SplitVertical({
              args = { "ssh", "pop-os" },
            }),
            pane
          )
        end
      end),
    }),
  },
  -- Apple Music: play/pause, next, previous, restart current track
  { key = "p", mods = "LEADER", action = music("playpause") },
  { key = "n", mods = "LEADER", action = music("next track") },
  { key = "b", mods = "LEADER", action = music("previous track") },
  { key = "0", mods = "LEADER", action = music("set player position to 0") },
  -- LEADER m → prompt, then hand the line to the `music` fuzzy-search CLI
  { key = "m", mods = "LEADER", action = wezterm.action.PromptInputLine({
    description = "music:",
    action = wezterm.action_callback(function(_, _, line)
      if not is_mac or not line or line == "" then return end
      wezterm.background_child_process({ wezterm.home_dir .. "/.local/bin/music", line })
      wezterm.GLOBAL.status_next = 0
    end),
  }) },
}

--  Status bar + hooks
wezterm.on("format-window-title", function() return "" end)

wezterm.on("update-status", function(window, pane)
  -- Kick off a throttled background refresh of the shell-based info.
  local now = os.time()
  if now >= (wezterm.GLOBAL.status_next or 0) then
    wezterm.GLOBAL.status_next = now + REFRESH_SECONDS
    local cwd0 = pane:get_current_working_dir()
    refresh_status(cwd0 and cwd0.file_path or nil)
  end

  local np, branch = read_status()
  local fg = pal.fg_muted

  -- Current working directory (basename).
  local dir = "~"
  local cwd = pane:get_current_working_dir()
  if cwd then
    dir = (cwd.file_path or ""):gsub("/+$", ""):match("([^/]+)$") or "/"
  end

  -- LEFT: now-playing, prefixed by the LEADER hint while it's armed.
  local left = "  "
  if window:leader_is_active() then
    left = left .. wezterm.nerdfonts.oct_rocket .. " LEADER  "
  end
  if np ~= "" then
    left = left .. wezterm.nerdfonts.md_music_note_outline .. " " .. np
  end

  -- MIDDLE: git branch + current dir, centered across the tab bar. 
  local mid = ""
  if branch ~= "" then
    mid = wezterm.nerdfonts.dev_git_branch .. " " .. branch .. "    "
  end
  mid = mid .. wezterm.nerdfonts.cod_folder .. " " .. dir

  local cols
  local ok, tab = pcall(function() return window:mux_window():active_tab() end)
  if ok and tab then
    cols = tab:get_size().cols
  end
  local pad = 2
  if cols then
    pad = math.floor((cols - wezterm.column_width(mid)) / 2) - wezterm.column_width(left)
    if pad < 2 then pad = 2 end
  end

  window:set_left_status(wezterm.format({
    { Background = { Color = "rgba(0,0,0,0)" } },
    { Foreground = { Color = fg } },
    { Text = left .. string.rep(" ", pad) .. mid },
  }))

  -- RIGHT: battery · clock
  local cells = {
    { Background = { Color = "rgba(0,0,0,0)" } },
    { Foreground = { Color = fg } },
  }
  if is_mac then
    for _, b in ipairs(wezterm.battery_info()) do
      local pct = math.floor(b.state_of_charge * 100)
      local icon = b.state == "Charging" and wezterm.nerdfonts.md_battery_charging
        or wezterm.nerdfonts.md_battery
      table.insert(cells, { Text = icon .. " " .. pct .. "%   " })
    end
  end
  table.insert(cells, { Text = wezterm.strftime("%I:%M %p ") })
  window:set_right_status(wezterm.format(cells))
end)

return config
