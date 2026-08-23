local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "rose-pine-moon"
config.font = wezterm.font("CommitMono Nerd Font")
config.font_size = 12.0
config.line_height = 1.1
config.window_background_opacity = 0.5
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "TITLE | RESIZE"
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
config.enable_tab_bar = true
config.show_tabs_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.max_fps = 120
config.enable_kitty_graphics = true
config.scrollback_lines = 10000
config.default_cursor_style = "BlinkingBar"
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.inactive_pane_hsb = { saturation = 0.7, brightness = 0.3 }
config.colors = { background = "#16161a", split = "#363636" }

local IMAGE_DIR       = "/home/joshuemosquedasalinas/Pictures/Terminal"
local SHUFFLE_SECONDS = 600  
local TINT_COLOR      = "#16161a"
local TINT_OPACITY    = 0.55  
local IMAGE_BRIGHTNESS = 0.5  

math.randomseed(os.time())

local function list_images()
  local imgs = {}
  local ok, files = pcall(wezterm.glob, IMAGE_DIR .. "/*")
  if ok and files then
    for _, f in ipairs(files) do
      local ext = (f:lower():match("%.([%w]+)$")) or ""
      if ext == "png" or ext == "jpg" or ext == "jpeg"
        or ext == "gif" or ext == "bmp" then
        table.insert(imgs, f)
      end
    end
  end
  return imgs
end

wezterm.GLOBAL.bg_images     = list_images()
wezterm.GLOBAL.current_image = wezterm.GLOBAL.current_image
  or wezterm.GLOBAL.bg_images[1]
wezterm.GLOBAL.next_shuffle  = wezterm.GLOBAL.next_shuffle
  or (os.time() + SHUFFLE_SECONDS)

local function bg_solid()
  return {
    { source = { Color = TINT_COLOR }, width = "100%", height = "100%" },
  }
end

local function bg_image()
  local img = wezterm.GLOBAL.current_image
  if not img then return bg_solid() end  
  return {
    {
      source = { File = img },
      hsb = { brightness = IMAGE_BRIGHTNESS },
    },
    {
      source = { Color = TINT_COLOR },
      width = "100%",  
      height = "100%",
      opacity = TINT_OPACITY,
    },
  }
end

local function pick_next_image()
  local imgs = wezterm.GLOBAL.bg_images or {}
  if #imgs == 0 then return end
  if #imgs == 1 then wezterm.GLOBAL.current_image = imgs[1]; return end
  local choice = wezterm.GLOBAL.current_image
  while choice == wezterm.GLOBAL.current_image do
    choice = imgs[math.random(#imgs)]
  end
  wezterm.GLOBAL.current_image = choice
end

config.background = bg_image()   

config.keys = {
  { key = "[", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "]", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "h", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
  { key = "j", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },
  { key = "k", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
  { key = "l", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
  { key = "LeftArrow", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
  { key = "DownArrow", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
  { key = "UpArrow", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
  { key = "RightArrow", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
  { key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
}

wezterm.on("format-window-title", function() return "" end)

wezterm.on("update-status", function(window, pane)
  if wezterm.GLOBAL.bg_off then return end           
  if os.time() < (wezterm.GLOBAL.next_shuffle or 0) then return end
  pick_next_image()
  wezterm.GLOBAL.next_shuffle = os.time() + SHUFFLE_SECONDS
  local overrides = window:get_config_overrides() or {}
  overrides.background = bg_image()
  window:set_config_overrides(overrides)
end)

wezterm.on("user-var-changed", function(window, pane, name, value)
  if name ~= "wezbg" then return end
  if value == "toggle" then
    wezterm.GLOBAL.bg_off = not wezterm.GLOBAL.bg_off
    value = wezterm.GLOBAL.bg_off and "solid" or "image"
  elseif value == "next" then
    pick_next_image()
    wezterm.GLOBAL.next_shuffle = os.time() + SHUFFLE_SECONDS
    value = "image"
  end
  local overrides = window:get_config_overrides() or {}
  if value == "solid" then
    wezterm.GLOBAL.bg_off = true
    overrides.background = bg_solid()
  else
    wezterm.GLOBAL.bg_off = false
    overrides.background = bg_image()
  end
  window:set_config_overrides(overrides)
end)

wezterm.on("update-status", function(window, pane)
  local c = { pine = "#3e8fb0", iris = "#c4a7e7", muted = "#6e6a86" }
  local leader = ""
  if window:leader_is_active() then
    leader = wezterm.format({
      { Foreground = { Color = c.iris } },
      { Text = " " .. wezterm.nerdfonts.oct_rocket .. " LEADER " },
    })
  end
  window:set_left_status(leader)
  local dir = "~"
  local cwd = pane:get_current_working_dir()
  if cwd then dir = (cwd.file_path or ""):gsub("/+$", ""):match("([^/]+)$") or "/" end
  window:set_right_status(wezterm.format({
    { Foreground = { Color = c.pine } },
    { Text = wezterm.nerdfonts.cod_folder .. " " .. dir .. "   " },
    { Foreground = { Color = c.muted } },
    { Text = wezterm.strftime("%H:%M ") },
  }))
end)

return config
