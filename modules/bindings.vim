scriptencoding = utf-8

let g:mapleader = "\<Space>"
imap jj <Esc>

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

function! WinMove(key) abort
  let t:curwin = winnr()
  exec "wincmd ".a:key
  if (t:curwin == winnr())
    if (match(a:key,'[jk]'))
      wincmd v
    else
      wincmd s
    endif
    exec "wincmd ".a:key
  endif
endfunction

" Buffer Switching:
nnoremap <leader>. :Bs<space>
nnoremap <silent><leader>h :call tools#switchSourceHeader()<CR>
nnoremap <BS> :bp<CR>

" Files:
nnoremap <silent><F3> :Vex<CR>
nnoremap <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <silent><leader>F :call tools#simpleMru()<CR>

" Search and replace:
nnoremap / ms/
nnoremap <Leader>sp :SearchProject<space>
nnoremap <silent><Leader>gab :SearchBuffers<CR>
nnoremap <C-]> g<C-]>
nnoremap gh :call symbols#ShowDeclaration(0)<CR>
nnoremap ]] :ijump <C-R><C-W><CR>
nnoremap <silent>sd :call symbols#PreviewWord()<CR>
nnoremap , :find<space>
cnoremap <expr> <CR> tools#CCR()
nnoremap gX :DD<CR>
nnoremap <silent><leader>l :lua vim.lsp.util.show_line_diagnostics()<CR>
nnoremap S :%s//g<LEFT><LEFT>
vmap s :s//g<LEFT><LEFT>

function! HLNext (blinktime) abort
  let target_pat = '\c\%#'.@/
  let ring = matchadd('ErrorMsg', target_pat, 101)
  redraw
  exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
  call matchdelete(ring)
  redraw
endfunction

"Cscope
nnoremap <leader>f :silent! cs find 0 <C-R>=expand("<cword>")<CR><CR>
vnoremap <silent> g<c-\> :<C-U>
      \:let old_reg=getreg('"')<bar>
      \:let old_regmode=getregtype('"')<cr>
      \gvy
      \:silent! cs find s <C-R>=@"<cr><cr>
      \:call setreg('"', old_reg, old_regmode)<cr>:cwindow<CR>
" Find functions call this word (3==c)
nnoremap g<C-]> :silent! cs find c <C-R>=expand("<cword>")<CR><CR>:cwindow<CR>
vnoremap <silent> g<c-]> :<C-U>
      \:let old_reg=getreg('"')<bar>
      \:let old_regmode=getregtype('"')<cr>
      \gvy
      \:silent! cs find c <C-R>=@"<cr><cr>
      \:call setreg('"', old_reg, old_regmode)<cr>:cwindow<CR>
" Find this definition (1==g)
nnoremap g<C-g> :silent! cs find g <C-R>=expand("<cword>")<CR><CR>:cwindow<CR>
vnoremap <silent> g<c-g> :<C-U>
      \:let old_reg=getreg('"')<bar>
      \:let old_regmode=getregtype('"')<cr>
      \gvy
      \:silent! cs find g <C-R>=@"<cr><cr>
      \:call setreg('"', old_reg, old_regmode)<cr>:cwindow<CR>


" Blocks:
vnoremap <silent><up>    :m '<-2<cr>gv=gv
vnoremap <silent><down>  :m '>+1<cr>gv=gv
nnoremap <silent><up>    :m .-2<cr>==
nnoremap <silent><down>  :m .+1<cr>==
vnoremap <silent><leader>g :<C-U>call tools#HighlightRegion('Green')<CR>
vnoremap <silent><leader>G :<C-U>call tools#UnHighlightRegion()<CR>
xnoremap <expr> I (mode()=~#'[vV]'?'<C-v>^o^I':'I')
xnoremap <expr> A (mode()=~#'[vV]'?'<C-v>0o$A':'A')

" Completion:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"

function! OpenTerminalDrawer(floating) abort
  if a:floating
    execute 'lua NavigationFloatingWin()'
  else
    execute 'copen'
  endif
  execute 'term'
endfunction

nnoremap <silent><Leader>d :call OpenTerminalDrawer(1)<CR>i
nnoremap <silent><Leader>D :call OpenTerminalDrawer(0)<CR>i
nnoremap z/ :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>

" VimDev:
function! s:Profiler() abort
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

