function! s:cmd(cmd, ...) abort
  let l:opt = get(a:000, 0, {})
  if !has_key(l:opt, 'cwd')
    let l:opt['cwd'] = fnameescape(expand('%:p:h'))
  endif
  let l:cmd = join(map(a:cmd, 'v:val !~# "\\v^[%#<]" || expand(v:val) == "" ? v:val : shellescape(expand(v:val))'))
  execute get(l:opt, 'pos', 'botright') 'new'
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  nnoremap <buffer> q <c-w>c
  execute 'lcd' l:opt['cwd']
  execute '%!' l:cmd
endfunction

function! s:git(args, where) abort
  call s:cmd(['git'] + a:args, {'pos': a:where})
setlocal nomodifiable
endfunction


function! git#diff() abort
  let l:ft = getbufvar('%', '&ft') " Get the file type
  let l:fn = expand('%:t')
  call s:git(['show', 'HEAD:./'.l:fn], 'rightbelow vertical')
  let &l:filetype = l:ft
  execute 'silent file' l:fn '[HEAD]'
  diffthis
  autocmd BufWinLeave <buffer> diffoff!
  wincmd p
  diffthis
endfunction

function! git#threeWayDiff() abort
  let l:ft = getbufvar('%', '&ft') " Get the file type
  let l:fn = expand('%:t')
  " Show the version from the current branch on the left
  call s:git(['show', ':2:./'.l:fn], 'leftabove vertical')
  let &l:filetype = l:ft
  execute 'silent file' l:fn '[OURS]'
  diffthis
  autocmd BufWinLeave <buffer> diffoff!
  wincmd p
  " Show version from the other branch on the right
  call s:git(['show', ':3:./'.l:fn], 'rightbelow vertical')
  let &l:filetype = l:ft
  execute 'silent file' l:fn '[OTHER]'
  diffthis
  autocmd BufWinLeave <buffer> diffoff!
  wincmd p
  diffthis
endfunction

function! git#branch()
  if g:isWindows
    return trim(system("git rev-parse --abbrev-ref HEAD 2> NUL | tr -d '\n'"))
  else
    return trim(system("git rev-parse --abbrev-ref HEAD 2> /dev/null | tr -d '\n'"))
  endif
endfunction

function! git#stat()
  if g:isWindows
    return trim(system("'git diff --shortstat 2> NUL | tr -d '\n'"))
  else
    return trim(system("git diff --shortstat 2> /dev/null | tr -d '\n'"))
  endif
endfunction

function! git#manage() abort
  execute 'tabnew'
  execute 'term lazygit'
endfunction

