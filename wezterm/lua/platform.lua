-- Platform detection and OS-specific wiring (renderer, Wayland, SSH domains).
local wezterm = require("wezterm")

local M = {}

M.is_mac = wezterm.target_triple:find("darwin") ~= nil

function M.apply(config, ctx)
  config.front_end = ctx.is_mac and "WebGpu" or "OpenGL"
  if not ctx.is_mac then
    config.enable_wayland = false
  end

  -- pop-os SSH domain is specific to my network — change or drop this block.
  config.ssh_domains = {
    {
      name = "pop-os",
      remote_address = "pop-os",
      username = "joshuemosquedasalinas",
    },
  }
end

return M
