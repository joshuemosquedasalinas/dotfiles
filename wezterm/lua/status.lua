-- The bottom status bar. The git branch and now-playing values come from a short
-- shell script that runs about once a second and writes a file; the bar reads
-- that file instead of blocking on `git` and `osascript`.
local wezterm = require("wezterm")
local pal = require("palette")

local M = {}

local REFRESH_SECONDS = 1
local CACHE_DIR = (os.getenv("XDG_CACHE_HOME") or (wezterm.home_dir .. "/.cache")) .. "/wezterm"
local STATUS_FILE = CACHE_DIR .. "/status"

-- now-playing: Apple Music only.
local function now_playing_snippet(is_mac)
  return is_mac and [[
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
end

-- The shell snippet that refreshes the status file. $1 is the current working
-- directory (may be empty). Exposed so music.lua can chain it after a transport
-- command and get the now-playing line updated immediately.
function M.script(ctx)
  return table.concat({
    'dir="$1"',
    now_playing_snippet(ctx.is_mac),
    'branch=""',
    'if [ -n "$dir" ]; then',
    '  branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null || true)',
    '  [ "$branch" = "HEAD" ] && branch=$(git -C "$dir" rev-parse --short HEAD 2>/dev/null || true)',
    'fi',
    'mkdir -p "' .. CACHE_DIR .. '"',
    'printf "%s\\n%s\\n" "$np" "$branch" > "' .. STATUS_FILE .. '.tmp" && mv "' .. STATUS_FILE .. '.tmp" "' .. STATUS_FILE .. '"',
  }, "\n")
end

-- Force the next update-status tick to refresh instead of waiting out the throttle.
function M.bump()
  wezterm.GLOBAL.status_next = 0
end

local function refresh_status(ctx, cwd_path)
  wezterm.background_child_process({ "sh", "-c", M.script(ctx), "sh", cwd_path or "" })
end

local function read_status()
  local f = io.open(STATUS_FILE, "r")
  if not f then return "", "" end
  local np = f:read("l") or ""
  local branch = f:read("l") or ""
  f:close()
  return np, branch
end

function M.setup(config, ctx)
  wezterm.on("format-window-title", function() return "" end)

  wezterm.on("update-status", function(window, pane)
    -- Kick off a throttled background refresh of the shell-based info.
    local now = os.time()
    if now >= (wezterm.GLOBAL.status_next or 0) then
      wezterm.GLOBAL.status_next = now + REFRESH_SECONDS
      local cwd0 = pane:get_current_working_dir()
      refresh_status(ctx, cwd0 and cwd0.file_path or nil)
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
    if ctx.is_mac then
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
end

return M
