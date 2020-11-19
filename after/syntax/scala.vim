"=============================================================================
" What Is This: Add some conceal operator for your scala files
" File:         scala.vim (conceal enhancement)
" Author:       Michael Pollmeier <conceal@michaelpollmeier.com>
" Last Change:  2013-11-09
" Version:      1.0.0
" Require:
"   set nocompatible
"     somewhere on your .vimrc
"
"   Vim 7.3 or Vim compiled with conceal patch.
"   Use --with-features=big or huge in order to compile it in.
"
" Usage:
"   Drop this file in your
"       ~/.vim/after/syntax folder (Linux/MacOSX/BSD...)
"       ~/vimfiles/after/syntax folder (Windows)
"
"   For this script to work, you have to set the encoding
"   to utf-8 :set enc=utf-8
"
" Additional:
"     * This plug-in is very much inspired by Vincent Berthoux's http://github.com/Twinside/vim-haskellConceal
"     * if you want to avoid the loading, add the following
"       line in your .vimrc :
"        let g:no_scala_conceal = 1
"
if exists('g:no_scala_conceal') || !has('conceal') || &enc != 'utf-8'
    finish
endif

syntax match scalaNiceOperator "<-" conceal cchar=←
syntax match scalaNiceOperator "->" conceal cchar=→
syntax match scalaNiceOperator "==" conceal cchar=≟
syntax match scalaNiceOperator "===" conceal cchar=≡
syntax match scalaNiceOperator "!=" conceal cchar=≠
syntax match scalaNiceOperator "=/=" conceal cchar=≢
syntax match scalaNiceOperator ">>" conceal cchar=»
syntax match scalaNiceOperator "&&" conceal cchar=∧
syntax match scalaNiceOperator "||" conceal cchar=∨

let s:extraConceal = 1
" Some windows font don't support some of the characters,
" so if they are the main font, we don't load them :)
if has("win32")
    let s:incompleteFont = [ 'Consolas'
                        \ , 'Lucida Console'
                        \ , 'Courier New'
                        \ ]
    let s:mainfont = substitute( &guifont, '^\([^:,]\+\).*', '\1', '')
    for s:fontName in s:incompleteFont
        if s:mainfont ==? s:fontName
            let s:extraConceal = 0
            break
        endif
    endfor
endif

if s:extraConceal
    " Match greater than and lower than w/o messing with Kleisli composition
    syntax match scalaNiceOperator "<=\ze[^<]" conceal cchar=≤
    syntax match scalaNiceOperator ">=\ze[^>]" conceal cchar=≥

    syntax match scalaNiceOperator "=>" conceal cchar=⇒
    syntax match scalaNiceOperator "=\zs<<" conceal cchar=«

    " Redfining to get proper '::' concealing
    syntax match hs_DeclareFunction /^[a-z_(]\S*\(\s\|\n\)*::/me=e-2 nextgroup=scalaNiceOperator contains=hs_FunctionName,hs_OpFunctionName
    syntax match scalaNiceOperator "\:\:" conceal cchar=∷

    syntax match scalaNiceOperator "++" conceal cchar=⧺
    syntax match scalaNiceOperator "forall" conceal cchar=∀

    "syntax match scalaNiceOperator /\s\.\s/ms=s+1,me=e-1 conceal cchar=∘
    syntax match scalaNiceOperator "map\ze[ ({]" conceal cchar=∘
    syntax match scalaNiceOperator "flatMap\ze[ ({]" conceal cchar=⤜

    syntax match scalaNiceOperator "exists" conceal cchar=∈
endif

hi link scalaNiceOperator Operator
hi! link Conceal Operator
setlocal conceallevel=2
