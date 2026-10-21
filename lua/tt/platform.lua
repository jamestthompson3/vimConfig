local M = {}

M.is_windows = vim.uv.os_uname().sysname == "Windows_NT"
M.is_wsl = os.getenv("WSL_DISTRO_NAME") ~= nil
M.term_shell = vim.fn.executable("fish") == 1 and "fish" or nil

return M
