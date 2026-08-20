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
        highlight CursorLine guibg=#363636
        highlight Visual guibg=#363636
]])
    end,
  },
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
      local neutral = {
        normal = {
          a = { bg = "#363636", fg = "#ffffff", gui = "bold" },
          b = { bg = "#363636", fg = "#ffffff" },
          c = { bg = "#363636", fg = "#ffffff" },
        },
        insert = { a = { bg = "#363636", fg = "#ff0088", gui = "bold" } }, 
        visual = { a = { bg = "#363636", fg = "#ffd900", gui = "bold" } }, 
        replace = { a = { bg = "#363636", fg = "#00ff91", gui = "bold" } },
        command = { a = { bg = "#363636", fg = "#00f2ff", gui = "bold" } },
        inactive = {
          a = { bg = "#363636", fg = "#ffffff" },
          b = { bg = "#363636", fg = "#ffffff" },
          c = { bg = "#363636", fg = "#ffffff" },
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
