scriptencoding utf-8

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
set listchars=
set listchars+=tab:░\
set listchars+=trail:·
set listchars+=space:·
set listchars+=extends:»
set listchars+=precedes:«
set listchars+=nbsp:⣿
set guicursor+=n:blinkwait60-blinkon175-blinkoff175



function! MyHighlights() abort
  syntax match ConflictMarker /\(^<<<<<<< \@=\|^=======$\|^>>>>>>> \@=\)/ containedin=ALL
  syntax match MyTodo /todo\|fixme/ containedin=.*Comment,vimCommentTitle contained
  hi link MyTodo Todo
  hi link ConflictMarker Error
  hi Callout guifg=#198cff
  hi! link TabLineFill Normal
  hi! link TabLine StatusLine
  hi! link Whitespace Comment
  hi! link StatusLine Normal
  hi IncSearch guifg=#d81a4c
endfunction

augroup Colors
  autocmd!
  autocmd ColorScheme * call MyHighlights()
augroup END

" Turn off column numbers if the window is inactive
augroup WINDOWS
  autocmd!
  autocmd WinEnter * set number
  autocmd WinLeave * set nonumber
augroup END

colorscheme ghost

set statusline+=%#StatusLineModified#%{&mod?statusline#FileType():''}%*%{&mod?'':statusline#FileType()}
set statusline+=\ %c
set statusline+=%=
set statusline+=%<
set statusline+=%=
set statusline+=\ %{statusline#ReadOnly()}
set statusline+=\ %{statusline#LinterStatus()}%*

set showtabline=2
set tabline=ᚴ\ %{git#branch()}


