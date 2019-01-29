iabbrev cosnt const
iabbrev imoprt import
iabbrev iomprt import
iabbrev improt import


inoremap `<CR>       `<CR>`<esc>O<tab>
setlocal suffixesadd+=.js,.jsx,.ts,.tsx " navigate to imported files by adding the js(x) suffix
setlocal include=^\\s*[^\/]\\+\\(from\\\|require(['\"]\\) " allows to jump to files declared with import { someThing } from 'someFile'
setlocal define=class\\s
setlocal foldmethod=syntax
setlocal foldlevelstart=99
setlocal foldlevel=2
