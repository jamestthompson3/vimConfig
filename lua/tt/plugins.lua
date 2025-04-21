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
  { "windwp/nvim-autopairs",        config = true },
  "windwp/nvim-ts-autotag",
  {
    "echasnovski/mini.surround",
    version = false,
    config = function()
      require("mini.surround").setup()
    end,
  },
  {
    'echasnovski/mini.completion',
    version = '*',
    config = function()
      require("mini.completion").setup()
    end
  },
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup()
    end,
  },
  { "ludovicchabant/vim-gutentags", lazy = true,  event = "VimEnter" },
  {
    "stevearc/conform.nvim",
    opts = {},
    config = function()
      require("tt.plugin.conform")
    end,
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
    "ibhagwan/fzf-lua",
    config = function()
      require("tt.plugin.find").init()
    end,
  },
  { "prisma/vim-prisma",           lazy = true,                  ft = { "prisma" } },
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
