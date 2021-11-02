" Automatically generated packer.nvim plugin loader code

if !has('nvim-0.5')
  echohl WarningMsg
  echom "Invalid Neovim version for packer.nvim!"
  echohl None
  finish
endif

packadd packer.nvim

try

lua << END
local package_path_str = "/Users/taylorthompson/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/taylorthompson/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/taylorthompson/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/taylorthompson/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/taylorthompson/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    print('Error running ' .. component .. ' for ' .. name)
    error(result)
  end
  return result
end

_G.packer_plugins = {
  ["cmp-buffer"] = {
    loaded = true,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/start/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp"
  },
  ["cmp-nvim-tags"] = {
    loaded = true,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/start/cmp-nvim-tags"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/start/cmp-path"
  },
  ["cmp-treesitter"] = {
    loaded = true,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/start/cmp-treesitter"
  },
  ["cmp-vsnip"] = {
    loaded = true,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/start/cmp-vsnip"
  },
  ["galaxyline.nvim"] = {
    config = { "\27LJ\2\n-\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\18tt.statusline\frequire\0" },
    loaded = true,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/start/galaxyline.nvim"
  },
  ["lush.nvim"] = {
    loaded = true,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/start/lush.nvim"
  },
  ["nvim-cmp"] = {
    config = { "\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20tt.plugin.compe\frequire\0" },
    loaded = true,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/start/nvim-cmp"
  },
  ["nvim-colorizer.lua"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/opt/nvim-colorizer.lua"
  },
  ["nvim-dap"] = {
    config = { "\27LJ\2\n­\4\0\0\a\0\19\0$6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\2\4\0004\3\3\0006\4\5\0009\4\6\4'\6\a\0B\4\2\2'\5\b\0&\4\5\4>\4\1\3=\3\t\2=\2\3\0019\1\n\0004\2\3\0005\3\f\0006\4\r\0009\4\14\0049\4\15\4B\4\1\2=\4\16\3>\3\1\2=\2\v\0019\1\n\0004\2\3\0005\3\18\0006\4\r\0009\4\14\0049\4\15\4B\4\1\2=\4\16\3>\3\1\2=\2\17\1K\0\1\0\1\0\6\fprogram\f${file}\frequest\vlaunch\ttype\nnode2\fconsole\23integratedTerminal\rprotocol\14inspector\15sourceMaps\2\15typescript\bcwd\vgetcwd\afn\bvim\1\0\6\fprogram\f${file}\frequest\vlaunch\ttype\nnode2\fconsole\23integratedTerminal\rprotocol\14inspector\15sourceMaps\2\15javascript\19configurations\targsF/.config/nvim/langservers/vscode-node-debug2/out/src/nodeDebug.js\tHOME\vgetenv\aos\1\0\2\ttype\15executable\fcommand\tnode\nnode2\radapters\bdap\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/opt/nvim-dap"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\n;\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\17configureLSP\vtt.lsp\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/opt/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\n4\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\25tt.plugin.treesitter\frequire\0" },
    loaded = true,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-web-nonicons"] = {
    loaded = true,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/start/nvim-web-nonicons"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/opt/packer.nvim"
  },
  ["pear-tree"] = {
    loaded = true,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/start/pear-tree"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  tagbar = {
    commands = { "Tagbar" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/opt/tagbar"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim"
  },
  ["telescope-fzy-native.nvim"] = {
    loaded = true,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/start/telescope-fzy-native.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n3\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\24tt.plugin.telescope\frequire\0" },
    loaded = true,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["vim-apathy"] = {
    loaded = true,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/start/vim-apathy"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/start/vim-commentary"
  },
  ["vim-cool"] = {
    loaded = true,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/start/vim-cool"
  },
  ["vim-dirvish"] = {
    loaded = true,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/start/vim-dirvish"
  },
  ["vim-gutentags"] = {
    loaded = true,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/start/vim-gutentags"
  },
  ["vim-matchup"] = {
    loaded = true,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/start/vim-matchup"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/start/vim-repeat"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/start/vim-surround"
  },
  ["vim-vsnip"] = {
    loaded = true,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/start/vim-vsnip"
  },
  ["vim-wordy"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/taylorthompson/.local/share/nvim/site/pack/packer/opt/vim-wordy"
  }
}

-- Config for: nvim-treesitter
try_loadstring("\27LJ\2\n4\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\25tt.plugin.treesitter\frequire\0", "config", "nvim-treesitter")
-- Config for: telescope.nvim
try_loadstring("\27LJ\2\n3\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\24tt.plugin.telescope\frequire\0", "config", "telescope.nvim")
-- Config for: nvim-cmp
try_loadstring("\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20tt.plugin.compe\frequire\0", "config", "nvim-cmp")
-- Config for: galaxyline.nvim
try_loadstring("\27LJ\2\n-\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\18tt.statusline\frequire\0", "config", "galaxyline.nvim")

-- Command lazy-loads
vim.cmd [[command! -nargs=* -range -bang -complete=file Tagbar lua require("packer.load")({'tagbar'}, { cmd = "Tagbar", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
vim.cmd [[au FileType json ++once lua require("packer.load")({'nvim-lspconfig'}, { ft = "json" }, _G.packer_plugins)]]
vim.cmd [[au FileType vim ++once lua require("packer.load")({'nvim-colorizer.lua'}, { ft = "vim" }, _G.packer_plugins)]]
vim.cmd [[au FileType javascript ++once lua require("packer.load")({'nvim-dap', 'nvim-lspconfig', 'tagbar'}, { ft = "javascript" }, _G.packer_plugins)]]
vim.cmd [[au FileType go ++once lua require("packer.load")({'nvim-lspconfig'}, { ft = "go" }, _G.packer_plugins)]]
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'nvim-lspconfig', 'vim-wordy'}, { ft = "markdown" }, _G.packer_plugins)]]
vim.cmd [[au FileType md ++once lua require("packer.load")({'vim-wordy'}, { ft = "md" }, _G.packer_plugins)]]
vim.cmd [[au FileType text ++once lua require("packer.load")({'vim-wordy'}, { ft = "text" }, _G.packer_plugins)]]
vim.cmd [[au FileType rust ++once lua require("packer.load")({'nvim-lspconfig', 'tagbar'}, { ft = "rust" }, _G.packer_plugins)]]
vim.cmd [[au FileType css ++once lua require("packer.load")({'nvim-lspconfig', 'nvim-colorizer.lua'}, { ft = "css" }, _G.packer_plugins)]]
vim.cmd [[au FileType html ++once lua require("packer.load")({'nvim-lspconfig', 'nvim-colorizer.lua'}, { ft = "html" }, _G.packer_plugins)]]
vim.cmd [[au FileType txt ++once lua require("packer.load")({'vim-wordy'}, { ft = "txt" }, _G.packer_plugins)]]
vim.cmd [[au FileType typescript ++once lua require("packer.load")({'nvim-dap', 'nvim-lspconfig', 'tagbar'}, { ft = "typescript" }, _G.packer_plugins)]]
vim.cmd [[au FileType cpp ++once lua require("packer.load")({'tagbar'}, { ft = "cpp" }, _G.packer_plugins)]]
vim.cmd [[au FileType bash ++once lua require("packer.load")({'nvim-lspconfig'}, { ft = "bash" }, _G.packer_plugins)]]
vim.cmd [[au FileType yaml ++once lua require("packer.load")({'nvim-lspconfig'}, { ft = "yaml" }, _G.packer_plugins)]]
vim.cmd [[au FileType javascriptreact ++once lua require("packer.load")({'nvim-lspconfig', 'tagbar'}, { ft = "javascriptreact" }, _G.packer_plugins)]]
vim.cmd [[au FileType typescriptreact ++once lua require("packer.load")({'nvim-lspconfig', 'tagbar'}, { ft = "typescriptreact" }, _G.packer_plugins)]]
vim.cmd [[au FileType lua ++once lua require("packer.load")({'nvim-lspconfig'}, { ft = "lua" }, _G.packer_plugins)]]
vim.cmd [[au FileType c ++once lua require("packer.load")({'tagbar'}, { ft = "c" }, _G.packer_plugins)]]
vim.cmd("augroup END")
END

catch
  echohl ErrorMsg
  echom "Error in packer_compiled: " .. v:exception
  echom "Please check your config for correctness"
  echohl None
endtry
