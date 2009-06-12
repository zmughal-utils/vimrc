" See plugin/nibble.vim for details.
" TODO:
"   - Investigate any possibilities for highlighting half-character vertically.
"   - It should be possible to support two players with two snakes.

if v:version < 700
  echomsg 'You need at least Vim 7.0 to run this version of nibble.vim.'
  finish
endif

" Dependency checks.
if !exists('loaded_genutils')
  runtime plugin/genutils.vim
endif
if !exists('loaded_genutils') || loaded_genutils < 200
  echomsg 'nibble: You need the latest version of genutils.vim plugin'
  finish
endif
let loaded_nibble = 1

" Make sure line-continuations won't cause any problem. This will be restored
"   at the end
let s:save_cpo = &cpo
set cpo&vim

"command! Snake :call <SID>Nibble()

" Initialization {{{

if !exists('g:nibbleNoSplash')
  let g:nibbleNoSplash = 0
endif

if !exists('s:myBufNum')
  let s:myBufNum = -1

  " State variables.
  let s:level = 0
  let s:nLife = 0
  let s:score = 0
  let s:prevGoodScore = 0
  let s:aim = 0
  let s:ly = 0
  let s:lx = 0
  let s:playPaused = 0
endif

" Constants.
let s:MAX_LEVEL = 5
let s:MAX_LIVES = 3
let s:INIT_SNAKE_SIZE = 3
let s:START_LEVEL = 1
let s:MAX_AIM = 9

let s:GAME_PAUSED = 'G A M E   P A U S E D'

" Memory management.
let s:nLines = 0
let s:nBlocks = 0

" Initialization }}}

function! s:SetupBuf()
  let s:MAXX = winwidth(0)
  let s:MAXY = winheight(0)

  call s:clear()
  call genutils#SetupScratchBuffer()
  setlocal noreadonly " Or it shows [RO] after the buffer name, not nice.
  setlocal nonumber
  setlocal foldcolumn=0 nofoldenable
  setlocal tabstop=1
  setlocal bufhidden=hide

  " Setup syntax such a way that any non-tabs appear as selected.
  syn clear
  syn match NibbleSelected "[^\t]"
  hi NibbleSelected gui=reverse term=reverse cterm=reverse

  " Let pressing space again resume a paused game.
  nnoremap <buffer> <Space> :Nibble<CR>
endfunction

