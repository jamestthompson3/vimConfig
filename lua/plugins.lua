local api = vim.api
local loadedDeps = false

vim.g.netrw_localrmdir = 'rm -r'
vim.g.netrw_banner=0
vim.g.netrw_winsize=45
vim.g.netrw_liststyle=3
vim.g.ale_completion_delay = 20
vim.g.ale_linters_explicit = 1
vim.g.ale_sign_error = '!!'
vim.g.ale_sign_warning = '◉'
vim.g.ale_close_preview_on_insert = 1
vim.g.ale_fix_on_save = 1
vim.g.ale_lint_on_insert_leave = 0
vim.g.ale_lint_on_text_changed = 0
vim.g.ale_list_window_size = 5
vim.g.ale_virtualtext_cursor = 1
vim.g.ale_javascript_prettier_use_local_config = 1
vim.g.ale_fixers = {json = {"prettier"}}
vim.g.ale_echo_msg_format = '[%linter%] %s » %code%'
vim.g.ale_sign_column_always = 0
vim.g.pear_tree_smart_openers = 1
vim.g.pear_tree_smart_closers = 1
vim.g.pear_tree_smart_backspace = 1
vim.g.pear_tree_timeout = 60
vim.g.pear_tree_repeatable_expand = 1
vim.g.pear_tree_map_special_keys = 1
vim.g.gutentags_file_list_command = 'fd . -c never'
vim.g.gutentags_cache_dir = '~/.cache/'
vim.g.gutentags_project_root = {'Cargo.toml'}
vim.g.matchup_matchparen_deferred = 1
vim.g.matchup_match_paren_timeout = 100
vim.g.matchup_matchparen_stopline = 200
vim.g.matchup_matchparen_offscreen = {method = 'popup'}
vim.g.rainbow_pairs = [[ ['(', ')'], ['[', ']'], ['{', '}'] ]]
vim.g.fzf_layout = { window = 'lua NavigationFloatingWin()'}
vim.g.completion_trigger_character = {'.', '::'}
vim.g.completion_matching_strategy_list = {'fuzzy', 'substring', 'exact'}
vim.g.completion_auto_change_source = 1


local function loadDeps()
  if not loadedDeps then

    require 'navigation'

    vim.cmd [[packadd ale]]
    vim.cmd [[packadd cfilter]]
    vim.cmd [[packadd pear-tree]]
    vim.cmd [[packadd rainbow_parentheses.vim]]
    vim.cmd [[packadd nvim-lspconfig]]
    vim.cmd [[packadd nvim-treesitter]]
    vim.cmd [[packadd completion-treesitter]]

    vim.cmd [[packadd vim-commentary]]
    vim.cmd [[packadd vim-cool]]
    vim.cmd [[packadd vim-gutentags]]
    vim.cmd [[packadd vim-matchup]]
    vim.cmd [[packadd nvim-colorizer.lua]]
    vim.cmd [[packadd vim-surround]]

    local nvim_lsp = require 'nvim_lsp'
    nvim_lsp.sumneko_lua.setup({})
    nvim_lsp.cssls.setup({})
    nvim_lsp.tsserver.setup({cmd = { "typescript-language-server", "--stdio" }})

    nvim_lsp.rls.setup({})
    nvim_lsp.bashls.setup({})

    local diagnostic = require('user_lsp')
    vim.lsp.callbacks['textDocument/publishDiagnostics'] = diagnostic.diagnostics_callback
    vim.fn['tools#loadCscope']()

    require'nvim-treesitter.configs'.setup {
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
-- custom syntax since treesitter overrides nvim defaults
-- Doesn't work... :/
nvim.command [[match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$']]
nvim.command [[syntax match  AllTodo "\ctodo\|fixme\|TODO\|FIXME"]]

loadedDeps = true
  else
    return
  end
end

loadDeps()
