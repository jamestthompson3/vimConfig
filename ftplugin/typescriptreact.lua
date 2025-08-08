local g = vim.g
local bootstrap = require("tt.ft.ecma").bootstrap()

-- For andymass/vim-matchup plugin
if vim.g.loaded_matchup then
	vim.b.matchpairs = "(:),{:},[:],<:>"
	vim.b.match_words = "<@<=([^/][^ \t>]*)g{hlend}[^>]*%(/@<!>|$):<@<=/\1>"
	vim.b.match_skip = "s:comment|string"
end
bootstrap()
