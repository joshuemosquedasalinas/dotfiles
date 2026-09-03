-- WezTerm config cross-platform (macOS + Linux).
-- This file just wires the modules together; the substance lives in lua/.
--   lua/palette.lua      generated from theme/palette.json — colours
--   lua/platform.lua     renderer, Wayland, SSH domains
--   lua/appearance.lua   font, window, background, colour table, tab bar
--   lua/status.lua       the bottom status bar + its background refresh
--   lua/music.lua        Apple Music transport + fuzzy-search prompt (macOS)
--   lua/keybinds.lua     leader key and all keybindings
local wezterm = require("wezterm")

-- WezTerm puts the config dir on package.path but not its subdirs; add lua/.
package.path = wezterm.config_dir .. "/lua/?.lua;" .. package.path
wezterm.add_to_config_reload_watch_list(wezterm.config_dir .. "/lua")

local cache = os.getenv("XDG_CACHE_HOME")
if not cache or cache == "" then
  cache = wezterm.home_dir .. "/.cache"
end

-- Light/dark theme marker written by the `theme` command. Watching it means a
-- `theme` switch triggers a full config reload, re-reading lua/palette.lua.
wezterm.add_to_config_reload_watch_list(cache .. "/dotfiles/theme-mode")

-- When `theme-source` is "system", keep the marker in step with the OS
-- appearance. WezTerm re-runs this file on every OS light/dark change, so this
-- is where we notice a mismatch and hand off to `theme --sync` (which rewrites
-- the marker, which Neovim, zsh and Claude Code then follow).
do
  local function first_line(path)
    local f = io.open(path, "r")
    if not f then
      return nil
    end
    local line = f:read("l")
    f:close()
    return line
  end
  local ok, appearance = pcall(function()
    return wezterm.gui.get_appearance()
  end)
  if ok and appearance and first_line(cache .. "/dotfiles/theme-source") == "system" then
    local want = appearance:find("Dark") and "dark" or "light"
    if want ~= first_line(cache .. "/dotfiles/theme-mode") then
      wezterm.background_child_process({ wezterm.home_dir .. "/.local/bin/theme", "--sync" })
    end
  end
end

local config = wezterm.config_builder()
local platform = require("platform")
local ctx = { is_mac = platform.is_mac }

platform.apply(config, ctx)
require("appearance").apply(config, ctx)
require("keybinds").apply(config, ctx)
require("status").setup(config, ctx)

return config
