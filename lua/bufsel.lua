local function bufsel_select()
  local bufcount = vim.api.nvim_command('bufnr($)')
  vim.api.nvim_command(string.format('echo %d', bufcount))
end
