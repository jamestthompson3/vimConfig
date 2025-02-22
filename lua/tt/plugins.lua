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
  -- "justinmk/vim-dirvish",
  "romainl/vim-cool",
  { "windwp/nvim-autopairs",       config = true },
  "windwp/nvim-ts-autotag",
  {
    "echasnovski/mini.surround",
    version = false,
    config = function()
      require("mini.surround").setup()
    end,
  },
  { "rafamadriz/friendly-snippets" },
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup()
    end
  },
  { "ludovicchabant/vim-gutentags", lazy = true,    event = "VimEnter" },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      require("tt.plugin.compe").init()
    end,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      { "saadparwaiz1/cmp_luasnip", build = "make install_jsregexp" },
      "ray-x/cmp-treesitter",
      "quangnguyen30192/cmp-nvim-tags",
    },
  },
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        color = {
          suggestion_color = "#BADA55",
          cterm = 244
        }
      })
    end,
  },
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
  { "prisma/vim-prisma",            lazy = true,    ft = { "prisma" } },
  { "rust-lang/rust.vim",           ft = { "rust" } },
  { "nanotee/sqls.nvim",            lazy = true,    ft = { "sql" } },
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
