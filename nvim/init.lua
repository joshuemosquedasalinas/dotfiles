-- ============================================================
--  CORE OPTIONS
-- ============================================================

-- Set leader key BEFORE plugins load (space is the popular choice)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- === Line numbers ===
vim.opt.number = true          -- show absolute line number on current line
vim.opt.relativenumber = true  -- relative numbers on other lines (great for motions)

-- === Indentation ===
vim.opt.tabstop = 2            -- a tab shows as 2 spaces
vim.opt.shiftwidth = 2        -- indent = 2 spaces
vim.opt.expandtab = true       -- tabs become spaces
vim.opt.smartindent = true     -- auto-indent new lines

-- === Search ===
vim.opt.ignorecase = true      -- case-insensitive search...
vim.opt.smartcase = true       -- ...unless you type a capital
vim.opt.hlsearch = true        -- highlight all matches

-- === Appearance ===
vim.opt.termguicolors = true   -- enable 24-bit color (needed for themes)
vim.opt.signcolumn = "yes"     -- always show the sign column (no layout jump)
vim.opt.cursorline = true      -- highlight the line the cursor is on
vim.opt.wrap = false           -- don't wrap long lines

-- === Behavior ===
vim.opt.mouse = "a"            -- enable mouse in all modes
vim.opt.clipboard = "unnamedplus" -- use system clipboard for yank/paste
vim.opt.scrolloff = 8          -- keep 8 lines visible above/below cursor
vim.opt.undofile = true        -- persistent undo across sessions
vim.opt.updatetime = 250       -- faster response for various plugins

-- ============================================================
--  PLUGIN MANAGER: lazy.nvim
-- ============================================================
-- Auto-install lazy.nvim on first launch if it's not present
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- always grab the latest stable release
    lazypath,
  })
end

-- Prepend lazy to the runtimepath so Neovim can find it
vim.opt.rtp:prepend(lazypath)

-- ============================================================
--  PLUGINS
-- ============================================================

require("lazy").setup({

  -- === Colorscheme ===
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        variant = "moon",
        styles = {
          transparent_background = true,
        },
      })
      vim.cmd.colorscheme("rose-pine")
      vim.cmd([[
        highlight Normal guibg=NONE ctermbg=NONE
        highlight NormalNC guibg=NONE ctermbg=NONE
        highlight SignColumn guibg=NONE ctermbg=NONE
        highlight EndOfBuffer guibg=NONE ctermbg=NONE
        highlight CursorLine guibg=#000000
        highlight Visual guibg=#000000
]])
    end,
  },

-- === Fuzzy finder: fzf-lua ===
  {
    "ibhagwan/fzf-lua",
    config = function()
      require("fzf-lua").setup({
        winopts = {
          height = 0.85,
          width = 0.85,
          preview = { layout = "vertical" }, -- file preview stacked below the list
        },
      })

   -- Keymaps: <leader> is Space (set in your core options)
      local map = vim.keymap.set
      map("n", "<leader>ff", "<cmd>FzfLua files<cr>",     { desc = "Find files" })
      map("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>", { desc = "Grep in project" })
      map("n", "<leader>fb", "<cmd>FzfLua buffers<cr>",   { desc = "Open buffers" })
      map("n", "<leader>fh", "<cmd>FzfLua help_tags<cr>", { desc = "Help tags" })
      map("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>",  { desc = "Recent files" })
    end,
  },

-- === LSP: Mason (installer) + lspconfig (definitions) ===
  { "mason-org/mason.nvim", config = true },  -- config=true just calls .setup()
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",   -- provides the server config definitions
    },
    config = function()
      require("mason-lspconfig").setup({
        -- Servers to auto-install and auto-enable.
        ensure_installed = {
          "ts_ls",          -- TypeScript / JavaScript
          "html",           -- HTML
          "cssls",          -- CSS
          "emmet_language_server", -- Emmet + helps with HTMX-style attrs
          "rust_analyzer",  -- Rust
          "gopls",          -- Go
          "marksman",       -- Markdown
        },
      })
    end,
  },

-- === Treesitter: syntax parsing & highlighting ===
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",            -- use the stable classic API
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

-- === Markdown in-buffer rendering ===
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",  -- it reads the treesitter tree
      "nvim-tree/nvim-web-devicons",      -- icons for code-block languages
    },
    ft = { "markdown" },   -- only load for markdown files (keeps startup fast)
    config = function()
      require("render-markdown").setup({
        heading = {
          -- Show headings as styled banners with these icons
          icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        },
        code = {
          style = "full",    -- box code blocks with a language label
        },
        bullet = {
          icons = { "●", "○", "◆", "◇" },  -- nested list bullets
        },
      })
    end,
  },

-- === Autocompletion: blink.cmp ===
  {
    "saghen/blink.cmp",
    version = "*",          -- use latest release (it ships prebuilt binaries)
    dependencies = {
      "rafamadriz/friendly-snippets",  -- a big library of ready-made snippets
    },
    config = function()
      require("blink.cmp").setup({
        keymap = {
          preset = "default",   -- <C-space> opens, <C-n>/<C-p> or arrows navigate,
                                 -- <C-y> confirms, <C-e> cancels
        },
        appearance = {
          nerd_font_variant = "mono",  -- matches your Commit Mono Nerd Font
        },
        sources = {
          -- Where suggestions come from, in priority order
          default = { "lsp", "path", "snippets", "buffer" },
        },
        completion = {
          documentation = {
            auto_show = true,          -- show docs popup next to the menu
            auto_show_delay_ms = 200,
          },
        },
      })
    end,
  },

-- === Statusline: lualine ===
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },  -- icons (you have the Nerd Font)
    config = function()
      -- Custom neutral theme matching your dark-grey aesthetic
      local neutral = {
        normal = {
          a = { bg = "#000000", fg = "#e0def4", gui = "bold" },
          b = { bg = "#000000", fg = "#e0def4" },
          c = { bg = "#000000", fg = "#e0def4" },
        },
        insert = { a = { bg = "#000000", fg = "#ff0088", gui = "bold" } }, -- soft blue
        visual = { a = { bg = "#000000", fg = "#ffd900", gui = "bold" } }, -- muted, only on visual
        replace = { a = { bg = "#000000", fg = "#00ff91", gui = "bold" } },
        command = { a = { bg = "#000000", fg = "#00f2ff", gui = "bold" } },
        inactive = {
          a = { bg = "#000000", fg = "#ffffff" },
          b = { bg = "#000000", fg = "#ffffff" },
          c = { bg = "#000000", fg = "#ffffff" },
        },
      }

      require("lualine").setup({
        options = {
          theme = neutral,
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

-- ============================================================
--  LSP KEYMAPS & BEHAVIOR
-- ============================================================

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

-- Show diagnostics as inline virtual text
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
})

