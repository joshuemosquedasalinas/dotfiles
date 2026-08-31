-- Apple Music control (macOS only). Transport actions drive Music.app through
-- AppleScript in the background — no windows, no focus stealing — then chain the
-- status refresh so the now-playing line updates right away.
local wezterm = require("wezterm")
local status = require("status")

local M = {}

-- Build a key action that runs one `tell application "Music" to <applescript>`.
function M.control(ctx, applescript)
  return wezterm.action_callback(function(window, pane)
    if not ctx.is_mac then
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
        .. status.script(ctx),
      "sh",
      cwd_path,
    })
    status.bump()
  end)
end

-- Prompt for a line and hand it to the `music` fuzzy-search CLI.
function M.search(ctx)
  return wezterm.action.PromptInputLine({
    description = "music:",
    action = wezterm.action_callback(function(_, _, line)
      if not ctx.is_mac or not line or line == "" then
        return
      end
      wezterm.background_child_process({ wezterm.home_dir .. "/.local/bin/music", line })
      status.bump()
    end),
  })
end

return M
