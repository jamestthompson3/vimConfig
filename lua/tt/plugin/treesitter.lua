local M = {}

function M.init()
	require("treesitter-context").setup({
		enable = true,
		max_lines = 5,
		on_attach = function(buf)
			return not require("tt.buffer").is_large(buf)
		end,
		multiwindow = true,
		trim_scope = "outer",
	})
end

return M
