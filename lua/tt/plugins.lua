M = {}
local api = vim.api

-- Check if the packer tool exists
local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])

if not packer_exists then
  -- TODO: Maybe handle windows better?
  if vim.fn.input("Download Packer? (y for yes)") ~= "y" then
    return
  end

  local directory = string.format(
  '%s/pack/packer/opt/',
  vim.fn.stdpath('config')
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
  -- use {'aca/completion-tabnine', run = './install.sh'}
  use { 'nvim-lua/completion-nvim', { 'neovim/nvim-lspconfig', config = function() require('tt.user_lsp').configureLSP() end}}
  use { 'wbthomason/packer.nvim', opt = true }
  use { 'nvim-treesitter/nvim-treesitter', event = 'VimEnter *', config = function()
    require('tt.treesitter')
  end
}
use { 'nvim-treesitter/completion-treesitter', opt = true, event = 'UIEnter *' }
use { 'andymass/vim-matchup', opt = true, event = 'UIEnter *' }
use { 'dense-analysis/ale', opt = true, event = 'UIEnter *' }
use { 'junegunn/fzf', run = './install --all'}
use { 'ludovicchabant/vim-gutentags', opt = true, event = 'UIEnter *'  }
use { 'majutsushi/tagbar', opt = true, ft = {'c', 'cpp', 'typescript', 'typescriptreact'} }
use { 'norcalli/nvim-colorizer.lua', opt = true, ft = {'html', 'css', 'vim'} }
use { 'reedes/vim-wordy', opt = true, ft = {'txt', 'md', 'markdown', 'text'} }
use { 'romainl/vim-cool', opt = true, event = 'VimEnter *' }
use { 'tmsvg/pear-tree', opt = true, event = 'VimEnter *' }
use { 'tpope/vim-apathy', opt = true }
use { 'tpope/vim-commentary',opt = true, event = 'UIEnter *' }
use { 'tpope/vim-surround', opt = true, event = 'UIEnter *'  }
use { 'tpope/vim-repeat', opt = true, event = 'UIEnter *' }

-- use packager#local('~/code/nvim-remote-containers', { 'type': 'opt' })
end)
