scriptencoding = utf-8

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
nnoremap <silent><leader>h :call tools#switchSourceHeader()<CR>
" Files:
nnoremap <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Search and replace:
cnoremap <expr> <CR> tools#CCR()
nnoremap <silent><leader>l :lua vim.lsp.util.show_line_diagnostics()<CR>

function! HLNext (blinktime) abort
  let target_pat = '\c\%#'.@/
  let ring = matchadd('ErrorMsg', target_pat, 101)
  redraw
  exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
  call matchdelete(ring)
  redraw
endfunction

"Cscope
" nnoremap <leader>f :silent! cs find 0 <C-R>=expand("<cword>")<CR><CR>

" Blocks:
vnoremap <silent><up>    :m '<-2<cr>gv=gv
vnoremap <silent><down>  :m '>+1<cr>gv=gv
nnoremap <silent><up>    :m .-2<cr>==
nnoremap <silent><down>  :m .+1<cr>==
xnoremap <expr> I (mode()=~#'[vV]'?'<C-v>^o^I':'I')
xnoremap <expr> A (mode()=~#'[vV]'?'<C-v>0o$A':'A')

" Completion:
" function! s:checkBackspace() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1] =~ '\s'
" endfunction
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
" inoremap <silent><expr> <TAB> pumvisible() ? '\<C-n>' : <SID>checkBackspace() ? '\<Tab>' : completion#trigger_completion()

nnoremap z/ :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>

" VimDev:
nnoremap <C-F> :echo 'hi<' . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

