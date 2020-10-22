M = {}
local api = vim.api


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
vim.g.fzf_layout = { window = 'lua NavigationFloatingWin()'}
vim.g.completion_trigger_character = {'.', '::'}
vim.g.completion_matching_strategy_list = {'fuzzy', 'substring', 'exact'}
vim.g.completion_customize_lsp_label = {
  Function= ' [function]',
  Method= ' [method]',
  Reference= ' [refrence]',
  Enum= ' [enum]',
  Field= 'ﰠ [field]',
  Keyword= ' [key]',
  Variable= ' [variable]',
  Folder= ' [folder]',
  Snippet= ' [snippet]',
  Operator= ' [operator]',
  Module= ' [module]',
  Text= 'ﮜ[text]',
  Class= ' [class]',
  Interface= ' [interface]'
}
vim.g.completion_auto_change_source = 1

vim.g.completion_chain_complete_list = {
  c = {
    { complete_items = { 'ts' }},
    { mode = '<c-p>'},
    { mode = '<c-n>'},
    { mode = 'keyn'},
    { mode = 'tags'},
    { mode = 'keyp'},
    { mode = 'incl'},
    { mode = 'defs'},
    { mode = 'file'}
  },
  html = {
    { complete_items = { 'ts' }},
    { mode = '<c-p>'},
    { mode = '<c-n>'},
    { mode = 'keyn'},
    { mode = 'keyp'},
    { mode = 'incl'},
    { mode = 'tags'},
    { mode = 'defs'},
    { mode = 'file'}
  },
  python = {
    { complete_items = { 'ts' }},
    { mode = '<c-p>'},
    { mode = '<c-n>'},
    { mode = 'keyn'},
    { mode = 'keyp'},
    { mode = 'incl'},
    { mode = 'defs'},
    { mode = 'file'}
  },
  typescript = {
    {complete_items = { 'lsp','path' }},
    { mode = '<c-p>'},
    { mode = '<c-n>'},
    { mode = 'keyn'},
    { mode = 'keyp'},
    { mode = 'incl'},
    { mode = 'defs'}
  },
  typescriptreact = {
    {complete_items = { 'lsp','path' }},
    { mode = '<c-p>'},
    { mode = '<c-n>'},
    { mode = 'keyn'},
    { mode = 'keyp'},
    { mode = 'incl'},
    { mode = 'defs'}
  },
  lua = {
    {complete_items = { 'ts', 'lsp' }}
  },
  default = {
    {complete_items = { 'lsp', 'snippet', 'path' }},
    { mode = '<c-p>'},
    { mode = '<c-n>'},
    { mode = 'keyn'},
    { mode = 'keyp'},
    { mode = 'file'}
  }
}




-- Check if the packer tool exists
local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])

if not packer_exists then
  -- TODO: Maybe handle windows better?
  if vim.fn.input("Download Packer? (y for yes)") ~= "y" then
    return
  end

  local directory = string.format(
  '%s/site/pack/packer/opt/',
  vim.fn.stdpath('data')
  )

  vim.fn.mkdir(directory, 'p')

  local out = vim.fn.system(string.format(
  'git clone %s %s',
  'https://github.com/wbthomason/packer.nvim',
  directory .. '/packer.nvim'
  ))

  print(out)
  print("Downloading packer.nvim...")

  return
end


return require('packer').startup(function()
  use 'justinmk/vim-dirvish'
  use 'thinca/vim-localrc'
  use 'junegunn/fzf.vim'
  use 'nvim-lua/completion-nvim'
  use 'neovim/nvim-lspconfig'

  use { 'wbthomason/packer.nvim', opt = true }
  use { 'nvim-treesitter/nvim-treesitter', opt = true, event = 'VimEnter *' }
  use { 'nvim-treesitter/completion-treesitter', opt = true, event = 'VimEnter *' }
  use { 'andymass/vim-matchup', opt = true, event = 'VimEnter *' }
  use { 'dense-analysis/ale', opt = true, event = 'VimEnter *' }
  use { 'junegunn/fzf', run = './install --all'}
  use { 'kristijanhusak/vim-packager', opt = true }
  use { 'ludovicchabant/vim-gutentags', opt = true, event = 'VimEnter *'  }
  use { 'majutsushi/tagbar', opt = true, ft = {'c', 'cpp', 'typescript', 'typescriptreact'} }
  use { 'norcalli/nvim-colorizer.lua', opt = true, ft = {'html', 'css'} }
  use { 'reedes/vim-wordy', opt = true, ft = {'txt', 'md', 'markdown', 'text'} }
  use { 'romainl/vim-cool', opt = true, event = 'VimEnter *' }
  use { 'tmsvg/pear-tree', opt = true, event = 'VimEnter *' }
  use { 'tpope/vim-apathy', opt = true }
  use { 'tpope/vim-commentary',opt = true, event = 'VimEnter *' }
  use { 'tpope/vim-surround', opt = true, event = 'VimEnter *'  }
  use { 'tpope/vim-repeat', opt = true, event = 'VimEnter *' }

  -- use packager#local('~/code/nvim-remote-containers', { 'type': 'opt' })
end)
