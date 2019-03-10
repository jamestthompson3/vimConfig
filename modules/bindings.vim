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
nnoremap <silent> Q :bp\|bd #<CR>
nnoremap <silent> cc :cclose<CR>
nnoremap <silent> sq :only<CR>
nnoremap <silent> gl :pc<CR>
" }}}

" Buffer switching: {{{
nnoremap <silent> <Tab> :bnext<CR>
nnoremap <silent> <S-Tab> :bprevious<CR>
nnoremap <silent> [q :cnext<CR>
nnoremap <silent> ]q :cprev<CR>
nnoremap <leader>. :Bs<space>
" }}}

" Pairs: {{{
    imap <F11> <Plug>(PearTreeExpand)
" }}}

" Splits: {{{
nnoremap <silent> sp :vsplit<CR>
nnoremap <silent> sv :split<CR>
" }}}

" Files: {{{
nnoremap <silent><F3> :Vex<CR>
nnoremap <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
augroup FileNav
  autocmd!
  autocmd FileType dirvish nnoremap <buffer> <silent>D :call tools#DeleteFile()<CR>
  autocmd FileType dirvish nnoremap <buffer> n :e %/
  autocmd FileType dirvish nnoremap <buffer> r :call tools#RenameFile()<CR>
augroup END
" }}}

" Search: {{{
nnoremap S :%s//g<LEFT><LEFT>
vmap s :s//g<LEFT><LEFT>
nnoremap sb :g//#<Left><Left>
nnoremap g_ :g//#<Left><Left><C-R><C-W><CR>:
nnoremap <Leader>sp :SearchProject<space>
nnoremap <silent><Leader>gab :SearchBuffers<CR>
nnoremap <silent><Leader>lt :call tools#ListTags()<CR>
nnoremap ts :ts<space>
nnoremap gh :call tools#ShowDeclaration(0)<CR>
nnoremap sD :call tools#ShowDeclaration(1)<CR>
nnoremap <silent>sd :call tools#PreviewWord()<CR>
nnoremap , :find<space>
cnoremap <expr> <CR> tools#CCR()

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
vnoremap <silent><leader>g :<C-U>call tools#HighlightRegion('Green')<CR>
vnoremap <silent><leader>G :<C-U>call tools#UnHighlightRegion()<CR>
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
nnoremap ' `

function! OpenTerminalDrawer() abort
  execute 'copen'
  execute 'term'
endfunction

nnoremap <silent><Leader>d :call OpenTerminalDrawer()<CR>i
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
