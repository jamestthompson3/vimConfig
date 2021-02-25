local autocmds = {
  load_core = {
    {"VimEnter",        "*",      [[lua splashscreen()]]};
    {"VimEnter",        "*",      [[nested lua require'tt.tools'.openQuickfix()]]};
    {"SwapExists",      "*",      "call AS_HandleSwapfile(expand('<afile>:p'), v:swapname)"};
    {"TextYankPost",    "*",      [[silent! lua require'vim.highlight'.on_yank()]]};
    {"BufNewFile",      "*.html", "0r ~/vim/skeletons/skeleton.html"};
    {"BufNewFile",      "*.tsx",  "0r ~/vim/skeletons/skeleton.tsx"};
    {"BufNewFile",      "*.md",   "0r ~/vim/skeletons/skeleton.md"};
    {"VimLeavePre",     "*",      [[lua require'tt.tools'.saveSession()]]};
    -- {"TermClose",       "*",      [[lua vim.api.nvim_input("i<esc>") ]]};
    {"TermEnter",       "*",      "set nonumber"};
    {"VimEnter",        "*",      [[lua require'tt.tools'.configurePlugins()]]};
    {"Syntax",          "*",      [[lua require'tt.tools'.setCustomGroups()]]};
    {"BufWritePre",     "*",      [[if !isdirectory(expand("<afile>:p:h"))|call mkdir(expand("<afile>:p:h"), "p")|endif]]};
    {"BufWritePre",     "*",      [[lua require'tt.tools'.removeWhitespace()]]};
    {"QuickFixCmdPost", "[^l]*",  [[nested lua require'tt.tools'.openQuickfix()]]};
    {"CursorHold,BufWritePost,BufReadPost,BufLeave", "*", [[if isdirectory(expand("<amatch>:h"))|let &swapfile = &modified|endif]]};
    -- { "FileType,BufWinEnter,BufReadPost,BufWritePost,BufEnter,WinEnter,FileChangedShellPost,VimResized" , "*", [[lua vim.wo.statusline = "%!SL()"]] };
    -- {"WinLeave", "*", [[lua vim.wo.statusline = "%f"]]};
    {"CursorMoved",        "*",     [[lua require'tt.tools'.clearBlameVirtText()]]};
    {"CursorMovedI",        "*",     [[lua require'tt.tools'.clearBlameVirtText()]]};
    {"FocusGained,CursorMoved,CursorMovedI", "*", "checktime"};
  };
  ft = {
    {"FileType netrw au BufLeave netrw close"};
    {"FileType lua inoremap <C-l> log()<esc>i"};
    {"FileType typescript,typescript.tsx,typescriptreact,javascriptreact,javascript,javascript.jsx nnoremap <leader>i biimport {<esc>ea} from ''<esc>i"};
    {"FileType dirvish nnoremap <buffer> <silent>D :lua require'tt.tools'.deleteFile()<CR>"};
    {"FileType dirvish nnoremap <buffer> n :e %"};
    {"FileType dirvish nnoremap <buffer> r :lua require'tt.tools'.renameFile()<CR>"};
    {"FileType netrw nnoremap <buffer> q :close<CR>"};
  };
  windows = {
    {"WinEnter", "*", "set number"};
    {"WinLeave", "*", "set nonumber"};
  };
  bufs = {
    {"BufReadPost quickfix nnoremap <buffer><silent>ra :ReplaceAll<CR>"};
    {"BufReadPost quickfix nnoremap <buffer>rq :ReplaceQF"};
    {"BufReadPost quickfix nnoremap <buffer>R  :Cfilter!<space>"};
    {"BufReadPost quickfix nnoremap <buffer>K  :Cfilter<space>"};
    {"BufReadPost",         "*.fugitiveblame", "set ft=fugitiveblame"};
  };
  ft_detect = {
    { "BufRead,BufNewFile",  "*.nginx", "set ft=nginx"};
    { "BufRead,BufNewFile", "nginx*.conf", "set ft=nginx"};
    { "BufRead,BufNewFile", "*nginx.conf","set ft=nginx"};
    { "BufRead,BufNewFile", "*/etc/nginx/*","set ft=nginx"};
    { "BufRead,BufNewFile", "*/usr/local/nginx/conf/*","set ft=nginx"};
    { "BufRead,BufNewFile", "*/nginx/*.conf","set ft=nginx"};
    { "BufNewFile,BufRead", "*.bat,*.sys", "set ft=dosbatch"};
    { "BufNewFile,BufRead", "*.mm,*.m", "set ft=objc"};
    { "BufNewFile,BufRead", "*.h,*.m,*.mm","set tags+=~/global-objc-tags"};
    { "BufNewFile,BufRead", "*.tsx", "setlocal commentstring=//%s"};
    { "BufNewFile,BufRead", "*.svelte", "setfiletype html"};
    { "BufNewFile,BufRead", "*.eslintrc,*.babelrc,*.prettierrc,*.huskyrc", "set ft=json"};
    { "BufNewFile,BufRead", "*.pcss", "set ft=css"};
    { "BufNewFile,BufRead", "*.wiki", "set ft=wiki"};
    { "BufRead,BufNewFile", "[Dd]ockerfile","set ft=Dockerfile"};
    { "BufRead,BufNewFile", "Dockerfile*","set ft=Dockerfile"};
    { "BufRead,BufNewFile", "[Dd]ockerfile.vim" ,"set ft=vim"};
    { "BufRead,BufNewFile", "*.dock", "set ft=Dockerfile"};
    { "BufRead,BufNewFile", "*.[Dd]ockerfile","set ft=Dockerfile"};
  };
}
nvim_create_augroups(autocmds)
