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

local config = wezterm.config_builder()
local platform = require("platform")
local ctx = { is_mac = platform.is_mac }

platform.apply(config, ctx)
require("appearance").apply(config, ctx)
require("keybinds").apply(config, ctx)
require("status").setup(config, ctx)

return config
