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


" Window/Buffer Motions:
nnoremap <silent><C-J> :call WinMove('j')<cr>
nnoremap <silent><C-L> :call WinMove('l')<cr>
nnoremap <silent><C-H> :call WinMove('h')<cr>
nnoremap <silent><C-K> :call WinMove('k')<cr>
nnoremap <silent> wq :close<CR>
nnoremap <silent> Q :bp\|bd #<CR>
nnoremap <silent> cc :cclose<CR>
nnoremap <silent> sq :only<CR>
nnoremap <silent> gl :pc<CR>
nnoremap <leader><tab> :bn<CR>
nnoremap <silent>[a :prev<CR>
nnoremap <silent>]a :next<CR>
nnoremap <silent> <c-u> :call tools#smoothScroll(1)<cr>
nnoremap <silent> <c-d> :call tools#smoothScroll(0)<cr>

" Move in given direction or create new split
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
nnoremap <silent> [q :cnext<CR>
nnoremap <silent> ]q :cprev<CR>
nnoremap <silent> [Q :cnfile<CR>
nnoremap <silent> ]Q :cpfile<CR>
nnoremap <leader>. :Bs<space>
nnoremap <silent><leader>h :call tools#switchSourceHeader()<CR>
nnoremap <BS> :bp<CR>

" Files:
nnoremap <silent><F3> :Vex<CR>
nnoremap <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <silent><leader>F :call tools#simpleMru()<CR>
augroup FileNav
  autocmd!
  autocmd FileType dirvish nnoremap <buffer> <silent>D :call tools#DeleteFile()<CR>
  autocmd FileType dirvish nnoremap <buffer> n :e %
  autocmd FileType dirvish nnoremap <buffer> r :call tools#RenameFile()<CR>
  autocmd FileType netrw nnoremap <buffer> q :close<CR>
augroup END

augroup ECMA
  autocmd!
  autocmd FileType typescript,typescript.tsx,typescriptreact,javascript,javascript.jsx inoremap <C-l> console.log()<esc>i
  autocmd FileType typescript,typescript.tsx,typescriptreact,javascript,javascript.jsx inoremap <C-c> console.log(`%c${}`, 'color: ;')<esc>F{a
  autocmd FileType typescript,typescript.tsx,typescriptreact,javascript,javascript.jsx inoremap d<C-l> debugger
  autocmd FileType typescript,typescript.tsx,typescriptreact,javascript,javascript.jsx nnoremap <leader>i biimport {<esc>ea} from ''<esc>i
augroup END

augroup RUST
autocmd!
autocmd FileType rust inoremap <C-l> println!("{}",)<esc>i
augroup END
" Search and replace:
nnoremap S :%s//g<LEFT><LEFT>
vmap s :s//g<LEFT><LEFT>
nnoremap / ms/
nnoremap sb :g//#<Left><Left>
nnoremap g_ :g//#<Left><Left><C-R><C-W><CR>:
nnoremap <Leader>sp :SearchProject<space>
nnoremap <silent><Leader>gab :SearchBuffers<CR>
nnoremap <silent><Leader>lt :call symbols#ListTags()<CR>
nnoremap ts :ts<space>/
nnoremap <C-]> g<C-]>
nnoremap gh :call symbols#ShowDeclaration(0)<CR>
nnoremap ]] :ijump <C-R><C-W><CR>
nnoremap <silent>sd :call symbols#PreviewWord()<CR>
nnoremap , :find<space>
cnoremap <expr> <CR> tools#CCR()
nnoremap gX :DD<CR>

function! HLNext (blinktime) abort
  let target_pat = '\c\%#'.@/
  let ring = matchadd('ErrorMsg', target_pat, 101)
  redraw
  exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
  call matchdelete(ring)
  redraw
endfunction

augroup searching
  autocmd BufReadPost quickfix nnoremap <buffer><silent>ra :ReplaceAll<CR>
  autocmd BufReadPost quickfix nnoremap <buffer>rq :ReplaceQF
  autocmd BufReadPost quickfix nnoremap <buffer>R  :Cfilter!<space>
  autocmd BufReadPost quickfix nnoremap <buffer>K  :Cfilter<space>
augroup END


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

" Git:
nnoremap <Leader>b :Gblame<CR>
nnoremap <silent><Leader>B :call git#blame()<CR>
xnoremap <Leader>b :Gblame<CR>

" ALE:
nnoremap <silent> <Leader>jj :ALENext<CR>
nnoremap <silent> <Leader>kk :ALEPrevious<CR>

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

" Misc:
nnoremap ; :
nnoremap : ;
nnoremap 0 ^
nnoremap mks :mks! ~/sessions/
nnoremap ss :so ~/sessions/
nnoremap ssb :call sessions#sourceSession()<CR>
nnoremap ' `
nnoremap M :silent make<CR>
nnoremap Y y$

function! OpenTerminalDrawer() abort
  execute 'copen'
  execute 'term'
endfunction

nnoremap <silent><Leader>d :call OpenTerminalDrawer()<CR>i
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
nnoremap <silent><F5> :so $MYVIMRC<CR>
nnoremap <silent><F7> :so %<CR>
nnoremap <silent><F1> :call Profiler()<CR>

