let g:enable_italic_font = 1
let g:enable_bold_font = 1
let g:enable_guicolors = 1
set guifont=Fira_Code_Retina:h10:cANSI:qDRAFT
" set vb t_vb=
let g:Lf_StlColorscheme = "hybrid"
set background=dark
colorscheme hybrid_reverse
let g:airline_theme = "hybrid"
let g:airline_powerline_fonts = 1
let g:webdevicons_enable = 1
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
set wildignorecase
set mouse=nv
set hidden
set ttimeout
