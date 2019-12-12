require('nvim_utils')
local M = {}

local function map_cmd(...)
  return { ("<Cmd>%s<CR>"):format(table.concat(vim.tbl_flatten {...}, " ")), noremap = true; }
end

local function map_no_cr(...)
  return { (":%s"):format(table.concat(vim.tbl_flatten {...}, " ")), noremap = true; }
end

function M.map()
  local mappings = {
    ["ijj"]            = {"<Esc>",  noremap = false;},
    ['t<C-\\>']        = { [[<C-\><C-n>]], noremap = true;},
    ["n'"]             = {"`", noremap = true;},
    ["nY"]             = {"y$", noremap = true;},
    ["n;"]             = {":", noremap = true;},
    ["n:"]             = {";", noremap = true;},
    ["nwq"]            = map_cmd('silent close'),
    ["ncc"]            = map_cmd('silent cclose'),
    ["ngl"]            = map_cmd('silent pc'),
    ["n<leader><tab>"] = map_cmd('silent bn'),
    ["n[a"]            = map_cmd('silent prev'),
    ["n]a"]            = map_cmd('silent next'),
    ["n[q"]            = map_cmd('silent cnext'),
    ["n]q"]            = map_cmd('silent cprev'),
    ["n[Q"]            = map_cmd('silent cnfile'),
    ["n]Q"]            = map_cmd('silent cpfile'),
    ["n<C-J>"]         = map_cmd [[silent call WinMove('j')]],
    ["n<C-L>"]         = map_cmd [[silent call WinMove('l')]],
    ["n<C-H>"]         = map_cmd [[silent call WinMove('h')]],
    ["n<C-K>"]         = map_cmd [[silent call WinMove('k')]],
    ["n<c-u>"]         = map_cmd [[silent call tools#smoothScroll(1)]],
    ["n<c-d>"]         = map_cmd [[silent call tools#smoothScroll(0)]],
    ["nmks"]           = map_cmd('mks! ~/sessions/'),
    ["nss"]            = map_cmd('so ~/sessions/'),
    ["nssb"]           = map_cmd [[lua require'tools'.sourceSession()]],
    ["nM"]             = map_cmd('silent make'),
    ["n<F7>"]          = map_cmd('silent so "%"'),
    ["n<F1>"]          = map_cmd [[silent call Profiler()]],
    ["n<leader>b"]     = map_cmd('Gblame'),
    ["n<leader>B"]     = map_cmd [[silent call git#blame()]],
    ["x<leader>b"]     = map_cmd('Gblame'),
    ["n<leader>jj"]    = map_cmd('silent ALENext'),
    ["n<leader>kk"]    = map_cmd('silent ALEPrevious'),
    ["nsb"]            = map_no_cr('g//#<Left><Left>'),
    ["ng_"]            = map_no_cr('g//#<Left><Left><C-R><C-W><CR>:'),
    ["n<leader>gab"]   = map_cmd('silent SearchBuffers'),
    ["n<C-p>"]         = map_cmd('silent Files'),
    ["n<C-b>"]         = map_cmd('silent Buffers'),
    ["n<leader>lt"]    = map_cmd [[silent call symbols#ListTags()]],
    ["nts"]            = map_no_cr('ts<space>/')
  }

  nvim_apply_mappings(mappings, {silent = true})
end

M.map()

