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
  normal! <C-W><C-R>
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

function! git#stat()
  if g:isWindows
    return trim(system("'git diff --shortstat 2> NUL | tr -d '\n'"))
  else
    return trim(system("git diff --shortstat 2> /dev/null | tr -d '\n'"))
  endif
endfunction

function! git#blame() abort
  execute ':Redir %Gblame'
  vertical resize 40
  silent! setlocal nomodifiable nonumber
  set filetype=fugitive
  call s:BlameSyntax()
  execute "normal \<c-w>\<c-r>"
endfunction

let s:hash_colors = {}
function! s:BlameSyntax() abort
  let b:current_syntax = 'fugitiveblame'
  let conceal = has('conceal') ? ' conceal' : ''
  let arg = exists('b:fugitive_blame_arguments') ? b:fugitive_blame_arguments : ''
  syn match FugitiveblameBoundary "^\^"
  syn match FugitiveblameBlank                      "^\s\+\s\@=" nextgroup=FugitiveblameAnnotation,fugitiveblameOriginalFile,FugitiveblameOriginalLineNumber skipwhite
  syn match FugitiveblameHash       "\%(^\^\=\)\@<=\<\x\{7,40\}\>" nextgroup=FugitiveblameAnnotation,FugitiveblameOriginalLineNumber,fugitiveblameOriginalFile skipwhite
  syn match FugitiveblameUncommitted "\%(^\^\=\)\@<=\<0\{7,40\}\>" nextgroup=FugitiveblameAnnotation,FugitiveblameOriginalLineNumber,fugitiveblameOriginalFile skipwhite
  syn region FugitiveblameAnnotation matchgroup=FugitiveblameDelimiter start="(" end="\%( \d\+\)\@<=)" contained keepend oneline
  syn match FugitiveblameTime "[0-9:/+-][0-9:/+ -]*[0-9:/+-]\%( \+\d\+)\)\@=" contained containedin=FugitiveblameAnnotation
  exec 'syn match FugitiveblameLineNumber         " *\d\+)\@=" contained containedin=FugitiveblameAnnotation'.conceal
  exec 'syn match FugitiveblameOriginalFile       " \%(\f\+\D\@<=\|\D\@=\f\+\)\%(\%(\s\+\d\+\)\=\s\%((\|\s*\d\+)\)\)\@=" contained nextgroup=FugitiveblameOriginalLineNumber,FugitiveblameAnnotation skipwhite'.(arg =~# 'f' ? '' : conceal)
  exec 'syn match FugitiveblameOriginalLineNumber " *\d\+\%(\s(\)\@=" contained nextgroup=FugitiveblameAnnotation skipwhite'.(arg =~# 'n' ? '' : conceal)
  exec 'syn match FugitiveblameOriginalLineNumber " *\d\+\%(\s\+\d\+)\)\@=" contained nextgroup=FugitiveblameShort skipwhite'.(arg =~# 'n' ? '' : conceal)
  syn match FugitiveblameShort              " \d\+)" contained contains=FugitiveblameLineNumber
  syn match FugitiveblameNotCommittedYet "(\@<=Not Committed Yet\>" contained containedin=FugitiveblameAnnotation
  hi def link FugitiveblameBoundary           Keyword
  hi def link FugitiveblameHash               Identifier
  hi def link FugitiveblameUncommitted        Ignore
  hi def link FugitiveblameTime               PreProc
  hi def link FugitiveblameLineNumber         Number
  hi def link FugitiveblameOriginalFile       String
  hi def link FugitiveblameOriginalLineNumber Float
  hi def link FugitiveblameShort              FugitiveblameDelimiter
  hi def link FugitiveblameDelimiter          Delimiter
  hi def link FugitiveblameNotCommittedYet    Comment
  let seen = {}
  for lnum in range(1, line('$'))
    let hash = matchstr(getline(lnum), '^\^\=\zs\x\{6\}')
    if hash ==# '' || hash ==# '000000' || has_key(seen, hash)
      continue
    endif
    let seen[hash] = 1
    if &t_Co > 16 && get(g:, 'CSApprox_loaded') && !empty(findfile('autoload/csapprox/per_component.vim', escape(&rtp, ' ')))
          \ && empty(get(s:hash_colors, hash))
      let [s, r, g, b; __] = map(matchlist(hash, '\(\x\x\)\(\x\x\)\(\x\x\)'), 'str2nr(v:val,16)')
      let color = csapprox#per_component#Approximate(r, g, b)
      if color == 16 && &background ==# 'dark'
        let color = 8
      endif
      let s:hash_colors[hash] = ' ctermfg='.color
    else
      let s:hash_colors[hash] = ''
    endif
    exe 'syn match FugitiveblameHash'.hash.'       "\%(^\^\=\)\@<='.hash.'\x\{1,34\}\>" nextgroup=FugitiveblameAnnotation,FugitiveblameOriginalLineNumber,fugitiveblameOriginalFile skipwhite'
  endfor
  call s:RehighlightBlame()
endfunction

function! s:RehighlightBlame() abort
  for [hash, cterm] in items(s:hash_colors)
    if !empty(cterm) || has('gui_running') || has('termguicolors') && &termguicolors
      exe 'hi FugitiveblameHash'.hash.' guifg=#'.hash.get(s:hash_colors, hash, '')
    else
      exe 'hi link FugitiveblameHash'.hash.' Identifier'
    endif
  endfor
endfunction
