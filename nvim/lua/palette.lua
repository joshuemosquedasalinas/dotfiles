-- Hand-written shim (NOT generated). `require("palette")` returns the active
-- mode's generated colour table (palette_light / palette_dark).
-- Switch modes with the `theme` command; init.lua watches the mode marker and
-- re-applies the colorscheme live.
local cache = vim.env.XDG_CACHE_HOME
if not cache or cache == "" then
  cache = vim.fn.expand("~/.cache")
end
local mode_file = cache .. "/dotfiles/theme-mode"

local mode = "light"
local fd = io.open(mode_file, "r")
if fd then
  local line = (fd:read("l") or ""):gsub("%s+", "")
  fd:close()
  if line == "dark" then
    mode = "dark"
  end
end

return require("palette_" .. mode)
