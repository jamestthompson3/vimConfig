scriptencoding utf-8
"                ╔══════════════════════════════════════════╗
"                ║                 » BASICS «               ║
"                ╚══════════════════════════════════════════╝
if !has('nvim')
set renderoptions=type:directx,gamma:1.0,contrast:0.5,level:1,geom:1,renmode:4,taamode:1
endif

set termguicolors
set background=dark
set number
set nowrap
set cursorline
set noshowmode
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
set pumheight=15   "limit completion menu height
set scrolloff=1 "minimal number of screen lines to keep above and below the cursor.
set sidescrolloff=5 "same, but with columns
set display+=lastline
set incsearch
set hlsearch
set ttimeout

" Custom higlight groups
hi SpellBad guibg=#ff2929 ctermbg=196
hi! link BufTabLineFill NonText
hi! link BufTabLineActive Pmenu
hi! link BufTabLineCurrent WildMenu
hi! link BufTabLineHidden Normal

colorscheme tokyo-metro
"                ╔══════════════════════════════════════════╗
"                ║                 » FONTS «                ║
"                ╚══════════════════════════════════════════╝
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

"                ╔══════════════════════════════════════════╗
"                ║              » STATUS LINE «             ║
"                ╚══════════════════════════════════════════╝
"
function! MU() " show current completion method
  let l:modecurrent = mode()
  return l:modecurrent == 'i' ? g:mucomplete_current_method : ''
endfunction

function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    let l:warning = nr2char(0xf420)
    let l:error = nr2char(0xf421)
    if l:counts.total == 0
      return nr2char(0xf05a) . ' '
    else
      return printf(
    \   '%d ⚠ %d ☓',
    \   l:warning,
    \   l:error
    \) . ' '
  endif
endfunction

" Dictionary: take mode() input -> longer notation of current mode
" mode() is defined by Vim
let g:currentmode={ 'V' : 'V·Line ', 'i' : '[+]', 'R': 'Replace' }


" Function: return current mode
" abort -> function will abort soon as error detected
function! ModeCurrent() abort
    let l:modecurrent = mode()
    if l:modecurrent == '^V'
      return 'V Block'
    else
      let l:modelist = toupper(get(g:currentmode, l:modecurrent, ''))
      return l:modelist
    endif
endfunction

function! ReadOnly() abort
  if &readonly || !&modifiable
    hi User3 guifg=#c9505c guibg=#191f26 gui=BOLD
    return ''
  else
    return ''
  endif
endfunction

function! FileType() abort
  let l:currFile = expand('%')
  return WebDevIconsGetFileTypeSymbol(l:currFile, isdirectory(l:currFile))
endfunction

set noshowmode
set laststatus=2
set statusline=
set statusline+=%<
set statusline+=%f
set statusline+=\ %{FileType()}
set statusline+=\ %{ModeCurrent()}
set statusline+=\ ⟫\ \ %{fugitive#head()}
set statusline+=%=
set statusline+=\ %{MU()}
set statusline+=\ %{ReadOnly()}
set statusline+=%{LinterStatus()}

hi! link StatusLine Constant
hi! link StatusLineNC Comment

let g:buftabline_show = 1
let g:buftabline_indicators = 1
let g:buftabline_separators = 1
let g:buftabline_numbers = 2

augroup statusline
    au!
    au BufEnter help hi! link StatusLine NonText
    au BufLeave help hi! link StatusLine Constant
"   au InsertEnter *  hi! link StatusLine Statement
"   au InsertLeave * hi! link StatusLine Constant
augroup END

"                ╔══════════════════════════════════════════╗
"                ║                » PLUGINS «               ║
"                ╚══════════════════════════════════════════╝
"
let g:fzf_colors =
    \ { 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'CursorLine'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:webdevicons_enable = 1

