-- WezTerm config cross-platform (macOS + Linux).
-- This file just wires the modules together; the substance lives in lua/.
--   lua/palette.lua      generated from theme/palette.json — colours
--   lua/platform.lua     renderer, Wayland, SSH domains
--   lua/appearance.lua   font, window, paper background, colour table, tab bar
--   lua/status.lua       the bottom status bar + its background refresh
--   lua/music.lua        Apple Music transport + fuzzy-search prompt (macOS)
--   lua/keybinds.lua     leader key and all keybindings
local wezterm = require("wezterm")

-- WezTerm puts the config dir on package.path but not its subdirs; add lua/.
package.path = wezterm.config_dir .. "/lua/?.lua;" .. package.path
wezterm.add_to_config_reload_watch_list(wezterm.config_dir .. "/lua")

-- Light/dark theme marker written by the `theme` command. Watching it means a
-- `theme` switch triggers a full config reload, re-reading lua/palette.lua.
do
  local cache = os.getenv("XDG_CACHE_HOME")
  if not cache or cache == "" then
    cache = wezterm.home_dir .. "/.cache"
  end
  wezterm.add_to_config_reload_watch_list(cache .. "/dotfiles/theme-mode")
end

local config = wezterm.config_builder()
local platform = require("platform")
local ctx = { is_mac = platform.is_mac }

platform.apply(config, ctx)
require("appearance").apply(config, ctx)
require("keybinds").apply(config, ctx)
require("status").setup(config, ctx)

return config
