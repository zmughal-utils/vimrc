" Vim script
" File: colorsel.vim
" Summary: A simple interactive RGB/HSV color selector.
" Author: David Necas (Yeti) <yeti@physics.muni.cz>
" URL: http://trific.ath.cx/Ftp/vim/scripts/colorsel.vim
" License: This Vim script is in the public domain.
" Version: 2005-11-21
" Usage: After sourcing, do :ColorSel (it accepts an optional rrggbb argument).
" Keys:
"   j, k  switch between channels (also: <up>, <down>)
"   0, $  sets value to zero, maximum (also: <home>, <end>)
"   h, l  increment/decrement by 1 (also: <left>, <right>)
"   w, b  increment/decrement by larger amount (also: <pageup>, <pagedown>)
"   q     quits immediately
"   y     yanks color in #rrggbb form to the unnamed register
" Parameters:
"   colorsel_swatch_size [number]: vertical swatch size, do not set below 8
"   colorsel_slider_size [number]: slider size, longer sliders a need faster
"                                  computer
" Bugs: Must reload script to change parameters
" TODO: Mouse support

if !has('gui_running')
  echoerr 'Color selector needs GUI'
  finish
endif

let s:swatchSize = exists('colorsel_swatch_size') ? colorsel_swatch_size : 8
let s:swatchSize = s:swatchSize < 8 ? 8 : s:swatchSize
let s:sliderSize = exists('colorsel_slider_size') ? colorsel_slider_size : 16
let s:q = 255*s:sliderSize/(s:sliderSize - 1)
let s:q6 = 359*s:sliderSize/(s:sliderSize - 1)
let s:bufname = '==[ Color Selector ]=='
let s:dashes = '----------'
let s:dashes = s:dashes . s:dashes
let s:dashes = s:dashes . s:dashes
let s:dashes = s:dashes . s:dashes
let s:active = 'r'
let s:guifg = 'white'

function! s:size2width(h)
  return 8*a:h/5
endfun

function! s:drawSwatch(size)
  let i = 0
  let frame = strpart(s:dashes, 0, s:size2width(a:size))
  let s:space = ''
  while i < s:size2width(a:size)
    let s:space = s:space . ' '
    let i = i+1
  endwhile
  call append(0, ' ' . strpart(frame, 0, s:size2width(a:size) - 7) . ' Yeti -')
  let s:space = '|' . s:space . '|'
  let i = 0
  while i < a:size
    call append(0, s:space)
    let i = i+1
  endwhile
  call append(0, ' ' . frame)
endfun

function! s:sliderStr(val, max)
  let slider = ''
  let pos = a:val*s:sliderSize/(a:max + 1)
  let i = 0
  while i < s:sliderSize
    let slider = slider . (i == pos ? '#' : ' ')
    let i = i+1
  endwhile
  return "[" . slider .  "]"
endfun

function! s:byte2dec(byte)
  let s = '' . a:byte
  if a:byte < 100
    let s = ' ' . s
  endif
  if a:byte < 10
    let s = ' ' . s
  endif
  return s
endfun

function! s:formatLine(val, l, max)
  let dec = s:byte2dec(a:val)
  let slider = a:l . ' ' . s:sliderStr(a:val, a:max)
  if s:active == tolower(a:l)
    let active_l = '->'
    let active_r = '<-'
  else
    let active_l = '  '
    let active_r = '  '
  endif
  return '  ' . active_l . slider . active_r . '  ' . dec
endfun

function! s:drawStatus()
  call setline(2, s:space . s:formatLine(s:red, 'R', 255))
  call setline(3, s:space . s:formatLine(s:green, 'G', 255))
  call setline(4, s:space . s:formatLine(s:blue, 'B', 255))
  call setline(5, s:space . s:formatLine(s:hue, 'H', 359))
  call setline(6, s:space . s:formatLine(s:saturation, 'S', 255))
  call setline(7, s:space . s:formatLine(s:value, 'V', 255))
  set nomodified
endfun

function! s:byte2hex(byte)
  let hexdigits = '0123456789abcdef'
  let low = a:byte % 16
  let hi = a:byte / 16
  return hexdigits[hi] . hexdigits[low]
endfun

function! s:rgb2color(r, g, b)
  return s:byte2hex(a:r) . s:byte2hex(a:g) . s:byte2hex(a:b)
endfun

function! s:currentcolor()
  return s:rgb2color(s:red, s:green, s:blue)
endfun

function! s:update()
  let c = s:currentcolor()
  exec 'hi colorselColor guibg=#' . c
  if 3*s:green + 2*s:red + s:blue > 3*255
    let s:guifg = 'black'
  else
    let s:guifg = 'white'
  endif
  call s:hiRGB()
  call s:hiHue()
  call s:hiSaturation()
  call s:hiValue()
  let frame = ' -- ' . c . ' ' . strpart(s:dashes, 0, s:size2width(s:swatchSize) - 10)
  call setline(1, frame)
  call s:drawStatus()
