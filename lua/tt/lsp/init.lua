local node = require("tt.nvim_utils").nodejs

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.semanticTokens.multilineTokenSupport = true

local on_attach = function(client, bufnr)
	require("tt.lsp.mappings").setMappings(bufnr)
	vim.lsp.completion.enable(true, client.id, bufnr, {
		autotrigger = false,
		convert = function(item)
			return { abbr = item.label:gsub("%b()", "") }
		end,
	})
	if client.server_capabilities.codeLensProvider then
		vim.lsp.codelens.enable(true, { bufnr = bufnr })
	end
	if client.server_capabilities.documentOnTypeFormattingProvider then
		vim.lsp.on_type_formatting.enable(true, { client_id = client.id })
	end
end

local function ts_on_attach(client, bufnr)
	client.server_capabilities.documentFormattingProvider = false
	client.server_capabilities.documentRangeFormattingProvider = false
	require("ts-error-translator").setup()
	on_attach(client, bufnr)
end

vim.lsp.config("*", {
	root_markers = { ".git", "root_marker" },
	capabilities = capabilities,
})

vim.lsp.config.lua_ls = {
	root_markers = {
		".luarc.json",
		".luarc.jsonc",
		".luacheckrc",
		".stylua.toml",
		"stylua.toml",
		"selene.toml",
		"selene.yml",
	},
	filetypes = { "lua" },
	on_attach = on_attach,
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end
		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				version = "LuaJIT",
				path = {
					"lua/?.lua",
					"lua/?/init.lua",
				},
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
				},
			},
		})
	end,
	settings = {
		Lua = {},
	},
	cmd = { "lua-language-server" },
}

vim.lsp.config.zls = {
	filetypes = { "zig", "zon" },
	on_attach = on_attach,
	cmd = { "zls" },
}

vim.lsp.config.rust_analyzer = {
	on_attach = on_attach,
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	checkOnSave = {
		enabled = true,
		command = "clippy",
	},
}

vim.lsp.config.gopls = {
	filetypes = { "go" },
	cmd = { "gopls", "serve" },
	on_attach = on_attach,
	analyses = {
		unusedparams = true,
		staticcheck = true,
	},
}

vim.lsp.config.clangd = {
	cmd = { "clangd" },
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	on_attach = on_attach,
}

-- Node-based servers deferred to avoid fs lookups at startup
vim.api.nvim_create_autocmd("FileType", {
	once = true,
	pattern = {
		"html", "templ", "sql", "mysql",
		"astro", "css", "graphql", "javascript", "javascriptreact",
		"json", "jsonc", "svelte", "typescript", "typescriptreact",
		"typescript.tsx", "javascript.jsx", "vue",
		"bash", "sh",
	},
	callback = function()
		vim.lsp.config.html = {
			filetypes = { "html", "templ" },
			on_attach = on_attach,
			init_options = { documentFormatting = false },
			cmd = { node.get_node_bin("html-languageserver"), "--stdio" },
		}

		vim.lsp.config.sqls = {
			cmd = { "sqls" },
			filetypes = { "sql", "mysql" },
			on_attach = function(client, bufnr)
				require("sqls").on_aa_attach(client, bufnr)
			end,
		}

		vim.lsp.config.biome = {
			cmd = { node.get_node_bin("biome"), "lsp-proxy" },
			root_markers = { "biome.json", "biome.jsonc" },
			filetypes = {
				"astro", "css", "graphql", "javascript", "javascriptreact",
				"json", "jsonc", "svelte", "typescript", "typescript.tsx",
				"typescriptreact", "vue",
			},
			on_attach = on_attach,
		}

		vim.lsp.config.bashls = {
			filetypes = { "bash", "sh" },
			on_attach = on_attach,
			cmd = { node.get_node_bin("bash-language-server"), "start" },
		}

		vim.lsp.config.astro = {
			cmd = { node.get_node_bin("astro-ls"), "--stdio" },
			on_attach = ts_on_attach,
			filetypes = { "astro" },
			init_options = {
				typescript = { tsdk = node.get_node_lib("typescript/lib") },
			},
			root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
		}

		vim.lsp.config.ts_ls = {
			filetypes = {
				"javascript", "javascriptreact", "javascript.jsx",
				"typescript", "typescriptreact", "typescript.tsx",
			},
			on_attach = ts_on_attach,
			cmd = { node.find_node_executable("typescript-language-server"), "--stdio" },
			init_options = {
				hostInfo = "neovim",
				tsserver = { path = node.get_node_lib("typescript/lib") },
			},
			root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
			single_file_support = true,
		}

		vim.lsp.enable({ "html", "sqls", "biome", "bashls", "astro", "ts_ls" })
	end,
})

vim.lsp.enable({
	"lua_ls",
	"zls",
	"rust_analyzer",
	"gopls",
	"clangd",
})

-- LSP settings
vim.diagnostic.config({
	underline = false,
	virtual_text = false,
	jump = {
		on_jump = function(diagnostics, bufnr)
			vim.diagnostic.open_float({
				bufnr,
				namespace = diagnostics.namespace,
				severity = diagnostics.severity,
			})
		end,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "❌",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticError",
			[vim.diagnostic.severity.WARN] = "DiagnosticWarn",
			[vim.diagnostic.severity.INFO] = "DiagnosticInfo",
			[vim.diagnostic.severity.HINT] = "DiagnosticHint",
		},
	},
})

-- Set buffer busy status during LSP progress
vim.api.nvim_create_autocmd("LspProgress", {
	callback = function(args)
		local value = args.data.params.value
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end

		if value.kind == "begin" or value.kind == "report" then
			for bufnr in pairs(client.attached_buffers) do
				vim.bo[bufnr].busy = 1
			end
		elseif value.kind == "end" then
			for bufnr in pairs(client.attached_buffers) do
				vim.bo[bufnr].busy = 0
			end
		end
	end,
})

-- When server finishes progress (e.g., lua_ls finishes indexing), request diagnostics
vim.api.nvim_create_autocmd("LspProgress", {
	pattern = "end",
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end
		for bufnr in pairs(client.attached_buffers) do
			-- For pull diagnostics servers, request refresh
			if client:supports_method("textDocument/diagnostic") then
				vim.lsp.diagnostic._refresh(bufnr, client.id)
			else
				-- For push diagnostics servers, re-send didOpen to trigger diagnostics
				if client:supports_method("textDocument/didOpen") then
					client:notify("textDocument/didOpen", {
						textDocument = {
							uri = vim.uri_from_bufnr(bufnr),
							languageId = vim.bo[bufnr].filetype,
							version = vim.lsp.util.buf_versions[bufnr] or 0,
							text = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n"),
						},
					})
				end
			end
		end
	end,
})

-- Force sign column redraw when diagnostics change
vim.api.nvim_create_autocmd("DiagnosticChanged", {
	callback = function(args)
		vim.api.nvim__redraw({ buf = args.buf, valid = false, statuscolumn = true })
	end,
})
