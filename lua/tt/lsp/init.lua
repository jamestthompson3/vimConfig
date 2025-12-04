local node = require("tt.nvim_utils").nodejs

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.semanticTokens.multilineTokenSupport = true
-- capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
vim.lsp.config("*", {
	root_markers = { ".git", "root_marker" },
	capabilities = capabilities,
})
local on_attach = function(client, bufnr)
	require("tt.lsp.mappings").setMappings(bufnr)
	if not client then
		return
	end
	if client.server_capabilities.completionProvider then
		vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
	end
	vim.lsp.completion.enable(true, client.id, bufnr, {
		autotrigger = true,
		convert = function(item)
			return { abbr = item.label:gsub("%b()", "") }
		end,
	})
	if client.server_capabilities.definitionProvider then
		-- vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
	end
	-- Enable inlay hints if supported
	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end
	-- show documentation popups
	local supports_resolve = client:supports_method(vim.lsp.protocol.Methods.completionItem_resolve)
	local _, cancel_prev = nil, function() end
	vim.api.nvim_create_autocmd("CompleteChanged", {
		buffer = bufnr,
		callback = function()
			cancel_prev()
			local info = vim.fn.complete_info({ "selected" })
			local completionItem = vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp", "completion_item")
			if nil == completionItem then
				return
			end
			if not supports_resolve then
				return
			end
			_, cancel_prev = vim.lsp.buf_request(
				bufnr,
				vim.lsp.protocol.Methods.completionItem_resolve,
				completionItem,
				function(err, item)
					if err then
						return
					end
					if not item then
						return
					end
					local docs = (item.documentation or {}).value
					local win = vim.api.nvim__complete_set(info["selected"], { info = docs })
					if win.winid and vim.api.nvim_win_is_valid(win.winid) then
						vim.treesitter.start(win.bufnr, "markdown")
						vim.wo[win.winid].conceallevel = 3
					end
				end
			)
		end,
	})
end

