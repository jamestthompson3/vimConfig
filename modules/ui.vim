scriptencoding utf-8
if !has('nvim')
set renderoptions=type:directx,gamma:1.0,contrast:0.5,level:1,geom:1,renmode:4,taamode:1
endif
let g:enable_italic_font = 1
let g:enable_bold_font = 1
let g:enable_guicolors = 1
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1


if has('win16') || has('win32') || has('win64')
  set guifont=Iosevka:h10:cANSI:qDRAFT
elseif has('Mac')
  set guifont=Iosevka\ Term\ Nerd\ Font\ Complete:h11
else
  set guifont=Iosevka\ 10
endif

set termguicolors
set background=dark
set number
set nowrap
set noshowmode
colorscheme falcon
let g:Lf_StlColorscheme = 'hybrid_reverse'
:set guioptions-=m  "remove menu bar
:set guioptions-=T  "remove toolbar
:set guioptions-=r  "remove right-hand scroll bar
:set guioptions-=L  "remove left-hand scroll bar

" limit completion menu height
set pumheight=15
set scrolloff=1
set sidescrolloff=5
set display+=lastline
set incsearch
set hlsearch
set hidden
set ttimeout
" airline
let g:airline#extensions#branch#enabled = 1
let g:falcon_airline = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline_theme = 'falcon'
let g:airline_powerline_fonts = 1
let g:airline_section_b = '%{fugitive#head()}'
let g:airline_section_z = ''
let g:airline_section_y = ''
if !exists('g:airline_symbols')
   let g:airline_symbols = {}
endif

" unicode symbols
" let g:airline_left_sep = '»'
" let g:airline_left_sep = '▶'
" let g:airline_right_sep = '«'
" let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
" let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.maxlinenr = '㏑'
let g:airline_symbols.branch = '🎋'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = 'Ɇ'
let g:airline_symbols.whitespace = 'Ξ'
let g:webdevicons_enable = 1

" function! FileSize() abort
"     let l:bytes = getfsize(expand('%p'))
"     if (l:bytes >= 1024)
"         let l:kbytes = l:bytes / 1025
"     endif
"     if (exists('kbytes') && l:kbytes >= 1000)
"         let l:mbytes = l:kbytes / 1000
"     endif

"     if l:bytes <= 0
"         return '0'
"     endif

"     if (exists('mbytes'))
"         return l:mbytes . 'MB '
"     elseif (exists('kbytes'))
"         return l:kbytes . 'KB '
"     else
"         return l:bytes . 'B '
"     endif
" endfunction

" function! LinterStatus() abort
"     let l:counts = ale#statusline#Count(bufnr(''))

"     let l:all_errors = l:counts.error + l:counts.style_error
"     let l:all_non_errors = l:counts.total - l:all_errors
"     if l:counts.total == 0
"       hi User3 guifg=#b2b2b2 guibg=#000000 gui=BOLD
"       return '👌'
"     else
"       hi User3 guifg=#c9505c guibg=#191f26 gui=BOLD
"     return printf(
"     \   '%dW %dE',
"     \   l:all_non_errors,
"     \   l:all_errors
"     \)
"   endif
" endfunction

" function! ReadOnly() abort
"   if &readonly || !&modifiable
"     hi User3 guifg=#c9505c guibg=#191f26 gui=BOLD
"     return ''
"   else
"     return ''
"   endif
" endfunction

" set noshowmode
" set laststatus=2
" set statusline=
" set statusline+=\%#keyword#\%m
" set statusline+=%1*\ ‹‹
" set statusline+=%1*\ %F\ %*
" set statusline+=%1*\ ››
" set statusline+=%1*\ \ %{fugitive#head()}
" set statusline+=%=
" set statusline+=%3*\ ‹‹
" set statusline+=%1*\ %{FileSize()}
" set statusline+=%3*\ %{ReadOnly()}
" set statusline+=%3*\ %{LinterStatus()}
" set statusline+=%3*\ ››\ %*

" function! CheckStatus() abort
"   let curr = winnr()
"   for n in range(1, winnr('$'))
"     if n == winnr()
"      hi User1 guifg=#FFFFFF guibg=#000000
"    else
"       hi User1 guifg=#b2b2b2 guibg=#000000 gui=BOLD
"     endif
"   endfor
" endfunction

" augroup statusline
" au InsertEnter *  hi User1 guibg=#191f26 guifg=#ffc552 gui=BOLD
" au InsertLeave * hi User1 guifg=#FFFFFF guibg=#000000
" au WinLeave, BufWinLeave * call CheckStatus()
" augroup END


