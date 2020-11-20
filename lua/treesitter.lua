local ts_config = require('nvim-treesitter.configs')
ts_config.setup {
  ensure_installed = {
    'bash',
    'c',
    'cpp',
    'lua',
    'css',
    'html',
    'javascript',
    'json',
    'python',
    'rust',
    'typescript',
    'tsx'
  },
  highlight = {
    enable = true,                    -- false will disable the whole extension
  },
  incremental_selection = {
    enable = false,
    keymaps = {                       -- mappings for incremental selection (visual mappings)
    init_selection = 'gnn',         -- maps in normal mode to init the node/scope selection
    node_incremental = "grn",       -- increment to the upper named parent
    scope_incremental = "grc",      -- increment to the upper scope (as defined in locals.scm)
    node_decremental = "grm",       -- decrement to the previous node
  }
},
refactor = {
  highlight_definitions = {
    enable = true
  },
  highlight_current_scope = {
    enable = false
  },
  smart_rename = {
    enable = true,
    keymaps = {
      smart_rename = "grr"          -- mapping to rename reference under cursor
    }
  },
  navigation = {
    enable = false,
    keymaps = {
      goto_definition = "gnd",      -- mapping to go to definition of symbol under cursor
      list_definitions = "gnD"      -- mapping to list all definitions in current file
    }
  }
},
textobjects = { -- syntax-aware textobjects
enable = false,
disable = {},
keymaps = {}
  },
}