local servers = {
	lua_ls = {
		filetypes = { "lua" },
		setup = function()
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
								-- Depending on the usage, you might want to add additional paths
								-- here.
								-- '${3rd}/luv/library'
								-- '${3rd}/busted/library'
							},
						},
					})
				end,
				settings = {
					Lua = {},
				},
				cmd = { "lua-language-server" },
			}
		end,
	},
	html = {
		filetypes = { "html", "templ" },
		setup = function()
			vim.lsp.config.html = {
				filetypes = { "html", "templ" },
				on_attach = function(client, bufnr)
					on_attach(client, bufnr)
				end,
				init_options = {
					documentFormatting = false,
				},
				cmd = { node.get_node_bin("html-languageserver"), "--stdio" },
			}
		end,
	},
	zls = {
		filetypes = { "zig" },
		setup = function()
			vim.lsp.config.zls = {
				filetypes = { "zig", "zon" },
				on_attach = on_attach,
				cmd = { "zls" },
			}
		end,
	},
	sqls = {
		filetypes = { "sql", "mysql" },
		setup = function()
			vim.lsp.config.sqls = {
				cmd = { "sqls" },
				filetypes = { "sql", "mysql" },
				on_attach = function(client, bufnr)
					require("sqls").on_aa_attach(client, bufnr)
				end,
			}
		end,
	},
	biome = {
		condition = function()
			local biome_roots = {
				"biome.json",
				"biome.jsonc",
			}
			return vim.fs.root(0, biome_roots)
		end,
		filetypes = {
			"astro",
			"css",
			"graphql",
			"javascript",
			"javascriptreact",
			"json",
			"jsonc",
			"svelte",
			"typescript",
			"typescript.tsx",
			"typescriptreact",
			"vue",
		},
		setup = function()
			vim.lsp.config.biome = {
				cmd = { node.get_node_bin("biome"), "lsp-proxy" },
				root_markers = {
					"biome.json",
					"biome.jsonc",
				},
				filetypes = {
					"astro",
					"css",
					"graphql",
					"javascript",
					"javascriptreact",
					"json",
					"jsonc",
					"svelte",
					"typescript",
					"typescript.tsx",
					"typescriptreact",
					"vue",
				},
				on_attach = on_attach,
			}
		end,
	},
	rust_analyzer = {
		filetypes = { "rust" },
		setup = function()
			vim.lsp.config.rust_analyzer = {
				on_attach = on_attach,
				cmd = { "rust-analyzer" },
				filetypes = { "rust" },
				checkOnSave = {
					enabled = true,
					command = "clippy",
				},
			}
		end,
	},
	gopls = {
		filetypes = { "go" },
		setup = function()
			vim.lsp.config.gopls = {
				filetypes = { "go" },
				cmd = { "gopls", "serve" },
				on_attach = on_attach,
				analyses = {
					unusedparams = true,
					staticcheck = true,
				},
			}
		end,
	},
	bashls = {
		filetypes = { "bash" },
		setup = function()
			vim.lsp.config.bashls = {
				on_attach = on_attach,
				cmd = { node.get_node_bin("bash-language-server"), "start" },
			}
		end,
	},
	clangd = {
		filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
		setup = function()
			vim.lsp.config.clangd = {
				cmd = { "clangd" },
				filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
				on_attach = on_attach,
			}
		end,
	},
	astrols = {
		filetypes = {
			"astro",
		},
		setup = function()
			vim.lsp.config.astrols = {
				cmd = { node.get_node_bin("astro-ls"), "--stdio" },
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
					require("ts-error-translator").setup()
					on_attach(client, bufnr)
				end,
				filetypes = {
					"astro",
				},
				init_options = {
					typescript = {
						tsdk = node.get_node_lib("typescript/lib"),
					},
				},
				root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
			}
		end,
	},
	ts_ls = {
		filetypes = {
			"javascript",
			"javascriptreact",
			"javascript.jsx",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
		},
		setup = function()
			vim.lsp.config.ts_ls = {
				filetypes = {
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
				},
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
					require("ts-error-translator").setup()
					on_attach(client, bufnr)
				end,
				capabilities = capabilities,
				cmd = { node.find_node_executable("typescript-language-server"), "--stdio" },
				init_options = {
					hostInfo = "neovim",
					tsserver = {
						path = node.get_node_lib("typescript/lib"),
					},
				},
				root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
				single_file_support = true,
			}
		end,
	},
	-- ctags_lsp = {
	-- 	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	-- 	setup = function()
	-- 		vim.lsp.config.ctags_lsp = {
	-- 			filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	-- 			cmd = { "ctags-lsp" },
	-- 			on_attach = on_attach,
	-- 		}
	-- 	end,
	-- },
	-- pylsp = {
	-- 	filetypes = { "python" },
	-- 	setup = function()
	-- 		vim.lsp.config.pylsp = {
	-- 			filetypes = { "python" },
	-- 			cmd = { "pylsp" },
	-- 			root_markers = {
	-- 				"pyproject.toml",
	-- 				"setup.py",
	-- 				"setup.cfg",
	-- 				"requirements.txt",
	-- 				"Pipfile",
	-- 				".git",
	-- 			},
	-- 			single_file_support = true,
	-- 			settings = {
	-- 				pylsp = {
	-- 					plugins = {
	-- 						-- formatter options
	-- 						black = { enabled = true },
	-- 						autopep8 = { enabled = false },
	-- 						yapf = { enabled = false },
	-- 						-- linter options
	-- 						pylint = { enabled = true, executable = "pylint" },
	-- 						pyflakes = { enabled = false },
	-- 						pycodestyle = { enabled = false },
	-- 						-- type checker
	-- 						pylsp_mypy = { enabled = true },
	-- 						-- auto-completion options
	-- 						jedi_completion = { fuzzy = true },
	-- 						-- import sorting
	-- 						pyls_isort = { enabled = true },
	-- 					},
	-- 				},
	-- 			},
	-- 		}
	-- 	end,
	-- },
}

-- LSP settings

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	underline = false,
	virtual_text = false,
	signs = true,
})
vim.diagnostic.config({
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
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticError",
			[vim.diagnostic.severity.WARN] = "DiagnosticWarn",
			[vim.diagnostic.severity.INFO] = "DiagnosticInfo",
			[vim.diagnostic.severity.HINT] = "DiagnosticHint",
		},
	},
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		-- A guard to prevent setting up the same server multiple times
		local ft_setup_done = vim.b[args.buf].ft_setup_done or {}
		if ft_setup_done[args.match] then
			return
		end

		for name, server in pairs(servers) do
			if vim.tbl_contains(server.filetypes, args.match) then
				if server.condition ~= nil then
					if server.condition() then
						server.setup()
					end
				else
					server.setup()
				end
				ft_setup_done[args.match] = true
				if vim.lsp.config[name] then
					vim.lsp.start(vim.lsp.config[name])
				end
			end
		end
		vim.b[args.buf].ft_setup_done = ft_setup_done
	end,
})
