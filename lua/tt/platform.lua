local M = {}

M.is_windows = vim.uv.os_uname().sysname == "Windows_NT"
M.is_wsl = os.getenv("WSL_DISTRO_NAME") ~= nil

return M
