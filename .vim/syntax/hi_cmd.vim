"   Copyright (c) 2007, Michael Shvarts <shvarts@akmosoft.com>
" For version 5.x, clear all syntax items.
" For version 6.x, quit when a syntax file was already loaded.
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif
call ApplyHi(b:hi)
syn match hiAttr  '\<links to\>\|\<cleared\>\|\<ctermfg\>\|\<guisp\>\|\<ctermbg\>\|\<gui\>\|\<term\>\|\<guibg\>\|\<cterm\>\|\<guifg\>\|\<font\>'
" Define the default highlighting.
" For version 5.x and earlier, only when not done already.
" For version 5.8 and later, only when an item doesn't have highlighting yet.
if version >= 508 || !exists("did_hi_cmd_syn_inits")
  if version < 508
    let did_hi_cmd_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink hiAttr SpecialKey
  delcommand HiLink
endif
let b:current_syntax = "menu"
