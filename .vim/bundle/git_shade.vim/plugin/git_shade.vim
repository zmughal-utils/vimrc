" git_shade.vim - Colors lines in different intensities according to their age in git's history
" Run :GitShade to shade the file, and again to turn it off.
" git_shade assumes you have a black background.  If not, you are likely to have a bad time.

" See also: https://github.com/FriedSock/smeargle (requires Ruby)

" TODO: Support for users with &background == "light"
" TODO: Offer custom shade gradient, through two hex vars or two highlight settings.



" === Commands ===

command! GitShade call s:GitShade(expand("%"))



" === Options ===

if !exists("g:GitShade_ColorGradient") || !exists("g:GitShade_ColorWhat")
  let g:GitShade_ColorGradient = "black_to_blue"
  let g:GitShade_ColorWhat = "bg"
  "let g:GitShade_ColorGradient = "green_to_white"
  "let g:GitShade_ColorWhat = "fg"
endif

" Mode 0 is good at indicating recent lines; old lines fade to black.
" Mode 1 is good for comparing the ages of all the lines in the file.
if !exists("g:GitShade_Linear")
  let g:GitShade_Linear = 0
endif

if !exists("g:GitShade_Colors_For_CTerm_8")
  let g:GitShade_Colors_For_CTerm_8   = [ 0, 0, 4 ]
endif
if !exists("g:GitShade_Colors_For_CTerm_16")
  let g:GitShade_Colors_For_CTerm_16  = [ 0, 0, 4, 12 ]
endif
if !exists("g:GitShade_Colors_For_CTerm_256")
  let g:GitShade_Colors_For_CTerm_256 = [ 0, 0, 17, 18, 19, 20, 27, 33 ]
endif



" === Script ===

