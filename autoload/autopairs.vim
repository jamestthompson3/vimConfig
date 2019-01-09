let s:pairs = {'(': ')', '[': ']', '{': '}', '"': '"', "'": "'", '`':'`', '<':'>'}
let s:end_pairs = {')': '(', ']': '[', '}': '{', '"': '"', "'": "'", '`':'`', '</': '>'}
let s:empty = '[ 	)\]}''"]'

augroup aupairs
  autocmd!
  autocmd InsertCharPre * call s:update_last()
augroup END

function! s:update_last() abort
  if !has_key(s:pairs, v:char) && !has_key(s:end_pairs, v:char)
    let s:last_inserted = v:char
  endif
endfunction

function! s:nextchar() abort
  return strpart(getline('.'), col('.')-1, 1)
endfunction

function! s:prevchar() abort
  return strpart(getline('.'), col('.')-2, 1)
endfunction

function! s:completing_pair(char) abort
  if has_key(s:end_pairs, a:char) && !(index(get(b:, 'autopairs_skip', []), a:char) >= 0)
    return a:char ==# s:nextchar() && a:char !=# get(s:, 'last_inserted', '')
  endif
  return 0
endfunction

function! s:is_pair(char) abort
  if has_key(s:pairs, a:char) && !(index(get(b:, 'autopairs_skip', []), a:char) >= 0)
    return (empty(s:nextchar()) || s:nextchar() =~? s:empty)
  endif
  return 0
endfunction

function! autopairs#check_and_insert(char) abort
  if s:completing_pair(a:char)
    return "\<C-g>U\<right>"
  elseif s:is_pair(a:char)
    let s:last_inserted = a:char
    return a:char . s:pairs[a:char] . "\<C-g>U\<left>"
  endif
  return a:char
endfunction
