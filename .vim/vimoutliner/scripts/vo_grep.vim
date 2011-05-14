function! s:grep(pattern, first_line, last_line)
  let result = []
  let parents = range(10)
  let parent_printed = range(10)
  let linenr = a:first_line
  while linenr <= a:last_line
    let line = getline(linenr)
    let level = indent(linenr)
    let parents[level] = line
    let parent_printed[level] = 0
    "echom 'while: '.line
    if match(line, a:pattern) != -1
      let match_level = level
      for i in range(level)
        if parent_printed[i] == 0
          "echom parents[i]
          call add(result, parents[i])
          "echom string(result)
          let parent_printed[i] = 1
        endif
      endfor
      "echom parents[level]
      call add(result, parents[level])
      while linenr < a:last_line && indent(linenr+1) > match_level
        let linenr += 1
        "echom getline(linenr)
        call add(result, getline(linenr))
      endwhile
    endif
    let linenr += 1
  endwhile
  return result
endfunction

function! s:main(pattern, ...) range
  let result = []
  if a:0
    for file_pat in a:000
      for file in split(glob(file_pat), "\n")
        exec 'edit '.file
        let result += s:grep(a:pattern, a:firstline, a:lastline)
      endfor
    endfor
  else
    let result += s:grep(a:pattern, a:firstline, a:lastline)
  endif
  if result == []
    echom 'VOgrep: No matches found.'
    return
  endif
  new
  if append(0, result) == 1
    bd!
    echohl ErrorMsg
    echom 'VOgrep: There was an error while inserting the results.'
    echohl Normal
    return
  endif
  $d
endfunction

command! -bar -range=% -nargs=+ -complete=file VOgrep <line1>,<line2>call <SID>main(<f-args>)
