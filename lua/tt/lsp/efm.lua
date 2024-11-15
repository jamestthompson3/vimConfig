local node = require("tt.nvim_utils").nodejs
local formatting = require("tt.formatting")

local M = {}

function M.setup()
  local eslintd = {
    lintCommand = node.find_node_executable("eslint_d") .. " -f unix --stdin --stdin-filename ${INPUT}",
    lintStdin = true,
    lintFormats = { "%f:%l:%c: %m" },
    lintIgnoreExitCode = true,
  }

  local prettier = {
    formatCommand = string.format(
      "%s '${INPUT}'",
      node.find_node_executable("prettier")
    ),
    fmtStdin = true,
  }

  local prettier_html = {
    formatCommand = string.format("%s, --parser html '${INPUT}'", node.find_node_executable("prettier")),
    fmtStdin = true,
  }

  local gofmt = {
    formatCommand = "gofmt",
    formatStdin = true,
  }

  local rustfmt = {
    formatCommand = "rustfmt" .. ' "${INPUT}"' .. " --emit=stdout -q",
    formatStdin = true,
  }

  local stylua = {
    formatCommand = "stylua --color Never '${INPUT}'",
    formatStdin = false,
  }
  local clangfmt = {
    formatCommand = "clang-format ${INPUT}",
    formatStdin = true,
  }
  require("lspconfig").efm.setup({
    on_attach = function(client, bufnr)
      if vim.g.autoformat == true then
        -- formatting.fmt_on_attach(client, bufnr)
        -- vim.api.nvim_create_autocmd("BufWritePost", {
        -- 	buffer = bufnr,
        -- 	callback = function()
        -- 		vim.lsp.buf.format({ async = false, id = client.id })
        -- 	end,
        -- })
      end
    end,
    init_options = { documentFormatting = true },
    filetypes = vim.g.autoformat_ft,
    settings = {
      rootMarkers = { "package.json", ".git/", "Cargo.toml", "go.mod" },
      languages = {
        -- javascript = { prettier, eslintd },
        -- typescript = { prettier, eslintd },
        -- eta = { prettier },
        -- javascriptreact = { prettier, eslintd },
        -- typescriptreact = { prettier, eslintd },
        json = {
          {
            formatCommand = "prettierd --parser json",
            lintCommand = "jq .",
            lintStdin = true,
          },
        },
        html = { prettier },
        css = { prettier },
        markdown = { prettier },
        yaml = { prettier },
        go = { gofmt },
        rust = { rustfmt },
        lua = { stylua },
        cpp = {clangfmt},
        objc = {clangfmt},
        objcpp = {clangfmt},
      },
    },
  })
end

return M