function! s:GitShade(filename)

  if exists("w:git_shade_enabled") && w:git_shade_enabled
    call s:GitShadeDisable()
    return
  endif
  let w:git_shade_enabled = 1

  " This fails if we are not inside the same repository as the buffer
  "let cmd = "git blame --line-porcelain -t " . shellescape(a:filename)
  " No idea why this isn't working.  It works fine when I copy-paste it!
  "let workHere = shellescape("--work-tree=" . fnamemodify(a:filename,":p:h"))
  "let cmd = "git ".workHere." blame --line-porcelain -t " . shellescape(a:filename)
  " Works but a bit long and messy
  "let workingFolder = fnamemodify(a:filename, ":p:h")   " Global, but relative should do...
  let targetFile = resolve(a:filename)
  let workingFolder = fnamemodify(targetFile, ":h")
  let relativeFilename = fnamemodify(targetFile, ":t")
  let cmd = "cd " . shellescape(workingFolder) . " && git blame --line-porcelain -t -w " . shellescape(relativeFilename)

  echo "Doing: " . cmd

  let data = system(cmd)

  let lines = split(data,'\n')

  let timesDictionary = {}
  let b:gitBlameLineData = ["there_is_no_line_zero"]
  let earliestTime = localtime()
  let latestTime = 0

  let timeNum = -1
  let author = ""
  let summary = ""
  let lineNum = 0
  for line in lines

    if line[0:0] == "\t"

      let lineNum += 1
      "call add(times, timeNum)
      if !exists("timesDictionary[timeNum]")
        let timesDictionary[timeNum] = []
      endif
      let list = timesDictionary[timeNum]
      call add(list, lineNum)
      if timeNum > latestTime
        let latestTime = timeNum
      endif
      if timeNum < earliestTime
        let earliestTime = timeNum
      endif
      let dateStr = strftime("%d/%m/%y %H:%M", timeNum)
      call add( b:gitBlameLineData, dateStr." (".author.") ".summary )

    elseif line[0:6] == "author "
      let author = s:afterSpace(line)
    elseif line[0:7] == "summary "
      let summary = s:afterSpace(line)
    elseif line[0:14] == "committer-time "
      let timeNum = s:afterSpace(line)
    endif

  endfor

  if line("$") != lineNum
    echo "WARNING: buffer linecount " . line("$") . " does not match git blame linecount " . lineNum
  endif

  " TODO: These options should be made configurable

  " In active projects, intensity can represent age relative to now
  let mostRecentTime = localtime()
  " But in old projects or old files, we may want to show changes relative to the last commit, even if it was made years ago
  "let mostRecentTime = latestTime

  " Lines older than 2 weeks are colored normally
  "let maxAge = 14 * 24 * 60 * 60
  " Only lines from the very first commit are colored normally
  let maxAge = mostRecentTime - earliestTime
  " Only shade lines in the second half of the file's history
  "let maxAge = (mostRecentTime - earliestTime) / 2.0
  " How fast should intensity fade as we move into the past?
  " Just enough to give a faint shade to the first commit:
  let halfLife = (mostRecentTime - earliestTime) / 16.0
  " Or constant: intensity halves every two weeks
  "let halfLife = 60*60*24*14

  " We need these to be floats for later calculations
  let maxAge = maxAge * 1.0
  let halfLife = halfLife * 1.0

  if maxAge == 0
    echo "Could not find any history.  Is this file managed by git?"
    return
  endif

  silent! call clearmatches()

  "let lineNum = 0
  "for timeNum in times
  for [timeNum, linesThisCommit] in items(timesDictionary)

    "let lineNum += 1

    let timeSince = mostRecentTime - timeNum
    if timeSince < 0
      let timeSince = 0
    endif
    if timeSince > maxAge
      let timeSince = maxAge
      " Skip doing any highlighting on old/unshaded lines
      " Only applies to some themes.
      if g:GitShade_ColorWhat == "bg" && match(g:GitShade_ColorGradient, "^black")==0
        continue
      endif
    endif

    if g:GitShade_Linear
      " Linear: intensity interpolates from min to max over time range
      let intensity = 1.0 - timeSince / maxAge
    else
      " Exponential: intensity halves every halfLife
      let intensity = 1.0 / (1.0 + timeSince / halfLife)
    endif

    let hlStr = s:GetHexColorFor(intensity)

    let ctermStr = s:GetCTermColorFor(intensity)

    let hlName = "GitShade_" . hlStr

    if hlexists(hlName)
      exec "highlight clear " . hlName
    endif

    "echo "timeSince=" . timeSince . " maxAge=" . maxAge . " intensity=" . intensity

    if g:GitShade_ColorWhat == "fg"
      exec "highlight " . hlName . " guifg=#" . hlStr . " gui=none ctermfg=" . ctermStr
    else
      exec "highlight " . hlName . " guibg=#" . hlStr . " ctermbg=" . ctermStr
    endif

    "let pattern = "\\%" . lineNum . "l"
    let pattern = join( map(linesThisCommit,'"\\%" . v:val . "l"'), '\|' )

    " Vim throws an error if the pattern length is too large (it was somewhere between 50,000 and 60,000).
    if len(pattern) > 50000 && match(pattern, '|') >= 0
      echo "Pattern for timestamp ".timeNum." is too large: ".len(pattern)." (It marks ".len(linesThisCommit)." lines) Trimming it."
      let pattern = substitute( strpart(pattern,0,50000), '|[^|]*$', '', '')
    endif

    call matchadd(hlName, pattern)

    "if lineNum > 20
    "  break
    "endif

  endfor

  if exists(":redir") && !exists("w:oldNormalHighlight")
    let w:oldNormalHighlight = ''
    redir => w:oldNormalHighlight
      " silent does not print to screen, but still prints to redir :)
      silent highlight Normal
    redir END
    let w:oldNormalHighlight = substitute(w:oldNormalHighlight, '\n', '', 'g')
  endif

  exec "highlight Normal guibg=black"

  " We hide the ruler to prevent ShowGitBlameData from causing press-enter messages.
  if !exists("w:oldRuler")
    let w:oldRuler = &ruler
  endif
  let &ruler = 0
  " CONSIDER: We may also want to unset |showcmd|.  See |press-enter|

  augroup GitShade
    autocmd!
    autocmd BufWinLeave * call s:GitShadeDisable()
    autocmd CursorHold <buffer> call s:ShowGitBlameData()
  augroup END

  " BUG TODO: If I do :CMiniBufExplorer, the BufWinLeave fires *on MBE*, not on my shaded window.  This is not immediately a problem, but it wipes the autocmds, so any future buffer switches keep the shading in the window, yuck!
  "           Perhaps only the CursorHold autocmd should be created+destroyed, whilst the BufWinLeave should remain for the whole life of he script.  (Make two autocmd groups, e.g. GitShadeStatic and GitShadeDynamic.)

  " Creating all these pattern matches makes rendering very inefficient.
  " The time taken to render will probably grow linearly with the number of lines in the file (the number of matches we create).
  " DONE: To reduce this, we could group together times which are the same, and create just one pattern for each unique timestamp, which would highlight multiple lines.
  " As done here: http://stackoverflow.com/questions/13675019/vim-highlight-lines-using-line-number-on-external-file?rq=1
  " CONSIDER: Alternatively, we could use the 'signs' column to indicate different ages, and highlight lines through that.