function! nibble#Nibble()
  if s:myBufNum == -1
    " Temporarily modify isfname to avoid treating the name as a pattern.
    let _isf = &isfname
    let _cpo = &cpo
    try
      set isfname-=\
      set isfname-=[
      set cpo-=A
      if exists('+shellslash')
	exec "sp \\\\[Nibble]"
      else
	exec "sp \\[Nibble]"
      endif
    finally
      let &isfname = _isf
      let &cpo = _cpo
    endtry
    let s:myBufNum = bufnr('%')
  else
    let buffer_win = bufwinnr(s:myBufNum)
    if buffer_win == -1
      exec 'sb '. s:myBufNum
    else
      exec buffer_win . 'wincmd w'
    endif
  endif
  wincmd _

  let restCurs = ''
  let _gcr = &guicursor
  try
    setlocal modifiable

    let restCurs = substitute(genutils#GetVimCmdOutput('hi Cursor'),
          \ '^\(\n\|\s\)*Cursor\s*xxx\s*', 'hi Cursor ', '')
    let hideCurs = substitute(genutils#GetVimCmdOutput('hi Normal'),
          \ '^\(\n\|\s\)*Normal\s*xxx\s*', 'hi Cursor ', '')
    " Font attribute for Cursor doesn't seem to be really used, and it might
    " cause trouble if has spaces in it, so just remove this attribute.
    let restCurs = substitute(restCurs, ' font=.\{-}\(\w\+=\|$\)\@=', ' ', '')
    let hideCurs = substitute(hideCurs, ' font=.\{-}\(\w\+=\|$\)\@=', ' ', '')

    let option = 'p'
    if !s:playPaused
      call s:SetupBuf()

      call s:welcome()
    endif

    exec hideCurs
    set guicursor=n-i:hor1:ver1
    call s:play()
  catch /^Vim:Interrupt$/
    " Do nothing.
  finally
    exec restCurs | " Restore the cursor highlighting.
    let &guicursor = _gcr
    call setbufvar(s:myBufNum, '&modifiable', !s:playPaused)
  endtry
endfunction

function! s:welcome()
  if g:nibbleNoSplash
    return
  endif

  call s:clear()
  let y = s:MAXY/2 - 6
  call s:putstrcentered(y, 'N I B B L E   G A M E')
  call s:putstrcentered(y+3, 'F O R   V I M')
  call s:putstr(y+5, 1, "Use 'h', 'j', 'k' & 'l' keys to change the direction".
        \ "of the snake.")
  call s:putstr(y+7, 1, 'q or <ctrl>C to Quit and <Space> to Pause')
  redraw
  3sleep
endfunction

function! s:play()
  redraw
  if !s:playPaused
    let s:level = s:START_LEVEL
    let s:nLife = 0
    let s:score = 0
    let s:prevGoodScore = 0
    let s:aim = 0
    let s:ly = 0
    let s:lx = 0
  else
    call s:putstrcentered(1, substitute(s:GAME_PAUSED, '[^ ]', ' ', 'g'))
    redraw
    1sleep " Give time to react.
  endif
  let lostLife = 0
  while s:level <= s:MAX_LEVEL
    try " [-2f]

    if !s:playPaused
      if !s:InitLevel(s:level)
        break
      endif
      let s:prevGoodScore = s:score
      let s:aim = 0
      call s:snake.SetSize(s:INIT_SNAKE_SIZE)
    endif
    call s:showLives()
    while s:aim < s:MAX_AIM
      if !s:playPaused
        " Determine the random positions of the aim, between (2, MAX-1).
        let s:ly = (s:rand() % (s:MAXY-2)) + 2
        let s:lx = (s:rand() % (s:MAXX-2)) + 2
        " Skip this random position if it falls on the snake or block.
        if s:snake.PtOnSnake(s:ly, s:lx) ||
              \ s:blocks.PtOnBlock(s:ly, s:lx)
          continue
        endif
        let s:aim = s:aim + 1
      else
        let s:playPaused = 0
      endif
      call s:putstr(s:ly, s:lx, s:aim.'')
      while 1
        let char = getchar(0)
        if char == '^\d\+$' || type(char) == 0
          let char = nr2char(char)
        endif " It is the ascii code.

        if char == 'q'
          quit
          return
        elseif char == ' '
          let s:playPaused = 1
          call s:putstrcentered(1, s:GAME_PAUSED)
          return
        elseif char == 'k' " UP
          call s:snake.Up()
        elseif char == 'j' " DOWN
          call s:snake.Down()
        elseif char == 'l' " RIGHT
          call s:snake.Right()
        elseif char == 'h' " LEFT
          call s:snake.Left()
        endif

        if !s:snake.Move()
          let lostLife = 1
          break
        endif
        let fx = s:snake.HeadX()
        let fy = s:snake.HeadY()
        " Snake touched the border, blocks or hit itself.
        if
              \ (fy <= 1 || fy >= s:MAXY || fx <= 1 || fx >= s:MAXX) ||
              \ s:blocks.PtOnBlock(fy, fx)
          let lostLife = 1
          break
        endif
        if fy == s:ly && fx == s:lx " Snake ate the mouse.
          let s:score = s:score + s:level*s:aim*10
          call s:snake.SetSize(s:snake.Size()+2*s:aim)
          call s:ShowScore()
          break
        endif
        call s:delay()
      endwhile

      if lostLife
        if s:nLife != s:MAX_LIVES
          let lostLife = 0
          let s:nLife = s:nLife + 1
          let s:level = s:level - 1 " Play the same level again.
          let s:score = s:prevGoodScore
        endif
        break
      endif
    endwhile

    if lostLife
      break " Game end.
    endif
    finally " [+2s]
      if !s:playPaused
        let s:level = s:level + 1
      endif
    endtry
  endwhile
  call s:putstrcentered(s:MAXY/2 - 2, 'G A M E   E N D E D !!!')
endfunction

function! s:ShowScore()
  call s:putstrright(s:MAXY, 'Score: '.s:score)
endfunction

function! s:ShowLevel()
  call s:putstrcentered(s:MAXY, 'Level: '.s:level.'/'.s:MAX_LEVEL)
endfunction

function! s:showLives()
  call s:putstrleft(s:MAXY, 'Lives used: '.s:nLife.'/'.s:MAX_LIVES)
endfunction

let s:randSeed = substitute(strftime('%S'), '^0', '', '')+0
let s:randSeq = 0
function! s:rand()
  let randNew = substitute(strftime('%S'), '^0', '', '')+0
  let randNew = randNew + 60*(substitute(strftime('%S'), '^0', '', '')+0)
  let s:randSeq = s:randSeq + 1
  return s:randSeed + randNew + s:randSeq
endfunction

function! s:InitLevel(level)
  call s:clear()
  let y = s:MAXY/2 - 6
  let x = s:MAXX/2 - 12
  call s:putstrcentered(y, 'Continuing level '.a:level)
  call s:putstrcentered(y + 2, 'Push SPACE bar to quit...')
  redraw
  2sleep
  if getchar(0) == 32
    return 0
  endif

  call s:clear()
  " We have a border for all the levels.
  call s:putrow(1, 1, s:MAXX, ' ')
  call s:putrow(s:MAXY, 1, s:MAXX, ' ')
  call s:putcol(2, s:MAXY - 1, 1, ' ')
  call s:putcol(2, s:MAXY - 1, s:MAXX, ' ')
  let s:snake = s:snakecls.new()

  let s:blocks = s:blockcls.new()
  if a:level == 2
    " One horizonal line in the middle.
    let width = s:MAXX*3/8
    let x = (s:MAXX-width)/2
    let y = s:MAXY/2
    call s:blocks.AddHorLine(y, x, x+width)
  elseif a:level == 3
    " Two vertical lines in the middle.
    let width = s:MAXY*3/8
    let height = 2*width
    let x = s:MAXX/6
    let y = s:MAXY*5/16
    call s:blocks.AddVerLine(y, y + width, x)
    call s:blocks.AddVerLine(y, y + width, s:MAXX - x)
  elseif a:level == 4
    " A square looking rectagle in the middle, with only a small entrance.
    let width1 = s:MAXX*3/8
    let width2 = s:MAXY*3/8
    let x = s:MAXX*5/16
    let y = s:MAXY*5/16
    call s:blocks.AddHorLine(y, x, x+width1)
    call s:blocks.AddHorLine(y + width2, x, x+width1)
    call s:blocks.AddVerLine(y, y + width2 - 2, x)
    call s:blocks.AddVerLine(y, y + width2, x + width1)
  elseif a:level == 5
    " A Cross in the middle.
    let x = s:MAXX / 2
    let y = s:MAXY / 2
    call s:blocks.AddHorLine(y, 3, s:MAXX - 2)
    call s:blocks.AddVerLine(3, s:MAXY - 2, x)
  endif

  call s:ShowScore()
  call s:ShowLevel()
  " Eat any pending characters.
  while getchar(0) != '0'
  endwhile
  return 1
endfunction

function! s:putrow(y, x1, x2, ch)
  let y = (a:y > 0) ? a:y : 1
  let x1 = (a:x1 > 0) ? a:x1 : 1
  let x2 = (a:x2 > 0) ? a:x2 : 1
  let x2 = (x2 == s:MAXX) ? x2 + 1 : x2
  let ch = a:ch[0]
  let _search = @/
  try
    let @/ = '\%>'.(x1-1).'c.\%<'.(x2+2).'c'
    silent! exec y.'s//'.ch.'/g'
  finally
    let @/ = _search
  endtry
endfunction

function! s:putcol(y1, y2, x, ch)
  let y1 = (a:y1 > 0) ? a:y1 : 1
  let y2 = (a:y2 > 0) ? a:y2 : 1
  let x = (a:x > 0) ? a:x : 1
  let ch = a:ch[0]
  let _search = @/
  try
    let @/ = '\%'.x.'c.'
    silent! exec y1.','.y2.'s//'.ch
  finally
    let @/ = _search
  endtry
endfunction

function! s:putstr(y, x, str)
  let y = (a:y > 0) ? a:y : 1
  let x = (a:x > 0) ? a:x : 1
  let _search = @/
  try
    if a:y > line('$')
      silent! $put=a:str
    else
      let @/ = '\%'.x.'c.\{'.strlen(a:str).'}'
      silent! exec y.'s//'.escape(a:str, '\&~/')
    endif
  finally
    let @/ = _search
  endtry
endfunction

function! s:putstrleft(y, str)
  call s:putstr(a:y, 2, a:str)
endfunction

function! s:putstrright(y, str)
  call s:putstr(a:y, s:MAXX-strlen(a:str)-1, a:str)
endfunction

function! s:putstrcentered(y, str)
  call s:putstr(a:y, (s:MAXX-strlen(a:str))/2, a:str)
endfunction

function! s:clear()
  call genutils#OptClearBuffer()
  " Fill the buffer with tabs.
  let tabFill = substitute(genutils#GetSpacer(s:MAXX), ' ', "\t", 'g')
  while strlen(tabFill) < s:MAXX
    let tabFill = tabFill.strpart(tabFill, 0, s:MAXX - strlen(tabFill))
  endwhile
  call setline(1, tabFill)
  let i = 2
  while i <= s:MAXY
    silent! $put=tabFill
    let i = i + 1
  endwhile 

  let s:snake = {}
  let s:blocks = {}
endfunction

function! s:delay()
  sleep 80m
endfunction

let s:NULL = {}
lockvar! s:NULL

" Point {{{

let s:pointcls = {}
function! s:pointcls.new(y, x)
  let pt = copy(self)
  let pt.y = a:y
  let pt.x = a:x
  return pt
endfunction

" Point }}}

" Snake {{{

let s:snakecls = {}
function! s:snakecls.new()
  let snake = copy(s:snakecls)
  unlockvar! snake
  let snake.size = 0 " Target size of the snake.
  let snake.sizeI = 0 " Current temporal size of the snake.
  let snake.points = []
  let snake.incrx = 1 " Determines the x direction of the snake.
  let snake.incry = 0 " Determines the y direction of the snake.

  call snake.AddHead(2, 2)
  return snake
endfunction

function! s:snakecls.Size()
  return self.size
endfunction

function! s:snakecls.SizeI()
  return self.sizeI
endfunction

function! s:snakecls.IncrX()
  return self.incrx
endfunction

function! s:snakecls.IncrY()
  return self.incry
endfunction

function! s:snakecls.HeadX()
  return self.points[-1].x
endfunction

function! s:snakecls.HeadY()
  return self.points[-1].y
endfunction

function! s:snakecls.TailX()
  return self.points[0].x
endfunction

function! s:snakecls.TailY()
  return self.points[0].y
endfunction

function! s:snakecls.SetSize(size)
  let self.size = a:size
endfunction

function! s:snakecls.SetSizeI(size)
  let self.sizeI = a:size
endfunction

function! s:snakecls.SetIncrX(incrx)
  let self.incrx = a:incrx
endfunction

function! s:snakecls.SetIncrY(incry)
  let self.incry = a:incry
endfunction

function! s:snakecls.AddHead(y, x)
  let newPt = s:pointcls.new(a:y, a:x)
  call s:putstr(a:y, a:x, ' ')
  call add(self.points, newPt)
  call self.SetSizeI(self.SizeI() + 1)
endfunction

function! s:snakecls.RemoveTail()
  let taily = self.TailY()
  let tailx = self.TailX()
  call remove(self.points, 0)
  call self.SetSizeI(self.SizeI() - 1)
  call s:putstr(taily, tailx, "\t")
endfunction

function! s:snakecls.Up()
  if self.IncrY() == -1 || self.IncrY() == 1
    return
  endif
  call self.SetIncrX(0)
  call self.SetIncrY(-1)
endfunction

function! s:snakecls.Down()
  if self.IncrY() == -1 || self.IncrY() == 1
    return
  endif
  call self.SetIncrX(0)
  call self.SetIncrY(1)
endfunction

function! s:snakecls.Right()
  if self.IncrX() == -1 || self.IncrX() == 1
    return
  endif
  call self.SetIncrX(1)
  call self.SetIncrY(0)
endfunction

function! s:snakecls.Left()
  if self.IncrX() == -1 || self.IncrX() == 1
    return
  endif
  call self.SetIncrX(-1)
  call self.SetIncrY(0)
endfunction

function! s:snakecls.Move()
  let fx = self.HeadX() + self.IncrX()
  let fy = self.HeadY() + self.IncrY()
  let head = s:pointcls.new(fy, fx)
  if index(self.points, head) != -1
    return 0
  endif
  call self.AddHead(fy, fx)
  if self.SizeI() > self.Size()
    " Remove the tail.
    call self.RemoveTail()
  endif
  redraw
  return 1
endfunction

function! s:snakecls.PtOnSnake(y, x)
  let pt = s:pointcls.new(a:y, a:x)
  if index(self.points, pt) != -1
    return 1
  endif
  return 0
endfunction
lockvar! s:snakecls

" Snake }}}

" Block {{{

let s:blockcls = {}
function! s:blockcls.new()
  let block = copy(self)
  unlockvar! block
  let block.tail = s:NULL
  let block.head = s:NULL
  return block
endfunction

function! s:blockcls._AddLine(line)
  let oldHead = self.head
  if oldHead isnot s:NULL
    let oldHead.next = a:line
  else
    let self.tail = a:line
  endif
  let self.head = a:line
endfunction

function! s:blockcls.AddHorLine(y, x1, x2)
  call self._AddLine(s:linecls.newHor(a:y, a:x1, a:x2))
  call s:putrow(a:y, a:x1, a:x2, ' ')
endfunction

function! s:blockcls.AddVerLine(y1, y2, x)
  call self._AddLine(s:linecls.newVer(a:y1, a:y2, a:x))
  call s:putcol(a:y1, a:y2, a:x, ' ')
endfunction

function! s:blockcls.PtOnBlock(y, x)
  let line = self.tail
  while line isnot s:NULL
    if line.PtOnLine(a:y, a:x)
      return 1
    endif
    let line = line.next
  endwhile
  return 0
endfunction

lockvar! s:blockcls

" Block }}}

" Line {{{

let s:linecls = {}
" y1 <= y2 && x1 <= x2
function! s:linecls.new(y1, x1, y2, x2)
  let line = copy(self)
  unlockvar! line
  let line.y1 = a:y1
  let line.x1 = a:x1
  let line.y2 = a:y2
  let line.x2 = a:x2
  let line.next = s:NULL
  return line
endfunction

function! s:linecls.newHor(y, x1, x2)
  return self.new(a:y, a:x1, a:y, a:x2)
endfunction

function! s:linecls.newVer(y1, y2, x)
  return self.new(a:y1, a:x, a:y2, a:x)
endfunction

function! s:linecls.PtOnLine(y, x)
  return self.y1 <= a:y && a:y <= self.y2 && self.x1 <= a:x && a:x <= self.x2
endfunction

" Line }}}


" Restore cpo.
let &cpo = s:save_cpo
unlet s:save_cpo

" vim6:fdm=marker et sw=2
