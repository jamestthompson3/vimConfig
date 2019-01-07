scriptencoding utf-8
"                ╔══════════════════════════════════════════╗
"                ║                 » BASICS «               ║
"                ╚══════════════════════════════════════════╝
if !has('nvim')
  set renderoptions=type:directx,gamma:1.0,contrast:0.5,level:1,geom:1,renmode:4,taamode:1
  set background=dark
endif

set termguicolors
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
set listchars=
set listchars+=tab:░\
set listchars+=trail:·
set listchars+=space:·
set listchars+=extends:»
set listchars+=precedes:«
set listchars+=nbsp:⣿

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

if g:isWindows
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
  if l:modecurrent == 'i' && exists('g:mucomplete_current_method')
   return g:mucomplete_current_method
   else
     return ''
  endif
endfunction

function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:warning = l:counts.warning
    let l:error = l:counts.error
    if l:all_errors + l:counts.warning == 0
     return '✓'
    else
      return printf(
    \   '%d ⚠ %d ☓',
    \   l:warning,
    \   l:error
    \) . ' '
  endif
endfunction

let g:currentmode={ 'V' : 'V·Line ', 'i' : '[+]', 'R': 'Replace' }

function! ModeCurrent() abort
    let l:modecurrent = mode()
    if l:modecurrent == '^V'
      return 'V Block'
    else
      let l:modelist = toupper(get(g:currentmode, l:modecurrent, ''))
      return l:modelist
    endif
endfunction

function! Get_gutentags_status(mods) abort
  let l:msg = ''
    if index(a:mods, 'ctags') >= 0
      let l:msg .= '♨'
    endif
    if index(a:mods, 'cscope') >= 0
      let l:msg .= '♺'
    endif
  return l:msg
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

set laststatus=2
set statusline=
set statusline+=%<
set statusline+=%f
set statusline+=\ %{FileType()}
set statusline+=\ %{ModeCurrent()}
set statusline+=\ ⟫\ \ %{fugitive#head()}
set statusline+=%=
set statusline+=%{gutentags#statusline_cb(funcref('Get_gutentags_status'))}
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
    " au InsertEnter *  hi! link StatusLine Statement
    " au InsertLeave * hi! link StatusLine Constant
augroup END

"                ╔══════════════════════════════════════════╗
"                ║                » PLUGINS «               ║
"                ╚══════════════════════════════════════════╝
"
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:webdevicons_enable = 1

