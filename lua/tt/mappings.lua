require("tt.nvim_utils")

local M = {}

function M.map()
  local find_command
  function getFindCommand()
    if 1 == vim.fn.executable("fd") then
      find_command = { "fd", "--type", "f", "--hidden", "-E", ".git", "-E", ".yarn" }
    elseif 1 == vim.fn.executable("fdfind") then
      find_command = { "fdfind", "--type", "f", "--hidden", "-E", ".git", "-E", ".yarn"}
    end
    return { find_command = find_command }
  end


  local insert_mode = {
    -- INSERT MODE
    ["ijj"] = { "<Esc>", noremap = false },
  }
  local normal_mode = {
    ["t<C-\\>"] = { [[<C-\><C-n>]], noremap = true },
    ["n'"] = { "`", noremap = true },
    ["nY"] = { "y$", noremap = true },
    ["n;"] = { ":", noremap = true },
    ["n:"] = { ";", noremap = true },
    ["n/"] = { "ms/", noremap = true },
    ["n<leader>p"] = { '"+p', noremap = true },
    ["n<leader>P"] = { '"+P', noremap = true },
    ["n<C-]>"] = { "g<C-]>", noremap = true },
    ["t<C-\\>"] = { "<C-\\><C-n>", noremap = true },
    ["nwq"] = map_cmd("close"),
    ["ncc"] = map_cmd("cclose"),
    ["ncl"] = map_cmd("lclose"),
    ["ngl"] = map_cmd("pc"),
    ["n<leader><tab>"] = map_cmd("bn"),
    ["n<leader>h"] = map_cmd("call tools#switchSourceHeader()"),
    ["n<leader>e"] = { ":e <C-R>=expand('%:p:h') . '/'<CR>", noremap = true, silent = false },
    ["n<leader>-"] = map_cmd('echo expand("%")'),
    ["n<leader>g"] = map_cmd([[lua require'tt.tools'.lazyGit()]]),
    ["nz/"] = { ":let @/='\\<<C-R>=expand(\"<cword>\")<CR>\\>'<CR>:set hls<CR>", noremap = true },
    ["n[a"] = map_cmd("prev"),
    ["n]a"] = map_cmd("next"),
    ["n[q"] = map_cmd("cnext"),
    ["n]q"] = map_cmd("cprev"),
    ["n[t"] = map_cmd("tnext"),
    ["n]t"] = map_cmd("tprev"),
    ["n[Q"] = map_cmd("cnfile"),
    ["n]Q"] = map_cmd("cpfile"),
    ["n<F3>"] = map_cmd("Vex"),
    ["n<C-J>"] = map_cmd([[lua require'tt.tools'.winMove('j')]]),
    ["n<C-L>"] = map_cmd([[lua require'tt.tools'.winMove('l')]]),
    ["n<C-H>"] = map_cmd([[lua require'tt.tools'.winMove('h')]]),
    ["n<C-K>"] = map_cmd([[lua require'tt.tools'.winMove('k')]]),
    ["nmks"] = map_cmd("mks! ~/sessions/"),
    ["nn"] = map_call("n:call HLNext(0.1)"),
    ["nN"] = map_call("N:call HLNext(0.1)"),
    ["nss"] = map_cmd("so ~/sessions/"),
    ["nssb"] = map_cmd([[lua require'tt.tools'.sourceSession()]]),
    ["nM"] = map_cmd("silent make"),
    -- ["ngh"] = map_cmd("call symbols#ShowDeclaration(0)"),
    ["nsd"] = map_cmd("call symbols#PreviewWord()"),
    ["n<F7>"] = map_cmd('so "%"'),
    ["n<F1>"] = map_cmd([[lua require'tt.tools'.profile()]]),
    ["n<leader>d"] = map_cmd([[lua require'tt.tools'.openTerminalDrawer(0)]]),
    ["n<leader>D"] = map_cmd([[lua require'tt.tools'.openTerminalDrawer(1)]]),
    ["n<leader>b"] = map_cmd("Gblame"),
    ["n<leader>B"] = map_cmd([[silent call git#blame()]]),
    ["n<leader>w"] = map_cmd("MatchupWhereAmI"),
    ["n<leader>jj"] = map_cmd("ALENext"),
    ["n<leader>kk"] = map_cmd("ALEPrevious"),
    ["n<leader>G"] = map_cmd("SearchBuffers"),
    ["n<C-p>"] = map_cmd([[lua require'telescope.builtin'.git_files()]]),
    ["n<C-b>"] = map_cmd([[lua require'telescope.builtin'.buffers()]]),
    ["nT"] = map_cmd([[lua require'telescope.builtin'.tags({ctags_file = vim.bo.tags})]]),
    ["n<leader>lt"] = map_cmd([[lua require'tt.tools'.listTags()]]),
    ["n<leader>t"] = map_cmd([[vsp<CR>:exec("tag ".expand("<cword>"))]]),
    ["n<leader>F"] = map_cmd([[lua require'tt.tools'.simpleMRU()]]),
    ["nS"] = map_no_cr("%s//g<LEFT><LEFT>"),
    ["n<leader>,"] = map_no_cr("Find<space>"),
    ["n,"] = map_no_cr("find<space>"),
    ["nsb"] = map_no_cr("g//#<Left><Left>"),
    ["ng_"] = map_no_cr("g//#<Left><Left><C-R><C-W><CR>:"),
    ["n<leader>."] = map_no_cr("Bs<space>"),
    ["n<C-f>"] = map_no_cr("SearchProject<space>"),
    ["nts"] = map_no_cr("ts<space>/"),
    ["n<up>"] = { ":m .-2<cr>==", noremap = true },
    ["n<down>"] = { ":m .+1<cr>==", noremap = true },
    -- echo the current vim highlight group under the cursor:
    ["n<C-s>"] = {
      ':echo \'hi<\' . synIDattr(synID(line("."),col("."),1),"name") . \'> trans<\' . synIDattr(synID(line("."),col("."),0),"name") . \'> lo<\'  . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . \'>\'<CR>',
      noremap = true,
    },
  }
  local visual_mode = {
    ["x<leader>y"] = { '"+y', noremap = true },
    ["x<leader>d"] = { '"+d', noremap = true },
    ["v<leader>g"] = map_cmd("<C-U>call tools#HighlightRegion('Green')"),
    ["v<leader>G"] = map_cmd("<C-U>call tools#UnHighlightRegion("),
    ["vs"] = map_no_cr("s//g<LEFT><LEFT>"),
    ["x<leader>b"] = map_cmd("Gblame"),
    ["xI"] = { "(mode()=~#'[vV]'?'<C-v>^o^I':'I')", noremap = true, expr = true },
    ["xA"] = { "(mode()=~#'[vV]'?'<C-v>0o$A':'A')", noremap = true, expr = true },
    ["v<up>"] = { ":m '<-2<cr>gv=gv", noremap = true },
    ["v<down>"] = { ":m '>+1<cr>gv=gv", noremap = true },
    -- Don't trash current register when pasting in visual mode
    ["xp"] = { "p:if v:register == '\"'<Bar>let @@=@0<Bar>endif<cr>", noremap = true },
  }
  local command_mode = {
    ["c<CR>"] = { "tools#CCR()", noremap = true, expr = true },
  }

  nvim_apply_mappings(normal_mode, { silent = true })
  nvim_apply_mappings(insert_mode, { silent = true })
  nvim_apply_mappings(visual_mode, { silent = true })
  nvim_apply_mappings(command_mode, { silent = true })
end

return M
