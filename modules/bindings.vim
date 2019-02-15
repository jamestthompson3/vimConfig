scriptencoding = utf-8

let g:mapleader = "\<Space>"
inoremap jj <Esc>

" Escape from terminal mode
if exists(':tnoremap')
 tnoremap <C-\> <C-\><C-n>
endif


" System clipboard: {{{
xnoremap <Leader>y "+y
xnoremap <Leader>d "+d
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
" Don't trash current register when pasting in visual mode
xnoremap <silent> p p:if v:register == '"'<Bar>let @@=@0<Bar>endif<cr>
" }}}

" Window motions: {{{
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <silent> wq ZZ
nnoremap <silent> q :bp\|bd #<CR>
nnoremap <silent> sq :only<CR>
nnoremap <silent> gl :pc<CR>
" }}}

" Buffer switching: {{{
nnoremap <silent> <Tab> :bnext<CR>
nnoremap <silent> <S-Tab> :bprevious<CR>
nnoremap <silent> [q :cnext<CR>
nnoremap <silent> ]q :cprev<CR>
" }}}

" Pairs: {{{
inoremap <silent>(          <C-r>=autopairs#check_and_insert('(')<CR>
inoremap <silent>(<CR>      <C-r>=autopairs#check_and_insert('(')<CR><CR><esc>O
inoremap <silent>(<space>   <C-r>=autopairs#check_and_insert('(')<CR><space><space><left>
inoremap <silent>{          <C-r>=autopairs#check_and_insert('{')<CR>
inoremap <silent>{<CR>      <C-r>=autopairs#check_and_insert('{')<CR><CR><esc>O
inoremap <silent>{<space>   <C-r>=autopairs#check_and_insert('{')<CR><space><space><left>
inoremap <silent>[          <C-r>=autopairs#check_and_insert('[')<CR>
inoremap <silent>[<CR>          <C-r>=autopairs#check_and_insert('[')<CR><CR><esc>O
inoremap <silent>[<space>          <C-r>=autopairs#check_and_insert('[')<CR><CR><space><space><left>
inoremap <silent>"          <C-r>=autopairs#check_and_insert('"')<CR>
inoremap <silent>'          <C-r>=autopairs#check_and_insert("'")<CR>
inoremap <silent><          <C-r>=autopairs#check_and_insert('<')<CR>
inoremap `                  ``<left>
" }}}

nnoremap mm q
" Splits: {{{
nnoremap <silent> sp :vsplit<CR>
nnoremap <silent> sv :split<CR>
" }}}

" Files: {{{
nnoremap <silent><F3> :Vex<CR>
augroup FileNav
  autocmd!
  autocmd FileType dirvish nnoremap <buffer> <silent>D :call tools#DeleteFile()<CR>
  autocmd FileType dirvish nnoremap <buffer> n :e %/
  autocmd FileType dirvish nnoremap <buffer> r :call tools#RenameFile()<CR>
augroup END
" }}}

" Search: {{{
nmap S :%s//g<LEFT><LEFT>
vmap s :s//g<LEFT><LEFT>
nnoremap <Leader>sp :SearchProject<space>
nnoremap <silent><Leader>gab :SearchBuffers<CR>
nnoremap <silent> <Leader>fr :FindandReplace<CR>
nnoremap <silent><Leader>lt :call tools#ListTags()<CR>
nnoremap ts :ts<space>
nnoremap <silent><Leader>r :Files <C-r>=expand("%:h")<CR>/<CR>
nnoremap , :find<space>
cnoremap <expr> <CR> tools#CCR()
nnoremap <silent>sd :call tools#PreviewWord()<CR>

augroup searching
  autocmd BufReadPost quickfix nnoremap <buffer><silent>ra :ReplaceAll<CR>
  autocmd BufReadPost quickfix nnoremap <buffer>rq :ReplaceQF
augroup END
" }}}

" Git: {{{
augroup git
  autocmd FileType fugitive nnoremap <buffer>P :Gpush<CR>
augroup END
nnoremap <silent><Leader>g :GCheckout<CR>
nnoremap <silent><Leader>gl :Commits<CR>
" }}}

" ALE: {{{
nnoremap <silent> <Leader>jj :ALENext<CR>
nnoremap <silent> <Leader>kk :ALEPrevious<CR>
" }}}

" Blocks: {{{
xmap <up>    <Plug>SchleppUp
xmap <down>  <Plug>SchleppDown
xmap <left>  <Plug>SchleppLeft
xmap <right> <Plug>SchleppRight
" }}}

" Completion: {{{
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
" }}}

" Misc: {{{
nnoremap ; :
nnoremap <Leader>; ;
nnoremap mks :mks! ~/sessions/
nnoremap ss :so ~/sessions/

function! OpenTerminalDrawer() abort
  execute 'copen'
  execute 'term'
endfunction

nnoremap <silent><Leader>d :call OpenTerminalDrawer()<CR>
nnoremap <Leader>t :Tagbar<CR>
nnoremap z/ :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
" }}}

" VimDev: {{{
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
" }}}
