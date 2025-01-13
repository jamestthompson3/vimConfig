local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "sindrets/diffview.nvim",
  "justinmk/vim-dirvish",
  "romainl/vim-cool",
  { "windwp/nvim-autopairs",        config = true },
  "windwp/nvim-ts-autotag",
  {
    "echasnovski/mini.surround",
    version = false,
    config = function()
      require("mini.surround").setup()
    end,
  },
  { "rafamadriz/friendly-snippets" },
  { "ludovicchabant/vim-gutentags", lazy = true,  event = "VimEnter" },
  {
    "saghen/blink.cmp",
    version = "0.7.6",
    opts = {
      snippets = {
        keymap = {},
        expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
        active = function(filter)
          if filter and filter.direction then
            return require('luasnip').jumpable(filter.direction)
          end
          return require('luasnip').in_snippet()
        end,
        jump = function(direction) require('luasnip').jump(direction) end,
      },
      completion = {
        documentation = {
          auto_show = true
        }
      },
      appearance = {
        kind_icons = {
          Text = "␂ Text",
          Method = "🜜  Method",
          Function = "⎔ Func",
          Constructor = "⌂ Constructor",
          Variable = "⊷ Var",
          Class = "⌻ Class",
          Interface = "∮ Interface",
          Module = "⌘ Module",
          Property = " ∴ Property",
          Unit = "⍚ Unit",
          Value = "⋯ Value",
          Enum = "⎆ Enum",
          Keyword = "⚿  Keyword",
          Snippet = "⮑  Snippet",
          Color = "🜚 Color",
          File = "𐂧 File",
          Folder = "𐂽 Folder",
          EnumMember = "⍆ EnumMember",
          Constant = "🜛 Constant",
          Struct = "⨊ Struct",
        }
      }
    }
  },
  -- {
  --   "supermaven-inc/supermaven-nvim",
  --   config = function()
  --     require("supermaven-nvim").setup({
  --       color = {
  --         suggestion_color = "#BADA55",
  --         cterm = 244
  --       }
  --     })
  --   end,
  -- },
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    run = "make install_jsregexp",
    config = function()
      require("tt.plugin.luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  {
    "ibhagwan/fzf-lua",
    config = function()
      require("tt.plugin.find").init()
    end,
  },
  { "prisma/vim-prisma",  lazy = true,    ft = { "prisma" } },
  { "rust-lang/rust.vim", ft = { "rust" } },
  { "nanotee/sqls.nvim",  lazy = true,    ft = { "sql" } },
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    ft = { "c", "cpp" },
    config = function()
      require("tt.plugin.dap").init()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("tt.plugin.treesitter").init()
    end,
    ft = require("tt.plugin.treesitter").supported_langs,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-context" },
    },
  },

  { "norcalli/nvim-colorizer.lua", ft = { "html", "css", "vim" } },
  { "reedes/vim-wordy",            lazy = true,                  ft = { "txt", "md", "markdown", "text" } },
}, {
  -- defaults = { lazy = true },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "rplugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "getscript",
        "vimball",
        "logiPat",
        "rrhelper",
        "python_provider",
      },
    },
  },
})