endfun

function! s:updateHSV()
  let max = s:red > s:green ? s:red : s:green
  let max = max > s:blue ? max : s:blue
  let min = s:red < s:green ? s:red : s:green
  let min = min < s:blue ? min : s:blue
  let s:value = max
  let d = max - min
  if d > 0
    let s:saturation = 255*d/max
    if s:red == max
      let s:hue = 60*(s:green - s:blue)/d
    elseif s:green == max
      let s:hue = 120 + 60*(s:blue - s:red)/d
    else
      let s:hue = 240 + 60*(s:red - s:green)/d
    endif
    let s:hue = (s:hue + 360) % 360
  else
    let s:saturation = 0
    let s:hue = 0
  endif
endfun

function! s:updateRGB()
  let s:red = s:hsv2r(s:hue, s:saturation, s:value)
  let s:green = s:hsv2g(s:hue, s:saturation, s:value)
  let s:blue = s:hsv2b(s:hue, s:saturation, s:value)
endfun

function! s:hsv2r(h, s, v)
  if a:s == 0
    return a:v
  endif
  let f = a:h % 60
  let i = a:h/60
  if i == 0 || i == 5
    return a:v
  elseif i == 2 || i == 3
    return a:v*(255 - a:s)/255
  elseif i == 1
    return a:v*(255*60 - (a:s*f))/60/255
  else
    return a:v*(255*60 - a:s*(60 - f))/60/255
  endif
endfun

function! s:hsv2g(h, s, v)
  if a:s == 0
    return a:v
  endif
  let f = a:h % 60
  let i = a:h/60
  if i == 1 || i == 2
    return a:v
  elseif i == 4 || i == 5
    return a:v*(255 - a:s)/255
  elseif i == 3
    return a:v*(255*60 - (a:s*f))/60/255
  else
    return a:v*(255*60 - a:s*(60 - f))/60/255
  endif
endfun

function! s:hsv2b(h, s, v)
  if a:s == 0
    return a:v
  endif
  let f = a:h % 60
  let i = a:h/60
  if i == 3 || i == 4
    return a:v
  elseif i == 0 || i == 1
    return a:v*(255 - a:s)/255
  elseif i == 5
    return a:v*(255*60 - (a:s*f))/60/255
  else
    return a:v*(255*60 - a:s*(60 - f))/60/255
  endif
endfun

function! s:yank()
  call setreg('"', '#' . s:currentcolor(), 'c')
endfun

function! s:inc()
  if s:active == 'r'
    let s:red = (s:red >= 255) ? 255 : s:red+1
    call s:updateHSV()
  elseif s:active == 'g'
    let s:green = (s:green >= 255) ? 255 : s:green+1
    call s:updateHSV()
  elseif s:active == 'b'
    let s:blue = (s:blue >= 255) ? 255 : s:blue+1
    call s:updateHSV()
  elseif s:active == 'h'
    let s:hue = (s:hue >= 359) ? 359 : s:hue+1
    call s:updateRGB()
  elseif s:active == 's'
    let s:saturation = (s:saturation >= 255) ? 255 : s:saturation+1
    call s:updateRGB()
  elseif s:active == 'v'
    let s:value = (s:value >= 255) ? 255 : s:value+1
    call s:updateRGB()
  endif
  call s:update()
endfun

function! s:dec()
  if s:active == 'r'
    let s:red = (s:red <= 0) ? 0 : s:red-1
    call s:updateHSV()
  elseif s:active == 'g'
    let s:green = (s:green <= 0) ? 0 : s:green-1
    call s:updateHSV()
  elseif s:active == 'b'
    let s:blue = (s:blue <= 0) ? 0 : s:blue-1
    call s:updateHSV()
  elseif s:active == 'h'
    let s:hue = (s:hue <= 0) ? 0 : s:hue-1
    call s:updateRGB()
  elseif s:active == 's'
    let s:saturation = (s:saturation <= 0) ? 0 : s:saturation-1
    call s:updateRGB()
  elseif s:active == 'v'
    let s:value = (s:value <= 0) ? 0 : s:value-1
    call s:updateRGB()
  endif
  call s:update()
endfun

function! s:end()
  if s:active == 'r'
    let s:red = 255
    call s:updateHSV()
  elseif s:active == 'g'
    let s:green = 255
    call s:updateHSV()
  elseif s:active == 'b'
    let s:blue = 255
    call s:updateHSV()
  elseif s:active == 'h'
    let s:hue = 359
    call s:updateRGB()
  elseif s:active == 's'
    let s:saturation = 255
    call s:updateRGB()
  elseif s:active == 'v'
    let s:value = 255
    call s:updateRGB()
  endif
  call s:update()
