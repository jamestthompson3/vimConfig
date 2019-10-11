augroup filetypedetect
  au BufReadPost *.fugitiveblame setfiletype fugitiveblame
  au BufRead,BufNewFile *.nginx set ft=nginx
  au BufRead,BufNewFile nginx*.conf set ft=nginx
  au BufRead,BufNewFile *nginx.conf set ft=nginx
  au BufRead,BufNewFile */etc/nginx/* set ft=nginx
  au BufRead,BufNewFile */usr/local/nginx/conf/* set ft=nginx
  au BufRead,BufNewFile */nginx/*.conf set ft=nginx
  au BufNewFile,BufRead *.bat,*.sys setfiletype dosbatch
  au BufNewFile,BufRead *.mm,*.m setfiletype objc
  au BufNewFile,BufRead *.h,*.m,*.mm set tags+=~/global-objc-tags
  au BufNewFile,BufRead *.tsx setlocal commentstring=//%s
  au BufNewFile,BufRead *.svelte setfiletype html
  au BufNewFile,BufRead *.eslintrc,*.babelrc,*.prettierrc,*.huskyrc setfiletype json
  au BufNewFile,BufRead *.pcss setfiletype css
  au BufNewFile,BufRead *.wiki setfiletype wiki
augroup end
