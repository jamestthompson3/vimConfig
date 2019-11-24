local lsp_setup = {}

local nvim_lsp = require 'nvim_lsp'
-- local lsp_callbacks = require 'lsp_callbacks'

function lsp_setup.ecma_setup()
  nvim_lsp.tsserver.setup({})
end

return lsp_setup