endfun

function! s:begin()
  if s:active == 'r'
    let s:red = 0
    call s:updateHSV()
  elseif s:active == 'g'
    let s:green = 0
    call s:updateHSV()
  elseif s:active == 'b'
    let s:blue = 0
    call s:updateHSV()
  elseif s:active == 'h'
    let s:hue = 0
    call s:updateRGB()
  elseif s:active == 's'
    let s:saturation = 0
    call s:updateRGB()
  elseif s:active == 'v'
    let s:value = 0
    call s:updateRGB()
  endif
  call s:update()
endfun

function! s:pginc()
  if s:active == 'r'
    let s:red = (s:red >= 240) ? 255 : s:red+16
    call s:updateHSV()
  elseif s:active == 'g'
    let s:green = (s:green >= 240) ? 255 : s:green+16
    call s:updateHSV()
  elseif s:active == 'b'
    let s:blue = (s:blue >= 240) ? 255 : s:blue+16
    call s:updateHSV()
  elseif s:active == 'h'
    let s:hue = (s:hue >= 340) ? 359 : s:hue+20
    call s:updateRGB()
  elseif s:active == 's'
    let s:saturation = (s:saturation >= 240) ? 255 : s:saturation+16
    call s:updateRGB()
  elseif s:active == 'v'
    let s:value = (s:value >= 240) ? 255 : s:value+16
    call s:updateRGB()
  endif
  call s:update()
endfun

function! s:pgdec()
  if s:active == 'r'
    let s:red = (s:red <= 16) ? 0 : s:red-16
    call s:updateHSV()
  elseif s:active == 'g'
    let s:green = (s:green <= 16) ? 0 : s:green-16
    call s:updateHSV()
  elseif s:active == 'b'
    let s:blue = (s:blue <= 16) ? 0 : s:blue-16
    call s:updateHSV()
  elseif s:active == 'h'
    let s:hue = (s:hue <= 20) ? 0 : s:hue-20
    call s:updateRGB()
  elseif s:active == 's'
    let s:saturation = (s:saturation <= 16) ? 0 : s:saturation-16
    call s:updateRGB()
  elseif s:active == 'v'
    let s:value = (s:value <= 16) ? 0 : s:value-16
    call s:updateRGB()
  endif
  call s:update()
endfun

function! s:hiRGB()
  let i = 0
  while i < s:sliderSize
    let byte = s:q*i/s:sliderSize
    let c = s:rgb2color(byte, s:green, s:blue)
    exec 'hi colorselRed' . i . ' guibg=#' . c . ' guifg=' . s:guifg
    let c = s:rgb2color(s:red, byte, s:blue)
    exec 'hi colorselGreen' . i . ' guibg=#' . c . ' guifg=' . s:guifg
    let c = s:rgb2color(s:red, s:green, byte)
    exec 'hi colorselBlue' . i . ' guibg=#' . c . ' guifg=' . s:guifg
    let i = i+1
  endwhile
endfun

function! s:hiHue()
  let i = 0
  while i < s:sliderSize
    let byte = s:q6*i/s:sliderSize
    let r = s:hsv2r(byte, s:saturation, s:value)
    let g = s:hsv2g(byte, s:saturation, s:value)
    let b = s:hsv2b(byte, s:saturation, s:value)
    let c = s:rgb2color(r, g, b)
    exec 'hi colorselHue' . i . ' guibg=#' . c . ' guifg=' . s:guifg
    let i = i+1
  endwhile
endfun

function! s:hiSaturation()
  let i = 0
  while i < s:sliderSize
    let byte = s:q*i/s:sliderSize
    let r = s:hsv2r(s:hue, byte, s:value)
    let g = s:hsv2g(s:hue, byte, s:value)
    let b = s:hsv2b(s:hue, byte, s:value)
    let c = s:rgb2color(r, g, b)
    exec 'hi colorselSaturation' . i . ' guibg=#' . c . ' guifg=' . s:guifg
    let i = i+1
  endwhile
endfun

function! s:hiValue()
  let i = 0
  while i < s:sliderSize
    let byte = s:q*i/s:sliderSize
    let r = s:hsv2r(s:hue, s:saturation, byte)
    let g = s:hsv2g(s:hue, s:saturation, byte)
    let b = s:hsv2b(s:hue, s:saturation, byte)
    let c = s:rgb2color(r, g, b)
    exec 'hi colorselValue' . i . ' guibg=#' . c . ' guifg=' . s:guifg
    let i = i+1
  endwhile
endfun

function! s:active2line(a)
  return stridx('rgbhsv', tolower(a:a))
endfun

