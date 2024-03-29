-- From here: https://gabrielpoca.com/2019-11-13-a-bit-more-lua-in-your-vim/
function NavigationFloatingWin()
	-- get the editor's max width and height
	local width = vim.api.nvim_get_option_value("columns")
	local height = vim.api.nvim_get_option_value("lines")

	-- create a new, scratch buffer, for fzf
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_option_value(buf, "buftype", "nofile")

	-- if the editor is big enough
	if width > 150 or height > 35 then
		-- fzf's window height is 3/4 of the max height, but not more than 30
		local win_height = math.min(math.ceil(height * 3 / 4), 30)
		local win_width

		-- if the width is small
		if width < 150 then
			-- just subtract 8 from the editor's width
			win_width = math.ceil(width - 8)
		else
			-- use 90% of the editor's width
			win_width = math.ceil(width * 0.9)
		end

		-- settings for the fzf window
		local opts = {
			relative = "editor",
			width = win_width,
			height = win_height,
			row = math.ceil((height - win_height) / 2),
			col = math.ceil((width - win_width) / 2),
			style = "minimal",
		}

		-- create a new floating window, centered in the editor
		local win = vim.api.nvim_open_win(buf, true, opts)
	end
end
