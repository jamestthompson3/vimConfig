scriptencoding = utf-8
"                ╔══════════════════════════════════════════╗
"                ║         » Leader AND QUICK ESCAPE «      ║
"                ╚══════════════════════════════════════════╝
let g:mapleader = "\<Space>"
inoremap jj <Esc>

" Escape from terminal mode
if exists(':tnoremap')
 tnoremap <C-\> <C-\><C-n>
endif


"                ╔══════════════════════════════════════════╗
"                ║             » SYSTEM CLIPBOARD «         ║
"                ╚══════════════════════════════════════════╝
xnoremap <Leader>y "+y
xnoremap <Leader>d "+d
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
" Don't trash current register when pasting in visual mode
xnoremap <silent> p p:if v:register == '"'<Bar>let @@=@0<Bar>endif<cr>
"                ╔══════════════════════════════════════════╗
"                ║             » WINDOW MOTIONS «           ║
"                ╚══════════════════════════════════════════╝
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <silent> wq ZZ
nnoremap <silent> q :bp\|bd #<CR>
nnoremap <silent> sq :only<CR>
nnoremap <silent> gl :pc<CR>
"                ╔══════════════════════════════════════════╗
"                ║             » BUFFER SWITCHING «         ║
"                ╚══════════════════════════════════════════╝

nnoremap <silent> <Tab> :bnext<CR>
nnoremap <silent> <S-Tab> :bprevious<CR>
nmap <leader>1 <Plug>BufTabLine.Go(1)
nmap <leader>2 <Plug>BufTabLine.Go(2)
nmap <leader>3 <Plug>BufTabLine.Go(3)
nmap <leader>4 <Plug>BufTabLine.Go(4)
nmap <leader>5 <Plug>BufTabLine.Go(5)
nmap <leader>6 <Plug>BufTabLine.Go(6)
nmap <leader>7 <Plug>BufTabLine.Go(7)
nmap <leader>8 <Plug>BufTabLine.Go(8)
nmap <leader>9 <Plug>BufTabLine.Go(9)
nmap <leader>0 <Plug>BufTabLine.Go(10)

"                ╔══════════════════════════════════════════╗
"                ║                 » PAIRS «               ║
"                ╚══════════════════════════════════════════╝
function! AutoClose(char) abort
  echom a:char
  let l:prevChar = matchstr(getline('.'), '.\%'.col('.').'c')
  if prevChar == a:char
    return a:char
  endif
endfunction

