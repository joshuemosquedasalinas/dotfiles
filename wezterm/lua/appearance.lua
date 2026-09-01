-- Everything visual: font, window, the paper background, the colour table, and
-- the (mostly hidden) tab bar. Colours come from the generated palette.
local wezterm = require("wezterm")
local pal = require("palette")

local M = {}

function M.apply(config, ctx)
  -- IBM Plex Mono, Medium weight. Not a Nerd Font — WezTerm falls back to its
  -- bundled symbols font for the status-bar glyphs.
  config.font = wezterm.font("IBM Plex Mono", { weight = "Medium" })
  config.font_size = ctx.is_mac and 13.0 or 12.0
  config.line_height = 1.1

  -- Paper-like background: a barely-there vertical gradient with per-pixel noise.
  config.window_background_opacity = 1.0
  config.background = {
    {
      source = {
        Gradient = {
          colors = { pal.paper.lo, pal.paper.hi },
          orientation = "Vertical",
          noise = pal.paper.noise,
        },
      },
      width = "100%",
      height = "100%",
    },
  }

  config.window_decorations = ctx.is_mac and "INTEGRATED_BUTTONS | RESIZE" or "RESIZE"
  -- Inactive panes recede: pigments drop to half saturation (accents go muddy)
  -- and brightness eases to 88%.
  config.inactive_pane_hsb = { saturation = 0.5, brightness = 0.88 }
  config.default_cursor_style = "BlinkingBar"
  config.adjust_window_size_when_changing_font_size = false
  config.initial_cols = 120
  config.initial_rows = 72
  config.window_padding = {
    left = 8,
    right = 8,
    top = ctx.is_mac and 52 or 8,
    bottom = 4,
  }
  config.window_frame = {
    border_bottom_height = "0.5cell",
    border_bottom_color = pal.paper.hi,
  }

  -- ANSI 0/7/15 (black + white + bright white) all map to the primary text
  -- colour: on light mode that keeps "white" text as ink, on dark mode it keeps
  -- "black" text legible — otherwise TUIs that colour text with those slots are
  -- unreadable. Hues stay saturated; only the greys move with the mode.
  local ansi = {
    pal.fg,      -- 0 black
    pal.red,     -- 1 red
    pal.green,   -- 2 green
    pal.yellow,  -- 3 yellow
    pal.blue,    -- 4 blue
    pal.magenta, -- 5 magenta
    pal.cyan,    -- 6 cyan
    pal.fg,      -- 7 white  -> normal ink
  }
  local brights = {
    pal.fg_faint, -- 8  bright black -> a real dim grey
    pal.red,      -- 9  bright red
    pal.green,    -- 10 bright green
    pal.yellow,   -- 11 bright yellow
    pal.blue,     -- 12 bright blue
    pal.magenta,  -- 13 bright magenta
    pal.cyan,     -- 14 bright cyan
    pal.fg,       -- 15 bright white -> normal ink
  }
  config.colors = {
    foreground = pal.fg,
    cursor_bg = pal.orange,
    cursor_fg = pal.surface,
    cursor_border = pal.orange,
    selection_bg = pal.surface_active,
    selection_fg = pal.fg,
    split = pal.divider,
    scrollbar_thumb = pal.fg_faint,
    ansi = ansi,
    brights = brights,
    tab_bar = { background = "rgba(0,0,0,0)" },
  }

  -- Command palette / InputSelector overlay styling (fits the paper theme).
  config.command_palette_bg_color = pal.surface
  config.command_palette_fg_color = pal.fg
  config.command_palette_font_size = ctx.is_mac and 13.0 or 12.0
  config.command_palette_rows = 6

  -- Tab bar (kept minimal / hidden chrome).
  config.enable_tab_bar = true
  config.use_fancy_tab_bar = false
  config.show_tabs_in_tab_bar = false
  config.show_new_tab_button_in_tab_bar = false
  config.tab_bar_at_bottom = true

  -- Behaviour.
  config.window_close_confirmation = "NeverPrompt"
  config.max_fps = 120
  config.enable_kitty_graphics = true
  config.scrollback_lines = 10000
end

return M
