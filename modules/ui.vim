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
set scrolloff=1
set sidescrolloff=5
set display+=lastline
set incsearch
set hlsearch
set ttimeout
hi SpellBad guibg=#ff2929 ctermbg=196

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
let g:currentmode={ 'V' : 'V·Line ', 'i' : '[+]' }


" Function: return current mode
" abort -> function will abort soon as error detected
function! ModeCurrent() abort
    let l:modecurrent = mode()
    " use get() -> fails safely, since ^V doesn't seem to register
    " 3rd arg is used when return of mode() == 0, which is case with ^V
    " thus, ^V fails -> returns 0 -> replaced with 'V Block'
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

set noshowmode
set laststatus=2
set statusline=
set statusline+=%<
set statusline+=%f
set statusline+=%{ModeCurrent()}
set statusline+=\ ⟫\ \ %{fugitive#head()}
set statusline+=%=
set statusline+=%{ReadOnly()}
set statusline+=%{LinterStatus()}

hi! link StatusLine Constant
hi! link StatusLineNC Comment
hi! link BufTabLineFill NonText
hi! link BufTabLineActive Pmenu
hi! link BufTabLineCurrent WildMenu
let g:buftabline_show = 1
let g:buftabline_indicators = 1

augroup statusline
    au!
    au BufEnter help hi! link StatusLine NonText
    au BufLeave help hi! link StatusLine Constant
"   au InsertEnter *  hi! link StatusLine Statement
"   au InsertLeave * hi! link StatusLine Constant
augroup END

