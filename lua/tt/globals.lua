-- Globals
vim.g.loaded_matchparen = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_python_provider = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_matchit = 1
vim.g.did_install_default_menus = 1
vim.g.remove_whitespace = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.python3_host_prog = is_windows and 'C:\\Users\\taylor.thompson\\AppData\\Local\\Programs\\Python\\Python36-32\\python.exe' or '/usr/local/bin/python3'
vim.g.autoformat = true
vim.g.netrw_localrmdir = 'rm -rf'
vim.g.netrw_banner=0
vim.g.netrw_winsize=45
vim.g.netrw_liststyle=3

vim.g.ale_linters_explicit = 1
vim.g.ale_sign_error = '!!'
vim.g.ale_sign_warning = '◉'
vim.g.ale_close_preview_on_insert = 1
vim.g.ale_fix_on_save = true
vim.g.ale_lint_on_insert_leave = 0
vim.g.ale_lint_on_text_changed = 0
vim.g.ale_list_window_size = 5
vim.g.ale_virtualtext_cursor = 1
vim.g.ale_fixers = {json = {"prettier"}}
vim.g.ale_echo_msg_format = '[%linter%] %s » %code%'
vim.g.ale_echo_cursor = 0
vim.g.ale_virtualtext_prefix = ''
vim.g.ale_sign_column_always = 0

vim.g.dirvish_relative_paths = 1

vim.g.pear_tree_smart_openers = 1
vim.g.pear_tree_smart_closers = 1
vim.g.pear_tree_smart_backspace = 1
vim.g.pear_tree_timeout = 60
vim.g.pear_tree_repeatable_expand = 1
vim.g.pear_tree_map_special_keys = 0

vim.g.gutentags_file_list_command = 'fd --type f --hidden -E .git'
vim.g.gutentags_cache_dir = '~/.cache/'
vim.g.gutentags_project_root = {'.git', 'Cargo.toml', 'package.json'}
vim.g.gutentags_add_default_project_roots = 1

vim.g.matchup_matchparen_deferred = 1
vim.g.matchup_match_paren_timeout = 100
vim.g.matchup_matchparen_stopline = 200
vim.g.matchup_matchparen_offscreen = {method = 'popup'}

vim.g.vsnip_snippet_dir = vim.fn.stdpath('config') .. '/snippets'
vim.g.vsnip_filetypes = {
  javascriptreact = {'react'},
  typescriptreact = {'react'}
}
