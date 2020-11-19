setlocal formatoptions-=t formatoptions+=croqnl
silent! setlocal formatoptions+=j

setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s2:/**,mb:*,ex:*/,s1:/*,mb:*,ex:*/,://
setlocal shiftwidth=2 softtabstop=2 expandtab

setlocal include=^\\s*import
setlocal includeexpr=substitute(v:fname,'\\.','/','g')

setlocal path+=src/main/scala,src/test/scala
setlocal suffixesadd=.scala

" compiler sbt
