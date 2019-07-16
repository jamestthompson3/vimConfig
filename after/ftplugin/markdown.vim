" Overwrite default Markdown Fold function
function! MarkdownFold()
  let line = getline(v:lnum)

  " Regular headers
  let depth = match(line, '\(^#\+\)\@<=\( .*$\)\@=')
  if depth > 0
    return ">" . depth
  endif

  " Setext style headings
  let prevline = getline(v:lnum - 1)
  let nextline = getline(v:lnum + 1)
  if (line =~ '^.\+$') && (nextline =~ '^=\+$') && (prevline =~ '^\s*$')
    return ">1"
  endif

  if (line =~ '^.\+$') && (nextline =~ '^-\+$') && (prevline =~ '^\s*$')
    return ">2"
  endif

  " first frontmatter line
  if (v:lnum == 1) && (line =~ '^----*$')
    return ">1"
  endif

  " inside frontmatter
  let origPos = getpos('.')
  if(getline(1) == '---' && v:lnum > 1)
    let ok = cursor(1, 1)
    let frontmatterEnd = search('---', '', line("w$"))
    let ok = cursor(origPos[1], origPos[2]) "Return to the original position

    if frontmatterEnd > 0 && frontmatterEnd > line('.')

      let previous_level = (indent(prevnonblank(v:lnum - 1)) / &shiftwidth) + 1
      let current_level = (indent(v:lnum) / &shiftwidth) + 1
      let next_level = (indent(nextnonblank(v:lnum + 1)) / &shiftwidth) + 1

      if getline(v:lnum + 1) =~ '^\s*$'
        return "="

      elseif current_level < next_level
        return "".next_level

      elseif current_level > next_level
        return ('s' . (current_level - next_level))

      elseif current_level == previous_level
        return current_level
      endif

      return next_level
    endif
  end

  return "="
endfunction

set foldtext=WimpiFoldText()
function! WimpiFoldText()
  let line = getline(v:foldstart)

  if line =~ '^----*$'
    let line = 'FrontMatter'
  endif

  let indent = max([indent(v:foldstart)-v:foldlevel, 1])
  let lines = (v:foldend - v:foldstart + 1)
  let strip_line = substitute(line, '^//\|=\+\|["#]\|/\*\|\*/\|{{{\d\=\|title:\s*', '', 'g')
  let strip_line = substitute(strip_line, '^[[:space:]]*\|[[:space:]]*$', '', 'g')
  let text = strpart(strip_line, 0, winwidth(0) - v:foldlevel - indent - 6 - strlen(lines))

  if strlen(strip_line) > strlen(text)
    let text = text.'…'
  endif

  return repeat('▧', v:foldlevel) . repeat(' ', indent) . text .' ('. lines .')'
endfunction
