-- Globals
vim.g.did_install_default_menus = 1
vim.g.remove_whitespace = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.python3_host_prog = is_windows and 'C:\\Users\\taylor.thompson\\AppData\\Local\\Programs\\Python\\Python36-32\\python.exe' or '/usr/local/bin/python3'


vim.g.netrw_localrmdir = 'rm -rf'
vim.g.netrw_banner=0
vim.g.netrw_winsize=45
vim.g.netrw_liststyle=3
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
vim.g.ale_fixers = {json = {"prettier"}, html = {"prettier"}, css = {"prettier"}}
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
vim.g.gutentags_project_root = {'Cargo.toml', 'package.json'}
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

 require'compe'.setup {
   enabled = true;
   autocomplete = true;
   debug = false;
   min_length = 1;
   preselect = 'disabled';
   throttle_time = 80;
   source_timeout = 200;
   incomplete_delay = 80;
   max_abbr_width = 100;
   max_kind_width = 100;
   max_menu_width = 100;
   documentation = true;

   source = {
     path = true;
     buffer = {priority = 1};
     vsnip = {priority = 4};
     nvim_lsp = {priority = 100};
     nvim_lua = true;
     treesitter = true;
     tags = {priority = 2};
     calc = false;
     spell = false;
     snippets_nvim = false;
   };
 }

