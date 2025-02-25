local node = require("tt.nvim_utils").nodejs

local M = {}

local prettierbin = node.find_node_executable("prettier")
function M.setup()
  local eslintd = {
    lintCommand = node.find_node_executable("eslint_d") .. " -f unix --stdin --stdin-filename ${INPUT}",
    lintStdin = true,
    lintFormats = { "%f:%l:%c: %m" },
    lintIgnoreExitCode = true,
  }


  local gofmt = {
    formatCommand = "gofmt",
    formatStdin = true,
  }

  local rustfmt = {
    formatCommand = "rustfmt" .. ' "${INPUT}"' .. " --emit=stdout -q",
    formatStdin = true,
  }

  local clangfmt = {
    formatCommand = "clang-format ${INPUT}",
    formatStdin = true,
  }
  vim.lsp.config.efm = {
    cmd = { "efm-langserver" },
    on_attach = function(client, bufnr)
      if vim.g.autoformat == true then
        vim.api.nvim_create_autocmd("BufWritePost", {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ async = false, id = client.id })
          end,
        })
      end
    end,
    init_options = { documentFormatting = true },
    settings = {
      -- rootMarkers = { "package.json", ".git/", "Cargo.toml", "go.mod" },
      languages = {
        javascript = { eslintd },
        typescript = { eslintd },
        javascriptreact = { eslintd },
        typescriptreact = { eslintd },
        json = {
          {
            formatCommand = string.format("%s, --parser json --stdin-filepath", node.find_node_executable("prettier"),
              vim.api.nvim_buf_get_name(0)),
            lintCommand = "jq .",
            lintStdin = true,
          },
        },
        go = { gofmt },
        rust = { rustfmt },
        cpp = { clangfmt },
        objc = { clangfmt },
        objcpp = { clangfmt },
      },
    },
  }
end

return M
