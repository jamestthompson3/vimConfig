local ts_config = require("nvim-treesitter.configs")
local function setCustomGroups()
  -- custom syntax since treesitter overrides nvim defaults
  -- Doesn't work... :/
  api.nvim_command [[match Todo /\c@\?\(todo\|fixme\)/]]
  api.nvim_command [[match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$']]
  -- this one works tho...
  -- @todo: thing
  api.nvim_command [[match ExtraWhitespace /\s\+$/]]
end

ts_config.setup({
  ensure_installed = {
    "bash",
    "c",
    "cpp",
    "lua",
    "css",
    "html",
    "javascript",
    "json",
    "scala",
    "python",
    "rust",
    "typescript",
    "tsx",
  },
  highlight = {
    enable = true, -- false will disable the whole extension
   -- additional_vim_regex_highlighting = true,
  },
})

setCustomGroups()
