vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.number = true          
vim.opt.relativenumber = true  
vim.opt.tabstop = 2           
vim.opt.shiftwidth = 2        
vim.opt.expandtab = true       
vim.opt.smartindent = true     
vim.opt.ignorecase = true      
vim.opt.smartcase = true       
vim.opt.hlsearch = true        
vim.opt.termguicolors = true   
vim.opt.signcolumn = "yes"     
vim.opt.cursorline = true      
vim.opt.wrap = false           
vim.opt.mouse = "a"            
vim.opt.clipboard = "unnamedplus" 
vim.opt.scrolloff = 8          
vim.opt.undofile = true        
vim.opt.updatetime = 250       
-- Colorscheme: "Deep Archival Inks" — dark ink on the terminal's paper background.
-- Palette source: ~/Vault/3. Winner - Gemini Pro.md
vim.opt.background = "light"
local pal = {
  fg = "#1a1a1a", fg_muted = "#404040", fg_faint = "#595959",
  divider = "#a3a3a3", surface = "#e4e4e4", surface_active = "#ececec",
  red = "#8f2727", green = "#225e31", yellow = "#705214", blue = "#204a87",
  magenta = "#752c61", cyan = "#175e5e", orange = "#9c4314",
}
local theme_groups = {
  -- Base / UI
  Normal = { fg = pal.fg, bg = "NONE" },
  NormalNC = { fg = pal.fg, bg = "NONE" },
  NormalFloat = { fg = pal.fg, bg = "NONE" },
  FloatBorder = { fg = pal.divider, bg = "NONE" },
  FloatTitle = { fg = pal.blue, bold = true },
  SignColumn = { bg = "NONE" },
  EndOfBuffer = { fg = pal.fg_faint, bg = "NONE" },
  ColorColumn = { bg = pal.surface },
  CursorLine = { bg = pal.surface },
  CursorColumn = { bg = pal.surface },
  CursorLineNr = { fg = pal.orange, bold = true },
  LineNr = { fg = pal.fg_faint },
  Visual = { bg = pal.surface_active },
  Search = { fg = pal.surface, bg = pal.yellow },
  IncSearch = { fg = pal.surface, bg = pal.orange },
  CurSearch = { fg = pal.surface, bg = pal.orange },
  MatchParen = { fg = pal.orange, bg = pal.surface_active, bold = true },
  Pmenu = { fg = pal.fg, bg = pal.surface },
  PmenuSel = { fg = pal.fg, bg = pal.surface_active, bold = true },
  PmenuSbar = { bg = pal.surface },
  PmenuThumb = { bg = pal.fg_faint },
  WinSeparator = { fg = pal.divider },
  VertSplit = { fg = pal.divider },
  Folded = { fg = pal.fg_muted, bg = pal.surface },
  FoldColumn = { fg = pal.fg_faint, bg = "NONE" },
  NonText = { fg = pal.fg_faint },
  SpecialKey = { fg = pal.fg_faint },
  Whitespace = { fg = pal.divider },
  Directory = { fg = pal.blue },
  Title = { fg = pal.blue, bold = true },
  Question = { fg = pal.green },
  MoreMsg = { fg = pal.green },
  ModeMsg = { fg = pal.fg_muted },
  WarningMsg = { fg = pal.yellow },
  ErrorMsg = { fg = pal.red },
  StatusLine = { fg = pal.fg, bg = pal.surface },
  StatusLineNC = { fg = pal.fg_faint, bg = pal.surface },
  TabLine = { fg = pal.fg_muted, bg = pal.surface },
  TabLineFill = { bg = pal.surface },
  TabLineSel = { fg = pal.fg, bg = pal.surface_active, bold = true },
  WildMenu = { fg = pal.fg, bg = pal.surface_active },
  Cursor = { fg = pal.surface, bg = pal.orange },
  TermCursor = { fg = pal.surface, bg = pal.orange },
  Todo = { fg = pal.fg, bg = pal.yellow, bold = true },
  -- Syntax (classic groups; Treesitter captures inherit these unless set below)
  Comment = { fg = pal.fg_muted, italic = true },
  Operator = { fg = pal.fg_muted },
  Delimiter = { fg = pal.fg_muted },
  Identifier = { fg = pal.fg },
  Keyword = { fg = pal.magenta },
  Statement = { fg = pal.magenta },
  Conditional = { fg = pal.magenta },
  Repeat = { fg = pal.magenta },
  Label = { fg = pal.magenta },
  Exception = { fg = pal.magenta },
  PreProc = { fg = pal.magenta },
  Include = { fg = pal.magenta },
  Define = { fg = pal.magenta },
  Macro = { fg = pal.magenta },
  Type = { fg = pal.cyan },
  StorageClass = { fg = pal.cyan },
  Structure = { fg = pal.cyan },
  Typedef = { fg = pal.cyan },
  Function = { fg = pal.blue },
  Constant = { fg = pal.orange },
  Number = { fg = pal.orange },
  Float = { fg = pal.orange },
  Boolean = { fg = pal.orange },
  String = { fg = pal.green },
  Character = { fg = pal.green },
  Special = { fg = pal.orange },
  SpecialChar = { fg = pal.orange },
  Underlined = { fg = pal.blue, underline = true },
  -- Treesitter captures
  ["@variable"] = { fg = pal.fg },
  ["@variable.builtin"] = { fg = pal.red },
  ["@variable.parameter"] = { fg = pal.blue },
  ["@parameter"] = { fg = pal.blue },
  ["@field"] = { fg = pal.fg },
  ["@property"] = { fg = pal.fg },
  ["@comment"] = { fg = pal.fg_muted, italic = true },
  ["@keyword"] = { fg = pal.magenta },
  ["@keyword.function"] = { fg = pal.magenta },
  ["@keyword.return"] = { fg = pal.magenta },
  ["@keyword.operator"] = { fg = pal.magenta },
  ["@function"] = { fg = pal.blue },
  ["@function.call"] = { fg = pal.blue },
  ["@function.builtin"] = { fg = pal.blue },
  ["@function.method"] = { fg = pal.blue },
  ["@function.method.call"] = { fg = pal.blue },
  ["@constructor"] = { fg = pal.cyan },
  ["@type"] = { fg = pal.cyan },
  ["@type.builtin"] = { fg = pal.cyan },
  ["@type.definition"] = { fg = pal.cyan },
  ["@constant"] = { fg = pal.orange },
  ["@constant.builtin"] = { fg = pal.orange },
  ["@number"] = { fg = pal.orange },
  ["@boolean"] = { fg = pal.orange },
  ["@string"] = { fg = pal.green },
  ["@string.escape"] = { fg = pal.green, bold = true },
  ["@string.special"] = { fg = pal.orange },
  ["@operator"] = { fg = pal.fg_muted },
  ["@punctuation"] = { fg = pal.fg_muted },
  ["@punctuation.bracket"] = { fg = pal.fg_muted },
  ["@punctuation.delimiter"] = { fg = pal.fg_muted },
  ["@punctuation.special"] = { fg = pal.orange },
  ["@tag"] = { fg = pal.magenta },
  ["@tag.attribute"] = { fg = pal.blue },
  ["@tag.delimiter"] = { fg = pal.fg_muted },
  -- Markdown (Treesitter + render-markdown.nvim)
  ["@markup.heading"] = { fg = pal.blue, bold = true },
  ["@markup.heading.1.markdown"] = { fg = pal.blue, bold = true },
  ["@markup.heading.2.markdown"] = { fg = pal.cyan, bold = true },
  ["@markup.heading.3.markdown"] = { fg = pal.green, bold = true },
  ["@markup.heading.4.markdown"] = { fg = pal.yellow, bold = true },
  ["@markup.heading.5.markdown"] = { fg = pal.orange, bold = true },
  ["@markup.heading.6.markdown"] = { fg = pal.magenta, bold = true },
  ["@markup.raw"] = { fg = pal.fg_muted },
  ["@markup.raw.block"] = { fg = pal.fg_muted },
  ["@markup.link"] = { fg = pal.cyan, underline = true },
  ["@markup.link.label"] = { fg = pal.blue },
  ["@markup.list"] = { fg = pal.orange },
  ["@markup.strong"] = { fg = pal.fg, bold = true },
  ["@markup.italic"] = { fg = pal.fg, italic = true },
  ["@markup.quote"] = { fg = pal.fg_muted, italic = true },
  -- Diagnostics
  DiagnosticError = { fg = pal.red },
  DiagnosticWarn = { fg = pal.yellow },
  DiagnosticInfo = { fg = pal.blue },
  DiagnosticHint = { fg = pal.cyan },
  DiagnosticOk = { fg = pal.green },
  DiagnosticUnderlineError = { undercurl = true, sp = pal.red },
  DiagnosticUnderlineWarn = { undercurl = true, sp = pal.yellow },
  DiagnosticUnderlineInfo = { undercurl = true, sp = pal.blue },
  DiagnosticUnderlineHint = { undercurl = true, sp = pal.cyan },
  -- Diff / VCS
  DiffAdd = { fg = pal.green },
  DiffChange = { fg = pal.yellow },
  DiffDelete = { fg = pal.red },
  DiffText = { fg = pal.yellow, bg = pal.surface_active, bold = true },
  Added = { fg = pal.green },
  Changed = { fg = pal.yellow },
  Removed = { fg = pal.red },
  -- LSP
  LspReferenceText = { bg = pal.surface },
  LspReferenceRead = { bg = pal.surface },
  LspReferenceWrite = { bg = pal.surface_active },
  LspSignatureActiveParameter = { fg = pal.orange, bold = true },
  -- Spell
  SpellBad = { undercurl = true, sp = pal.red },
  SpellCap = { undercurl = true, sp = pal.yellow },
  SpellRare = { undercurl = true, sp = pal.cyan },
  SpellLocal = { undercurl = true, sp = pal.blue },
}
local function apply_theme()
  vim.g.colors_name = "archival-inks"
  for group, spec in pairs(theme_groups) do
    vim.api.nvim_set_hl(0, group, spec)
  end
