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
  use 'romainl/vim-cool'
  use 'tmsvg/pear-tree'
  use 'tpope/vim-apathy'
  use 'tpope/vim-commentary'
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  use 'andymass/vim-matchup'
  use 'hrsh7th/nvim-compe'
  use 'hrsh7th/vim-vsnip'
use 'dense-analysis/ale'
use {
  'glepnir/galaxyline.nvim',
    branch = 'main',
    -- your statusline
    config = function() require'tt.statusline' end,
}
use 'ludovicchabant/vim-gutentags'
use {
  'nvim-telescope/telescope.nvim',
  requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
}
use  { 'neovim/nvim-lspconfig', config = function() require('tt.user_lsp').configureLSP() end}
use 'nvim-telescope/telescope-fzy-native.nvim'
use { 'wbthomason/packer.nvim', opt = true }
use { 'nvim-treesitter/nvim-treesitter', config = function()
  require('tt.treesitter')
end
}
use { 'majutsushi/tagbar', opt = true, ft = {'c', 'cpp', 'typescript', 'typescriptreact', 'javascript', 'javascriptreact'} }
use { 'norcalli/nvim-colorizer.lua', opt = true, ft = {'html', 'css', 'vim'} }
use { 'reedes/vim-wordy', opt = true, ft = {'txt', 'md', 'markdown', 'text'} }

end)