inoremap <silent>(          <C-r>=autopairs#check_and_insert('(')<CR>
inoremap <silent>(<CR>      <C-r>=autopairs#check_and_insert('(')<CR><CR><esc>O<tab>
inoremap <silent>(<space>   <C-r>=autopairs#check_and_insert('(')<CR><space><space><left>
inoremap <silent>{          <C-r>=autopairs#check_and_insert('{')<CR>
inoremap <silent>{<CR>      <C-r>=autopairs#check_and_insert('{')<CR><CR><esc>O<tab>
inoremap <silent>{<space>   <C-r>=autopairs#check_and_insert('{')<CR><space><space><left>
inoremap <silent>[          <C-r>=autopairs#check_and_insert('[')<CR>
inoremap <silent>[          <C-r>=autopairs#check_and_insert('[')<CR><CR><esc>O<tab>
inoremap <silent>[          <C-r>=autopairs#check_and_insert('[')<CR><CR><space><space><left>
inoremap <silent>"          <C-r>=autopairs#check_and_insert('"')<CR>
inoremap <silent>'          <C-r>=autopairs#check_and_insert("'")<CR>
inoremap <silent><          <C-r>=autopairs#check_and_insert('<')<CR>
inoremap `                  ``<left>

"                ╔══════════════════════════════════════════╗
"                ║                 » MACROS «               ║
"                ╚══════════════════════════════════════════╝
nnoremap mm q
"                ╔══════════════════════════════════════════╗
"                ║               » EASY SPLITS «            ║
"                ╚══════════════════════════════════════════╝
nnoremap <silent> sp :vsplit<CR>
nnoremap <silent> sv :split<CR>
"                ╔══════════════════════════════════════════╗
"                ║                » NERDTREE «              ║
"                ╚══════════════════════════════════════════╝
nnoremap <silent><F3> :Vex<CR>
augroup FileNav
  autocmd!
  autocmd FileType dirvish nnoremap <buffer> <silent>D :call DeleteFile()<CR>
  autocmd FileType dirvish nnoremap <buffer> n :e %/
  autocmd FileType dirvish nnoremap <buffer> r :call RenameFile()<CR>
augroup END
"                ╔══════════════════════════════════════════╗
"                ║              » SEARCHING «               ║
"                ╚══════════════════════════════════════════╝
nmap S :%s//g<LEFT><LEFT>
vmap s :s//g<LEFT><LEFT>
nnoremap <silent> <Esc> :noh<CR><Esc>
nnoremap <Leader>sp :SearchProject<space>
nnoremap <silent><Leader>gab :SearchBuffers<CR>
nnoremap <silent> <Leader>fr :FindandReplace<CR>
augroup searching
  autocmd BufReadPost quickfix nnoremap <buffer><silent>ra :ReplaceAll<CR>
  autocmd BufReadPost quickfix nnoremap <buffer>rq :ReplaceQF
augroup END

nnoremap <silent><Leader><Leader> :call Fzf_dev(0)<CR>
nnoremap ts :ts<space>
nnoremap <silent><Leader>. :Buffers<CR>
nnoremap <silent><Leader>r :Files <C-r>=expand("%:h")<CR>/<CR>
nnoremap <silent><c-p> :call Fzf_dev(1)<CR>
nnoremap <silent>, :call Fzf_mru()<CR>
cnoremap <expr> <CR> CCR()
"                ╔══════════════════════════════════════════╗
"                ║                 » GIT «                  ║
"                ╚══════════════════════════════════════════╝

noremap gs :Gstatus<CR>
noremap <Leader>gp :Gpush<CR>
nnoremap <silent><Leader>g :GCheckout<CR>
nnoremap <silent><Leader>gl :Commits<CR>
"
"                ╔══════════════════════════════════════════╗
"                ║           » ALE JUMP TO ERRORS «         ║
"                ╚══════════════════════════════════════════╝
nnoremap <silent> <Leader>jj :ALENext<CR>
nnoremap <silent> <Leader>kk :ALEPrevious<CR>
"                ╔══════════════════════════════════════════╗
"                ║          » BLOCK MANIPULATION «          ║
"                ╚══════════════════════════════════════════╝
vmap <up>    <Plug>SchleppUp
vmap <down>  <Plug>SchleppDown
vmap <left>  <Plug>SchleppLeft
vmap <right> <Plug>SchleppRight

"                ╔══════════════════════════════════════════╗
"                ║               » COMPLETION «             ║
"                ╚══════════════════════════════════════════╝
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
"                ╔══════════════════════════════════════════╗
"                ║             » SPELL CHECK «              ║
"                ╚══════════════════════════════════════════╝
nnoremap <silent><F7> :setlocal spell! spell?<CR>
"                ╔══════════════════════════════════════════╗
"                ║                 » MISC «                 ║
"                ╚══════════════════════════════════════════╝
nnoremap ; :
nnoremap <Leader>; ;
nnoremap mks :mks ~/sessions/
nnoremap ss :so ~/sessions/
set wildchar=<Tab>
function! OpenTerminalDrawer() abort
  execute ':copen'
  execute ':term'
endfunction
nnoremap <silent><Leader>d :call OpenTerminalDrawer()<CR>
nnoremap <Leader>t :Tagbar<CR>
"                ╔══════════════════════════════════════════╗
"                ║              » VIM DEV «                 ║
"                ╚══════════════════════════════════════════╝

function! Profiler() abort
  if exists('g:profiler_running')
    profile pause
    unlet g:profiler_running
    noautocmd qall!
  else
    let g:profiler_running = 1
    profile start profile.log
    profile func *
    profile file *
  endif
endfunction
nmap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
nmap <silent><F5> :so $MYVIMRC<CR>
nmap <silent><F7> :so %<CR>
nmap <silent><F1> :call Profiler()<CR>
