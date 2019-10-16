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
  au BufRead,BufNewFile [Dd]ockerfile set ft=Dockerfile
  au BufRead,BufNewFile Dockerfile* set ft=Dockerfile
  au BufRead,BufNewFile [Dd]ockerfile.vim set ft=vim
  au BufRead,BufNewFile *.dock set ft=Dockerfile
  au BufRead,BufNewFile *.[Dd]ockerfile set ft=Dockerfile
augroup end