endfunction

function! s:GetCTermColorFor(intensity)
  if &t_Co >= 256
    let colorArray = g:GitShade_Colors_For_CTerm_256
  elseif &t_Co >= 16
    let colorArray = g:GitShade_Colors_For_CTerm_16
  else
    let colorArray = g:GitShade_Colors_For_CTerm_8
  endif
  let indexFloat = a:intensity * len(colorArray)
  let index = float2nr( indexFloat )
  if index > len(colorArray)-1
    let index = len(colorArray)-1
  endif
  let color = colorArray[index]
  return color
endfunction

function! s:GetHexColorFor(intensity)
  let intensity = float2nr(255.0 * a:intensity)
  let iHex = printf('%02x', intensity)

  " NOTE: In future we may want to interpolate between two provided colors.  If they are provided in hex, we can use str2nr(hexStr, 16) to obtain a decimal.
  if g:GitShade_ColorGradient == "black_to_green"
    let hlStr = "00" . iHex . "00"
  elseif g:GitShade_ColorGradient == "green_to_white"
    let hlStr = iHex . "ff" . iHex
  elseif g:GitShade_ColorGradient == "black_to_blue"
    let hlStr = "0000" . iHex
  elseif g:GitShade_ColorGradient == "black_to_red"
    let hlStr = iHex . "0000"
  elseif g:GitShade_ColorGradient == "black_to_grey"
    let iHex = printf('%02x', intensity/2)
    let hlStr = iHex . iHex . iHex
  elseif g:GitShade_ColorGradient == "grey_to_black"
    let iHex = printf('%02x', 128-intensity/2)
    let hlStr = iHex . iHex . iHex
  elseif g:GitShade_ColorGradient == "blue_to_black"
    let iHex = printf('%02x', 255-intensity)
    let hlStr = "0000" . iHex
  else "if g:GitShade_ColorGradient == "green_to_black"
    let iHex = printf('%02x', 255-intensity)
    let hlStr = "00" . iHex . "00"
  endif

  "echo "Hex for intensity " . intensity . " is: " . hlStr
  return hlStr
endfunction

function! s:ShowGitBlameData()
  if exists("b:gitBlameLineData")
    let data = get(b:gitBlameLineData, line("."), "no_git_blame_data")
    " Truncate string if it will not fit in command-line
    " <bling^> 12 is magical and is the threshold for when it doesn't wrap text anymore
    let maxWidth = &ch * &columns - 12
    if strdisplaywidth(data) > maxWidth
      let data = strpart(data, 0, maxWidth-1) . ">"
    endif
    " Even after truncating, we can still get a press-enter message, if there
    " is only 1 window, and we overlap with the ruler.  So we disabled ruler.
    echo data
  endif
endfunction

function! s:GitShadeDisable()
  call clearmatches()
  let w:git_shade_enabled = 0
  augroup GitShade
    autocmd!
  augroup END
  if exists("w:oldNormalHighlight")
    let rehighlightFixed = substitute(w:oldNormalHighlight,'\<xxx\>','','')
    let rehighlightFixed = substitute(rehighlightFixed,'\<font=.*','','')
    exec "highlight " . rehighlightFixed
  endif
  if exists("w:oldRuler")
    let &ruler = w:oldRuler
  endif
endfunction

function! s:afterSpace(str)
  return substitute(a:str, '^[^ ]* ', '', '')
endfunction

