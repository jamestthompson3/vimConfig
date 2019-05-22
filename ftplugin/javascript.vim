scriptencoding utf-8

if !exists('g:loaded_js_config')
  packadd vim-better-javascript-completion
  packadd ultisnips
  packadd Colorizer
  packadd vim-nodejs-errorformat
  let g:loaded_js_config = 1
endif

let g:mucomplete#chains.javascript = ['omni','keyn', 'keyp', 'c-p', 'c-n', 'tags', 'file','path', 'ulti']
let g:mucomplete#chains['javascript.jsx'] = ['omni','keyn', 'keyp', 'c-p', 'c-n', 'tags', 'file','path', 'ulti']

" Syntax: {{{
let g:jsx_ext_required = 0
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
let g:javascript_plugin_flow = 1
let g:vim_json_syntax_conceal = 0
" }}}

" ALE: {{{
let b:ale_linters = ['eslint']
let b:ale_fixers = ['prettier']
" }}}

" Misc: {{{
let g:vimjs#casesensistive = 0
let g:vimjs#smartcomplete = 1
let g:vimjs#chromeapis = 1
let g:vimjs#reactapis = 1
" peek references
nnoremap <silent>K :call tools#ListTags()<CR>

setlocal suffixesadd+=.js,.jsx,.ts,.tsx " navigate to imported files by adding the js(x) suffix
setlocal include=^\\s*[^\/]\\+\\(from\\\|require(['\"]\\) " allows to jump to files declared with import { someThing } from 'someFile'
setlocal define=class\\s
setlocal foldmethod=syntax
setlocal foldlevelstart=99
setlocal foldlevel=99
setlocal omnifunc=javascriptcomplete#CompleteJS
" setlocal equalprg=prettier
syntax match jsOperator "<=" conceal cchar=≤
syntax match jsOperator ">=" conceal cchar=≥
syntax match jsOperator "!==" conceal cchar=≢
syntax match jsArrowFunction /=>/ conceal cchar=⇒
let &makeprg='node %'

" Error: bar
"     at Object.foo [as _onTimeout] (/Users/Felix/.vim/bundle/vim-nodejs-errorformat/test.js:2:9)
let &errorformat  = '%AError: %m' . ','
let &errorformat .= '%AEvalError: %m' . ','
let &errorformat .= '%ARangeError: %m' . ','
let &errorformat .= '%AReferenceError: %m' . ','
let &errorformat .= '%ASyntaxError: %m' . ','
let &errorformat .= '%ATypeError: %m' . ','
let &errorformat .= '%Z%*[\ ]at\ %f:%l:%c' . ','
let &errorformat .= '%Z%*[\ ]%m (%f:%l:%c)' . ','

"     at Object.foo [as _onTimeout] (.vim/bundle/vim-nodejs-errorformat/test.js:2:9)
let &errorformat .= '%*[\ ]%m (%f:%l:%c)' . ','

"     at node.js:903:3
let &errorformat .= '%*[\ ]at\ %f:%l:%c' . ','

" .vim/bundle/vim-nodejs-errorformat/test.js:2
"   throw new Error('bar');
"         ^
let &errorformat .= '%Z%p^,%A%f:%l,%C%m' . ','

" Ignore everything else
let &errorformat .= '%-G%.%#'

function! HookCoreFilesIntoQuickfixWindow()
   let files = getqflist()
   for i in files
      let filename = bufname(i.bufnr)

      " Non-existing file in the quickfix list, assume a core file
      if !filereadable(filename)
        " Open a new split / buffer for loading this core file
        execute 'split ' filename
        " Make this buffer modifiable
        set modifiable
        " Set the buffer options
        setlocal buftype=nofile bufhidden=hide
        " Clear all previous buffer contents
        execute ':1,%d'
        " Load the node.js core file (thanks @izs for pointing this out!)
        silent! execute 'read !node -e "console.log(process.binding(\"natives\").' expand('%:r') ')"'
        " Delete the first line, always empty for some reason
        execute ':1d'
        " Tell vim to treat this buffer as a JS file
        set filetype=javascript
        " No point in making this file writable
        setlocal nomodifiable
        " Point our quickfix entry to this (our current) buffer
        let i.bufnr = bufnr("%")
        " Close the split, so our little hack stays in the background
        close
      endif
   endfor
   call setqflist(files)
endfunction

au QuickfixCmdPost make call HookCoreFilesIntoQuickfixWindow()
" }}}

