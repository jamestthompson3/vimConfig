set background=dark
let g:colors_name="substrata"

lua require('lush')(require('lush_theme.substrata'))

" ; Vim Interface

" Ignore         base4        none

" ; Syntax

" Error          red          none
" Statement      blue         none

" Delimiter      base6        none
" Function       light_blue   none  italic
" Operator       base6        none
" String         cyan         none
" Typedef        light_pink   none
" Underlined     light_blue   none  underline
" vimOption      light_blue   none

" SpellBad       red          none  undercurl guisp=red
" SpellCap       light_blue   none  undercurl guisp=light_blue
" SpellLocal     pink         none  undercurl guisp=pink
" SpellRare      blue         none  undercurl guisp=blue

" ; Syntax

" Boolean            -> Constant
" Character          -> Constant
" Float              -> Constant
" Number             -> Constant

" StorageClass       -> Statement
" Conditional        -> Statement
" Exception          -> Statement
" Keyword            -> Statement
" Label              -> Statement
" Repeat             -> Statement

" Structure          -> Type
" Typedef            -> Type

" Debug              -> Special
" SpecialChar        -> Special
" Tag                -> Special
