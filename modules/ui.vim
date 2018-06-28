scriptencoding utf-8
if !has('nvim')
set renderoptions=type:directx,gamma:1.0,contrast:0.5,level:1,geom:1,renmode:4,taamode:1
endif
let g:enable_italic_font = 1
let g:enable_bold_font = 1
let g:enable_guicolors = 1

if has('win16') || has('win32') || has('win64')
  set guifont=Iosevka:h10:cANSI:qDRAFT
elseif has('Mac')
  set guifont=Iosevka\ Term\ Nerd\ Font\ Complete:h11
elseif has('nvim')
  GuiFont Iosevka
else
  set guifont=Iosevka\ 10
endif

" set vb t_vb=
set background=dark
set number
set nowrap
set noshowmode
colorscheme hybrid_reverse
let g:Lf_StlColorscheme = 'hybrid_reverse'
:set guioptions-=m  "remove menu bar
:set guioptions-=T  "remove toolbar
:set guioptions-=r  "remove right-hand scroll bar
:set guioptions-=L  "remove left-hand scroll bar
"menuone: show the pupmenu when only one match
  " disable preview scratch window,
set completeopt=menu,menuone,longest
" h: 'complete'
set complete=.,w,b,u,t
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
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'hybrid'
let g:airline_powerline_fonts = 1
let g:airline_section_b = '%{fugitive#head()}'
let g:airline_section_z = '%{gutentags#statusline()}'
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