end
apply_theme()
-- Re-apply if another plugin or command loads a colorscheme.
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function(ev)
    if ev.match ~= "archival-inks" then apply_theme() end
  end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", 
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  {
    "ibhagwan/fzf-lua",
    config = function()
      require("fzf-lua").setup({
        winopts = {
          height = 0.85,
          width = 0.85,
          preview = { layout = "vertical" }, 
        },
      })
      local map = vim.keymap.set
      map("n", "<leader>ff", "<cmd>FzfLua files<cr>",     { desc = "Find files" })
      map("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>", { desc = "Grep in project" })
      map("n", "<leader>fb", "<cmd>FzfLua buffers<cr>",   { desc = "Open buffers" })
      map("n", "<leader>fh", "<cmd>FzfLua help_tags<cr>", { desc = "Help tags" })
      map("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>",  { desc = "Recent files" })
    end,
  },
  { "mason-org/mason.nvim", config = true }, 
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",   
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls",          
          "html",           
          "cssls",          
          "emmet_language_server", 
          "rust_analyzer",  
          "gopls",          
          "marksman",       
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",            
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc",
          "python", "javascript", "typescript", "tsx",
          "html", "css", "json", "yaml", "toml",
          "bash", "markdown", "markdown_inline",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",  
      "nvim-tree/nvim-web-devicons",     
    },
    ft = { "markdown" },   
    config = function()
      require("render-markdown").setup({
        heading = {
          icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        },
        code = {
          style = "full",    
        },
        bullet = {
          icons = { "●", "○", "◆", "◇" }, 
        },
      })
    end,
  },
  {
    "saghen/blink.cmp",
    version = "*",          
    dependencies = {
      "rafamadriz/friendly-snippets", 
    },
    config = function()
      require("blink.cmp").setup({
        keymap = {
          preset = "default", 
        },
        appearance = {
          nerd_font_variant = "mono",  
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },
        completion = {
          documentation = {
            auto_show = true,          
            auto_show_delay_ms = 200,
          },
        },
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, 
    config = function()
      -- "Deep Archival Inks" statusline — see ~/Vault/3. Winner - Gemini Pro.md
      local archival = {
        normal = {
          a = { bg = "#204a87", fg = "#e4e4e4", gui = "bold" },
          b = { bg = "#e4e4e4", fg = "#404040", gui = "none" },
          c = { bg = "#ececec", fg = "#1a1a1a", gui = "none" },
        },
        insert = { a = { bg = "#225e31", fg = "#e4e4e4", gui = "bold" } },
        visual = { a = { bg = "#705214", fg = "#1a1a1a", gui = "bold" } },
        replace = { a = { bg = "#8f2727", fg = "#e4e4e4", gui = "bold" } },
        command = { a = { bg = "#752c61", fg = "#e4e4e4", gui = "bold" } },
        inactive = {
          a = { bg = "#a3a3a3", fg = "#404040" },
          b = { bg = "#e4e4e4", fg = "#595959" },
          c = { bg = "#ececec", fg = "#404040" },
        },
      }
      require("lualine").setup({
        options = {
          theme = archival,
          icons_enabled = true,
          section_separators = "",
          component_separators = "|",
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "diagnostics", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },
})
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local map = function(keys, fn, desc)
      vim.keymap.set("n", keys, fn, { buffer = args.buf, desc = desc })
    end
    map("gd", vim.lsp.buf.definition,      "Goto definition")
    map("gr", vim.lsp.buf.references,      "Goto references")
    map("K",  vim.lsp.buf.hover,           "Hover docs")
    map("<leader>rn", vim.lsp.buf.rename,      "Rename symbol")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
    map("]d", function() vim.diagnostic.jump({ count = 1 })  end, "Next diagnostic")
  end,
})
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
})
