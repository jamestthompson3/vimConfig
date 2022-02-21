local g = vim.g
local bootstrap = require("tt.ft.ecma").bootstrap

g.jsx_ext_required = 0
g.javascript_plugin_jsdoc = 1
g.javascript_plugin_ngdoc = 1
g.javascript_plugin_flow = 1
g.vim_json_syntax_conceal = 0
-- changes const thing = require("thing-lib")
-- to import thing from \"thing-lib" -> the backlash isn't included in the
-- transform, I just need it for vim comments
-- TODO: do this with snippets?
-- let @i = 'ceimportf=cf(from f)x'

vim.bo.makeprg = "node %"

-- Error: bar
--     at Object.foo [as _onTimeout] (/Users/Felix/.vim/bundle/vim-nodejs-errorformat/test.js:2:9)
local efm = {
	"%AError: %m",
	"%AEvalError: %m",
	"%ARangeError: %m",
	"%AReferenceError: %m",
	"%ASyntaxError: %m",
	"%ATypeError: %m",
	"%Z%*[ ]at %f:%l:%c",
	"%Z%*[ ]%m (%f:%l:%c)",
}

--     at Object.foo [as _onTimeout] (.vim/bundle/vim-nodejs-errorformat/test.js:2:9)
table.insert(efm, "%*[ ]%m (%f:%l:%c)")

--     at node.js:903:3
table.insert(efm, "%*[ ]at %f:%l:%c")

-- .vim/bundle/vim-nodejs-errorformat/test.js:2
--   throw new Error('bar');
--         ^
table.insert(efm, "%Z%p^,%A%f:%l,%C%m")

-- Ignore everything else
table.insert(efm, "%-G%.%#")
vim.bo.errorformat = table.concat(efm, "")
bootstrap()
