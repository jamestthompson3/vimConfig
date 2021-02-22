require('tt.nvim_utils')
local M = {}

function M.map()
  function getFindCommand()
    if 1 == vim.fn.executable("fd") then
      find_command = { 'fd','--type', 'f', '--hidden', '-E', '.git'}
    elseif 1 == vim.fn.executable("fdfind") then
      find_command = { 'fdfind','--type', 'f', '--hidden', '-E', '.git' }
    end
    return {find_command = find_command }
  end
  local mappings = {
    ["ijj"]            = {"<Esc>",  noremap = false},
    ['t<C-\\>']        = { [[<C-\><C-n>]], noremap = true},
    ["n'"]             = {"`", noremap = true},
    ["nY"]             = {"y$", noremap = true},
    ["n;"]             = {":", noremap = true},
    ["n:"]             = {";", noremap = true},
    ["n/"]             = {"ms/", noremap = true},
    ["x<leader>y"]     = {'\"+y', noremap = true},
    ["x<leader>d"]     = {'\"+d', noremap = true},
    ["n<leader>p"]     = {'\"+p', noremap = true},
    ["n<leader>P"]     = {'\"+P', noremap = true},
    ["n<C-]>"]         = {'g<C-]>', noremap = true},
    ["t<C-\\>"]        = {'<C-\\><C-n>', noremap = true},
    ["nwq"]            = map_cmd('close'),
    ["ncc"]            = map_cmd('cclose'),
    ["ngl"]            = map_cmd('pc'),
    ["n<leader><tab>"] = map_cmd('bn'),
    ["n<leader>-"]     = map_cmd('echo expand("%")'),
    ["n<leader>g"]     = map_cmd [[lua require'tt.tools'.lazyGit()]],
    ["n[a"]            = map_cmd('prev'),
    ["n]a"]            = map_cmd('next'),
    ["n[q"]            = map_cmd('cnext'),
    ["n]q"]            = map_cmd('cprev'),
    ["n[Q"]            = map_cmd('cnfile'),
    ["n]Q"]            = map_cmd('cpfile'),
    ["n<F3>"]          = map_cmd('Vex'),
    ["n<C-J>"]         = map_cmd [[call WinMove('j')]],
    ["n<C-L>"]         = map_cmd [[call WinMove('l')]],
    ["n<C-H>"]         = map_cmd [[call WinMove('h')]],
    ["n<C-K>"]         = map_cmd [[call WinMove('k')]],
    -- ["n<c-u>"]         = map_cmd [[call tools#smoothScroll(1)]],
    -- ["n<c-d>"]         = map_cmd [[call tools#smoothScroll(0)]],
    ["nmks"]           = map_cmd('mks! ~/sessions/'),
    ["nn"]             = map_call('n:call HLNext(0.1)'),
    ["nN"]             = map_call('N:call HLNext(0.1)'),
    ["nss"]            = map_cmd('so ~/sessions/'),
    ["nssb"]           = map_cmd [[lua require'tt.tools'.sourceSession()]],
    ["nM"]             = map_cmd('silent make'),
    ["ngh"]            = map_cmd('call symbols#ShowDeclaration(0)'),
    ["n]]"]            = map_cmd('ijump <C-R><C-W>'),
    ["nsd"]            = map_cmd('call symbols#PreviewWord()'),
    ["n<F7>"]          = map_cmd('so "%"'),
    ["n<F1>"]          = map_cmd [[lua require'tt.tools'.profile()]],
    ["n<leader>d"]     = map_cmd [[lua require'tt.tools'.openTerminalDrawer(0)]],
    ["n<leader>D"]     = map_cmd [[lua require'tt.tools'.openTerminalDrawer(1)]],
    ["n<leader>b"]     = map_cmd('Gblame'),
    ["n<leader>B"]     = map_cmd [[silent call git#blame()]],
    ["n<leader>w"]     = map_cmd('MatchupWhereAmI'),
    ["x<leader>b"]     = map_cmd('Gblame'),
    ["n<leader>jj"]    = map_cmd('ALENext'),
    ["n<leader>kk"]    = map_cmd('ALEPrevious'),
    ["n<leader>G"]     = map_cmd('SearchBuffers'),
    ["n<C-p>"]         = map_cmd [[lua require'telescope.builtin'.find_files(getFindCommand())]],
    ["nR"]             = map_cmd [[lua require'telescope.builtin'.live_grep()]],
    ["n<C-b>"]         = map_cmd [[lua require'telescope.builtin'.buffers()]],
    ["nT"]             = map_cmd [[lua require'telescope.builtin'.tags({ctags_file = vim.bo.tags})]],
    ["n<leader>lt"]    = map_cmd [[lua require'tt.tools'.listTags()]],
    ["n<leader>t"]     = map_cmd [[vsp<CR>:exec("tag ".expand("<cword>"))]],
    ["n<leader>F"]     = map_cmd [[lua require'tt.tools'.simpleMRU()]],
    ["v<leader>g"]     = map_cmd("<C-U>call tools#HighlightRegion('Green')"),
    ["v<leader>G"]     = map_cmd('<C-U>call tools#UnHighlightRegion('),
    ["nS"]             = map_no_cr('%s//g<LEFT><LEFT>'),
    ["n<leader>,"]     = map_no_cr('Find<space>'),
    ["n,"]             = map_no_cr('find<space>'),
    ["vs"]             = map_no_cr('s//g<LEFT><LEFT>'),
    ["nsb"]            = map_no_cr('g//#<Left><Left>'),
    ["ng_"]            = map_no_cr('g//#<Left><Left><C-R><C-W><CR>:'),
    ["n<leader>."]     = map_no_cr('Bs<space>'),
    ["nts"]            = map_no_cr('ts<space>/'),
    ["n<C-f>"]         = map_no_cr('SearchProject<space>')
  }

  nvim_apply_mappings(mappings, {silent = true})

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn.call("vsnip#available", {1}) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<down>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<down>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<up>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<up>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<C-J>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<C-J>", "v:lua.tab_complete()", {expr = true})

end

M.map()
