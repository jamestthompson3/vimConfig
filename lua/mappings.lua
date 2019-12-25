require('nvim_utils')
local M = {}

local function map_cmd(...)
  return { ("<Cmd>%s<CR>"):format(table.concat(vim.tbl_flatten {...}, " ")), noremap = true; }
end

local function map_call(...)
  return { ("%s<CR>"):format(table.concat(vim.tbl_flatten {...}, " ")), noremap = true; }
end

local function map_no_cr(...)
  return { (":%s"):format(table.concat(vim.tbl_flatten {...}, " ")), noremap = true; }
end


function M.map()
  local mappings = {
    ["ijj"]            = {"<Esc>",  noremap = false},
    ['t<C-\\>']        = { [[<C-\><C-n>]], noremap = true},
    ["n'"]             = {"`", noremap = true},
    ["nY"]             = {"y$", noremap = true},
    ["n;"]             = {":", noremap = true},
    ["n:"]             = {";", noremap = true},
    ["n/"]             = {"ms/", noremap = true},
    ["x<Space>y"]      = {'\"+y', noremap = true},
    ["x<Space>d"]      = {'\"+d', noremap = true},
    ["n<Space>p"]      = {'\"+p', noremap = true},
    ["n<Space>P"]      = {'\"+P', noremap = true},
    ["n<C-]>"]         = {'g<C-]>', noremap = true},
    ["t<Esc>"]         = {'<C-\\><C-n>', noremap = true},
    ["nwq"]            = map_cmd('close'),
    ["ncc"]            = map_cmd('cclose'),
    ["ngl"]            = map_cmd('pc'),
    ["n<leader><tab>"] = map_cmd('bn'),
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
    ["n<c-u>"]         = map_cmd [[call tools#smoothScroll(1)]],
    ["n<c-d>"]         = map_cmd [[call tools#smoothScroll(0)]],
    ["nmks"]           = map_cmd('mks! ~/sessions/'),
    ["nn"]             = map_call('n:call HLNext(0.1)'),
    ["nN"]             = map_call('N:call HLNext(0.1)'),
    ["nss"]            = map_cmd('so ~/sessions/'),
    ["nssb"]           = map_cmd [[lua require'tools'.sourceSession()]],
    ["nM"]             = map_cmd('silent make'),
    ["ngh"]            = map_cmd('call symbols#ShowDeclaration(0)'),
    ["n]]"]            = map_cmd('ijump <C-R><C-W>'),
    ["nsd"]            = map_cmd('call symbols#PreviewWord()'),
    ["n<F7>"]          = map_cmd('so "%"'),
    ["n<F1>"]          = map_cmd [[call Profiler()]],
    ["n<leader>b"]     = map_cmd('Gblame'),
    ["n<leader>B"]     = map_cmd [[silent call git#blame()]],
    ["x<leader>b"]     = map_cmd('Gblame'),
    ["n<leader>jj"]    = map_cmd('ALENext'),
    ["n<leader>kk"]    = map_cmd('ALEPrevious'),
    ["n<leader>gab"]   = map_cmd('SearchBuffers'),
    ["n<C-p>"]         = map_cmd('Files'),
    ["n<C-b>"]         = map_cmd('Buffers'),
    ["n<leader>lt"]    = map_cmd [[lua require'tools'.listTags()]],
    ["n<Space>F"]      = map_cmd [[lua require'tools'.simpleMru()]],
    ["nS"]             = map_no_cr('%s//g<LEFT><LEFT>'),
    ["vs"]             = map_no_cr('s//g<LEFT><LEFT>'),
    ["nsb"]            = map_no_cr('g//#<Left><Left>'),
    ["ng_"]            = map_no_cr('g//#<Left><Left><C-R><C-W><CR>:'),
    ["n<Space>."]      = map_no_cr('Bs<space>'),
    ["nts"]            = map_no_cr('ts<space>/'),
    ["n,"]             = map_no_cr('find<space>')
  }

  nvim_apply_mappings(mappings, {silent = true})
end

M.map()

