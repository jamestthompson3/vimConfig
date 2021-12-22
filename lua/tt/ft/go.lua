require("tt.nvim_utils")

local M = {}

function M.bootstrap()
  vim.bo.suffixesadd = ".go"

  local mappings = {
		["i<C-l>"] = { "fmt.Println()<esc>i", noremap = true, buffer = true },
		["id<C-l>"] = { "os.Exit(1)<esc>o<esc>", noremap = true, buffer = true },
  }
	nvim_apply_mappings(mappings, { silent = true })
  api.nvim_command [[ setlocal makeprg=go\ run ]]
end


return M
