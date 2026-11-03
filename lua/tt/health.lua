local M = {}

function M.check()
	local h = vim.health
	h.start("Neovim configuration")
	if vim.fn.has("nvim-0.13") == 1 and vim.async then
		h.ok("Neovim " .. tostring(vim.version()))
	else
		h.error("Neovim 0.13 nightly is required; see README.md")
	end
	if vim.fn.executable("rg") == 1 then
		h.ok("ripgrep")
	else
		h.error("Install ripgrep for :F and :grep")
	end

	h.start("Optional workflow tools")
	for _, bin in ipairs({ "fd", "ctags", "git", "gh", "git-open", "todo.sh", "pandoc", "node", "npx", "pi" }) do
		if vim.fn.executable(bin) == 1 then
			h.ok(bin)
		else
			h.warn(bin .. " not found; its workflow is unavailable")
		end
	end

	h.start("Formatters and language servers (only needed for languages you use)")
	local node = require("tt.nvim_utils").nodejs
	for _, bin in ipairs({
		"prettierd",
		"prettier",
		"biome",
		"stylelint",
		"eslint_d",
		"import-sort",
		"typescript-language-server",
		"astro-ls",
		"html-languageserver",
		"bash-language-server",
	}) do
		local path = node.find_node_executable(bin)
		if path ~= "" then
			h.ok(bin .. ": " .. path)
		else
			h.warn(bin .. " not found in this project, langservers/, or PATH")
		end
	end
	for _, bin in ipairs({
		"stylua",
		"rustfmt",
		"gofmt",
		"clang-format",
		"fish_indent",
		"jq",
		"lua-language-server",
		"clangd",
		"rust-analyzer",
		"gopls",
		"zls",
		"marksman",
		"sqls",
		"efm-langserver",
	}) do
		if vim.fn.executable(bin) == 1 then
			h.ok(bin)
		else
			h.warn(bin .. " not found")
		end
	end
	h.info("Use :FormatInfo and :checkhealth vim.lsp to inspect the active buffer")
end

return M
