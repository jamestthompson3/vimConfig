local api = vim.api
local loadedDeps = false

vim.g.netrw_localrmdir = 'rm -r'
vim.g.netrw_banner=0
vim.g.netrw_winsize=45
vim.g.netrw_liststyle=3
vim.g.ale_completion_delay = 20
vim.g.ale_linters_explicit = 1
vim.g.ale_sign_error = 'X'
vim.g.ale_sign_warning = '◉'
vim.g.ale_close_preview_on_insert = 1
vim.g.ale_fix_on_save = 1
vim.g.ale_lint_on_insert_leave = 0
vim.g.ale_lint_on_text_changed = 0
vim.g.ale_list_window_size = 5
vim.g.ale_virtualtext_cursor = 1
vim.g.ale_javascript_prettier_use_local_config = 1
vim.g.ale_echo_msg_format = '[%linter%] %s'
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
vim.g['mucomplete#enable_auto_at_startup'] = 1
vim.g['mucomplete#buffer_relative_paths'] = 1
vim.g['mucomplete#no_mappings']= 1
vim.g['mucomplete#buffer_relative_paths'] = 1
vim.g['mucomplete#minimum_prefix_length'] = 1
vim.g['mucomplete#chains'] = {default = {'omni','tags', 'c-p', 'c-n', 'keyn', 'keyp', 'incl', 'defs', 'file', 'path'}}
vim.g.matchup_matchparen_deferred = 1
vim.g.matchup_match_paren_timeout = 100
vim.g.matchup_matchparen_stopline = 200
vim.g.matchup_matchparen_offscreen = {method = 'popup'}
vim.g.rainbow_pairs = [[ ['(', ')'], ['[', ']'], ['{', '}'] ]]
vim.g.fzf_layout = { window = 'lua NavigationFloatingWin()'}


local function loadDeps()
  if not loadedDeps then

    require 'navigation'

    api.nvim_command [[packadd ale]]
    api.nvim_command [[packadd cfilter]]
    api.nvim_command [[packadd pear-tree]]
    api.nvim_command [[packadd rainbow_parentheses.vim]]
    api.nvim_command [[packadd nvim-lsp]]
    api.nvim_command [[packadd vim-apathy]]
    api.nvim_command [[packadd vim-commentary]]
    api.nvim_command [[packadd vim-cool]]
    api.nvim_command [[packadd vim-gutentags]]
    api.nvim_command [[packadd vim-matchup]]
    api.nvim_command [[packadd vim-mucomplete]]
    api.nvim_command [[packadd nvim-colorizer.lua]]
    api.nvim_command [[packadd vim-surround]]

    local nvim_lsp = require 'nvim_lsp'
    nvim_lsp.sumneko_lua.setup({})
    nvim_lsp.tsserver.setup({})
    nvim_lsp.rls.setup({})

    local diagnostic = require('user_lsp')
    vim.lsp.callbacks['textDocument/publishDiagnostics'] = diagnostic.diagnostics_callback
    vim.fn['tools#loadCscope']()
    loadedDeps = true
  else
    return
  end
end

loadDeps()
