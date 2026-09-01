-- Hand-written shim (NOT generated). `require("palette")` returns the active
-- mode's generated colour table (palette_light / palette_dark).
-- Switch modes with the `theme` command; wezterm.lua watches the mode marker
-- and reloads the config when it changes.
local wezterm = require("wezterm")

local cache = os.getenv("XDG_CACHE_HOME")
if not cache or cache == "" then
  cache = wezterm.home_dir .. "/.cache"
end
local mode_file = cache .. "/dotfiles/theme-mode"

local mode = "light"
local f = io.open(mode_file, "r")
if f then
  local line = (f:read("l") or ""):gsub("%s+", "")
  f:close()
  if line == "dark" then
    mode = "dark"
  end
end

return require("palette_" .. mode)
