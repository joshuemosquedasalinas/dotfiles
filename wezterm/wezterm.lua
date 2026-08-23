local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.front_end = "OpenGL"
config.color_scheme = "rose-pine-moon"
config.font = wezterm.font("CommitMono Nerd Font")
config.font_size = 12.0
config.line_height = 1.1
config.window_background_opacity = 0.5
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "TITLE | RESIZE"
config.enable_wayland = false
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
config.colors = {
  background = "#16161a",
  split = "#363636",
  tab_bar = { background = "rgba(0,0,0,0)" },
}

local IMAGE_DIR        = wezterm.home_dir .. "/Pictures/Terminal"
local SHUFFLE_SECONDS  = 120    
local START_WITH_IMAGE = true   
local IMAGE_OPACITY    = 0.50   
local IMAGE_BRIGHTNESS = 0.15   
local HISTORY_MAX      = 200    

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

wezterm.GLOBAL.bg_images = list_images()

if wezterm.GLOBAL.bg_history == nil then
  local hist = {}
  local imgs = wezterm.GLOBAL.bg_images
  if #imgs > 0 then table.insert(hist, imgs[math.random(#imgs)]) end
  wezterm.GLOBAL.bg_history = hist
  wezterm.GLOBAL.bg_pos = 1
end

wezterm.GLOBAL.next_shuffle = wezterm.GLOBAL.next_shuffle or (os.time() + SHUFFLE_SECONDS)
if wezterm.GLOBAL.bg_on == nil then wezterm.GLOBAL.bg_on = START_WITH_IMAGE end

local function current_image()
  local hist = wezterm.GLOBAL.bg_history or {}
  return hist[wezterm.GLOBAL.bg_pos or 1]
end

local function image_layers()
  local img = current_image()
  if not img then return nil end
  return {
    {
      source  = { File = img },
      opacity = IMAGE_OPACITY,
      hsb     = { brightness = IMAGE_BRIGHTNESS },
    },
  }
end

local function apply_bg(window)
  local overrides = window:get_config_overrides() or {}
  if wezterm.GLOBAL.bg_on then
    overrides.background = image_layers()
  else
    overrides.background = nil
  end
  window:set_config_overrides(overrides)
end

local function forward(window)
  local imgs_proxy = wezterm.GLOBAL.bg_images or {}
  local imgs = {}
  for _, v in ipairs(imgs_proxy) do table.insert(imgs, v) end
  if #imgs == 0 then return end
  local hist_proxy = wezterm.GLOBAL.bg_history or {}
  local hist = {}
  for _, v in ipairs(hist_proxy) do table.insert(hist, v) end
  local pos = wezterm.GLOBAL.bg_pos or 1
  if pos < #hist then
    wezterm.GLOBAL.bg_pos = pos + 1
  else
    local cur = hist[pos]
    local choice
    if #imgs == 1 then
      choice = imgs[1]
    else
      repeat choice = imgs[math.random(#imgs)] until choice ~= cur
    end
    table.insert(hist, choice)
    if #hist > HISTORY_MAX then table.remove(hist, 1) end
    wezterm.GLOBAL.bg_pos = #hist
  end
  
  wezterm.GLOBAL.bg_history = hist
  wezterm.GLOBAL.bg_on = true
  wezterm.GLOBAL.next_shuffle = os.time() + SHUFFLE_SECONDS
  apply_bg(window)
end

local function back(window)
  local pos = wezterm.GLOBAL.bg_pos or 1
  if pos > 1 then
    wezterm.GLOBAL.bg_pos = pos - 1
    wezterm.GLOBAL.bg_on = true
    wezterm.GLOBAL.next_shuffle = os.time() + SHUFFLE_SECONDS
    apply_bg(window)
  end
end

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
  -- Browse background images: LEADER n = next (random), LEADER b = back (exact)
  { key = "n", mods = "LEADER", action = wezterm.action_callback(function(win) forward(win) end) },
  { key = "b", mods = "LEADER", action = wezterm.action_callback(function(win) back(win) end) },
}

wezterm.on("format-window-title", function() return "" end)

wezterm.on("update-status", function(window, pane)
  if not wezterm.GLOBAL.started then
    wezterm.GLOBAL.started = true
    apply_bg(window)
  end
  if wezterm.GLOBAL.bg_on and SHUFFLE_SECONDS > 0
    and os.time() >= (wezterm.GLOBAL.next_shuffle or 0) then
    forward(window)
  end
end)

wezterm.on("update-status", function(window, pane)
  if not wezterm.GLOBAL.started then
    wezterm.GLOBAL.started = true
    apply_bg(window)
  end
  
  if wezterm.GLOBAL.bg_on and SHUFFLE_SECONDS > 0
    and os.time() >= (wezterm.GLOBAL.next_shuffle or 0) then
    forward(window)
  end

  local c = { pine = "#3e8fb0", iris = "#c4a7e7", muted = "#6e6a86", bar = "#16161a" }
  local leader = ""
  
  if window:leader_is_active() then
    leader = " " .. wezterm.nerdfonts.oct_rocket .. " LEADER "
  end
  
  window:set_left_status(wezterm.format({
    { Background = { Color = "rgba(0,0,0,0)" } },
    { Foreground = { Color = c.iris } },
    { Text = leader },
  }))
  
  local dir = "~"
  local cwd = pane:get_current_working_dir()
  if cwd then 
    dir = (cwd.file_path or ""):gsub("/+$", ""):match("([^/]+)$") or "/" 
  end
  
  window:set_right_status(wezterm.format({
    { Background = { Color =  "rgba(0,0,0,0)" } },
    { Foreground = { Color = c.iris } },
    { Text = wezterm.nerdfonts.cod_folder .. " " .. dir .. "   " },
    { Foreground = { Color = c.iris } },
    { Text = wezterm.strftime("%H:%M ") },
  }))
end)

wezterm.on("window-resized", function(window, pane)
  apply_bg(window)
end)

return config
