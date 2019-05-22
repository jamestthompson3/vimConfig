scriptencoding utf-8

" Basics: {{{
" Turn off column numbers if the window is inactive
augroup WINDOWS
  autocmd!
  autocmd WinEnter * set number
  autocmd WinLeave * set nonumber
augroup END

set termguicolors
set nowrap
set cursorline
set number
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
set pumheight=15   "limit completion menu height
set scrolloff=1 "minimal number of screen lines to keep above and below the cursor.
set sidescrolloff=5 "same, but with columns
set display+=lastline
set listchars= " list chars for showing indentation
set listchars+=tab:░\
set listchars+=trail:·
set listchars+=space:·
set listchars+=extends:»
set listchars+=precedes:«
set listchars+=nbsp:⣿
set guicursor+=n:blinkwait60-blinkon175-blinkoff175

" }}}

" Colors: {{{
function! MyHighlights() abort
  " Custom higlight groups
  hi Callout guifg=#198cff
  hi! link NormalNC Comment
  hi! link TabLineFill Normal
  hi! link TabLine StatusLine
  hi! link Whitespace Comment
  hi! link StatusLine Normal
  hi! link MyTodo Todo
  hi IncSearch guifg=#d81a4c
endfunction

function! s:myTodo()
  syn match Todo '@\?\(todo\|fixme\):\?' containedin=.*Comment,vimCommentTitle contained
  hi link MyTodo Todo
endfunction


augroup Colors
  autocmd!
  autocmd ColorScheme * call MyHighlights()
  autocmd Syntax * call s:myTodo()
augroup END

colorscheme monotone
" }}}

" Statusline: {{{
set statusline+=%#StatusLineModified#%{&mod?statusline#FileType():''}%*%{&mod?'':statusline#FileType()}
set statusline+=\ %c
set statusline+=%=
set statusline+=%<
" set statusline+=%{statusline#GetScope()}
set statusline+=%=
set statusline+=\ %{statusline#ReadOnly()}
set statusline+=\ %{statusline#LinterStatus()}%*
"}}}

" Tabline: {{{
set showtabline=2
set tabline=ᚴ\ %{git#branch()}
" }}}


