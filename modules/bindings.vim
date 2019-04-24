scriptencoding = utf-8

let g:mapleader = "\<Space>"
imap jj <Esc>

" Escape from terminal mode
if exists(':tnoremap')
 tnoremap <C-\> <C-\><C-n>
endif


" System Clipboard:
xnoremap <Leader>y "+y
xnoremap <Leader>d "+d
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
" Don't trash current register when pasting in visual mode
xnoremap <silent> p p:if v:register == '"'<Bar>let @@=@0<Bar>endif<cr>


" Window Motions:
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <silent> wq :close<CR>
nnoremap <silent> Q :bp\|bd #<CR>
nnoremap <silent> cc :cclose<CR>
nnoremap <silent> sq :only<CR>
nnoremap <silent> gl :pc<CR>
nnoremap <silent> <c-u> :call tools#smoothScroll(1)<cr>
nnoremap <silent> <c-d> :call tools#smoothScroll(0)<cr>

" Buffer Switching:
nnoremap <silent> [q :cnext<CR>
nnoremap <silent> ]q :cprev<CR>
nnoremap <silent> [Q :cnfile<CR>
nnoremap <silent> ]Q :cpfile<CR>
nnoremap <leader>. :Bs<space>
nnoremap <silent><leader>h :call tools#switchSourceHeader()<CR>

" Splits:
nnoremap <silent> sp :vsplit<CR>
nnoremap <silent> sv :split<CR>


" Files:
nnoremap <silent><F3> :Vex<CR>
nnoremap <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
augroup FileNav
  autocmd!
  autocmd FileType dirvish nnoremap <buffer> <silent>D :call tools#DeleteFile()<CR>
  autocmd FileType dirvish nnoremap <buffer> n :e %/
  autocmd FileType dirvish nnoremap <buffer> r :call tools#RenameFile()<CR>
augroup END


" Search:
nnoremap S :%s//g<LEFT><LEFT>
vmap s :s//g<LEFT><LEFT>
nnoremap sb :g//#<Left><Left>
nnoremap g_ :g//#<Left><Left><C-R><C-W><CR>:
nnoremap <Leader>sp :SearchProject<space>
nnoremap <silent><Leader>gab :SearchBuffers<CR>
nnoremap <silent><Leader>lt :call symbols#ListTags()<CR>
nnoremap ts :ts<space>/
nnoremap gh :call symbols#ShowDeclaration(0)<CR>
nnoremap <silent>sd :call symbols#PreviewWord()<CR>
nnoremap , :find<space>
cnoremap <expr> <CR> tools#CCR()
nnoremap gX :DD<CR>
nnoremap <Leader>f :Vista finder<CR>

augroup searching
  autocmd BufReadPost quickfix nnoremap <buffer><silent>ra :ReplaceAll<CR>
  autocmd BufReadPost quickfix nnoremap <buffer>rq :ReplaceQF
augroup END


" Git:
nnoremap <Leader>b :Gblame<CR>
nnoremap <silent><Leader>B :call git#blame()<CR>
xnoremap <Leader>b :Gblame<CR>

" ALE:
nnoremap <silent> <Leader>jj :ALENext<CR>
nnoremap <silent> <Leader>kk :ALEPrevious<CR>

" Blocks:
xmap <up>    <Plug>SchleppUp
xmap <down>  <Plug>SchleppDown
xmap <left>  <Plug>SchleppLeft
xmap <right> <Plug>SchleppRight
vnoremap <silent><leader>g :<C-U>call tools#HighlightRegion('Green')<CR>
vnoremap <silent><leader>G :<C-U>call tools#UnHighlightRegion()<CR>

" Completion:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"

" Misc:
nnoremap ; :
nnoremap : ;
nnoremap mks :mks! ~/sessions/
nnoremap ss :so ~/sessions/
nnoremap ssb :call sessions#sourceSession()<CR>
nnoremap ' `
inoremap<F11> <Plug>(PearTreeExpand)

function! OpenTerminalDrawer() abort
  execute 'copen'
  execute 'term'
endfunction

nnoremap <silent><Leader>d :call OpenTerminalDrawer()<CR>i
nnoremap <Leader>t :Tagbar<CR>
nnoremap z/ :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>

" VimDev:
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
nnoremap <C-F> :echo 'hi<' . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
nnoremap <silent><F5> :so $MYVIMRC<CR>
nnoremap <silent><F7> :so %<CR>
nnoremap <silent><F1> :call Profiler()<CR>