function! s:activeUp()
  let s:active = 'rgbhsv'[(stridx('rgbhsv', s:active) + 5) % 6]
  call s:drawStatus()
endfun

function! s:activeDown()
  let s:active = 'rgbhsv'[(stridx('rgbhsv', s:active) + 1) % 6]
  call s:drawStatus()
endfun

function! ColorSel(...)
  " set color to rrggbb argument with optional # prefix
  if a:0
    let color = a:1[0] == '#' ? strpart(a:1, 1) : a:1
    exe 'let s:red=0x'.   strpart(color, 0, 2)
    exe 'let s:green=0x'. strpart(color, 2, 2)
    exe 'let s:blue=0x'.  strpart(color, 4, 2)
    call s:updateHSV()
  endif

  if exists('s:bufno') && bufexists(s:bufno) && bufwinnr(s:bufno) > -1
    exec bufwinnr(s:bufno) . 'wincmd w'
    if a:0
      call s:update()
    endif
    return
  endif

  if !exists('s:red')
    let s:red = 127
    let s:green = 127
    let s:blue = 127
    let s:value = 127
    let s:hue = 0
    let s:saturation = 0
  endif

  exec 'split ' . s:bufname
  if !exists('s:bufno') || !bufexists(s:bufno)
    let s:bufno = bufnr('%')
  endif
  set buftype=nowrite
  set bufhidden=delete
  set noswapfile
  call s:drawSwatch(s:swatchSize)
  let shift = s:swatchSize > 8 ? 1 : 0
  call setline(8 + shift, s:space . '  jk switch   0bjlw$ change values')
  call setline(9 + shift, s:space . '   q quits         y yanks #rrggbb')
  exec 'resize ' . (s:swatchSize + 2)
  1

  syn match colorselColor "^| \+|"ms=s+1,me=e-1
  syn match colorselRedS "R \[" nextgroup=colorselRed0
  syn match colorselGreenS "G \[" nextgroup=colorselGreen0
  syn match colorselBlueS "B \[" nextgroup=colorselBlue0
  syn match colorselHueS "H \[" nextgroup=colorselHue0
  syn match colorselSaturationS "S \[" nextgroup=colorselSaturation0
  syn match colorselValueS "V \[" nextgroup=colorselValue0
  let i = 0
  while i < s:sliderSize
    let c = 'colorselRed'
    exec 'syn match ' . c . i . ' "[ #]" nextgroup=' . c . (i+1) . ' contained'
    let c = 'colorselGreen'
    exec 'syn match ' . c . i . ' "[ #]" nextgroup=' . c . (i+1) . ' contained'
    let c = 'colorselBlue'
    exec 'syn match ' . c . i . ' "[ #]" nextgroup=' . c . (i+1) . ' contained'
    let c = 'colorselHue'
    exec 'syn match ' . c . i . ' "[ #]" nextgroup=' . c . (i+1) . ' contained'
    let c = 'colorselSaturation'
    exec 'syn match ' . c . i . ' "[ #]" nextgroup=' . c . (i+1) . ' contained'
    let c = 'colorselValue'
    exec 'syn match ' . c . i . ' "[ #]" nextgroup=' . c . (i+1) . ' contained'
    let i = i+1
  endwhile
  call s:hiRGB()

  " vi-style controls
  nnoremap <buffer><silent> k :call <SID>activeUp()<cr>
  nnoremap <buffer><silent> j :call <SID>activeDown()<cr>
  nnoremap <buffer><silent> h :call <SID>dec()<cr>
  nnoremap <buffer><silent> l :call <SID>inc()<cr>
  nnoremap <buffer><silent> 0 :call <SID>begin()<cr>
  nnoremap <buffer><silent> $ :call <SID>end()<cr>
  nnoremap <buffer><silent> w :call <SID>pginc()<cr>
  nnoremap <buffer><silent> b :call <SID>pgdec()<cr>
  " loser-style controls ;-)
  nnoremap <buffer><silent> <up> :call <SID>activeUp()<cr>
  nnoremap <buffer><silent> <down> :call <SID>activeDown()<cr>
  nnoremap <buffer><silent> <left> :call <SID>dec()<cr>
  nnoremap <buffer><silent> <right> :call <SID>inc()<cr>
  nnoremap <buffer><silent> <home> :call <SID>begin()<cr>
  nnoremap <buffer><silent> <end> :call <SID>end()<cr>
  nnoremap <buffer><silent> <pageup> :call <SID>pginc()<cr>
  nnoremap <buffer><silent> <pagedown> :call <SID>pgdec()<cr>
  " other controls
  nnoremap <buffer><silent> y :call <SID>yank()<cr>
  nnoremap <buffer><silent> q :close!<cr>

  call s:update()
endfun

command! -nargs=? ColorSel call ColorSel(<f-args>)
" vim: set et ts=2 :
