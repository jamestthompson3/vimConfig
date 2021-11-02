-- Check if the packer tool exists
local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])

local download_packer = function ()
	if vim.fn.input("Download Packer? (y for yes)") ~= "y" then
		return
	end

	local directory = string.format("%s/pack/packer/opt", vim.fn.stdpath("config"))

	vim.fn.mkdir(directory, "p")

	local out = vim.fn.system(string.format(
		"git clone %s %s",
		"https://github.com/wbthomason/packer.nvim",
		directory .. "/packer.nvim"
	))

	print(out)
	print("Downloading packer.nvim...")
end
return function()
if not packer_exists then
  download_packer()
	return true
else
  return false
end
end
