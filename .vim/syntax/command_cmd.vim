"   Copyright (c) 2007, Michael Shvarts <shvarts@akmosoft.com>
" For version 5.x, clear all syntax items.
" For version 6.x, quit when a syntax file was already loaded.
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif
"syn region commandTitle start='^\s*Name\s\+Args\s\+Range\>' end='\<Complete\s\+Definition$' keepend 
syn match commandSpecialChar '<[^<>]\{2,\}>'
syn match commandName contained '\w\+'
syn match commandTitle 'Name\s\+Args\s\+Range\s\+Complete\s\+Definition'
syn region commandDesc start='^[ !]*' end='[01%?*+]'me=s-1 oneline keepend contains=commandName,commandSpecialChar
" Define the default highlighting.
" For version 5.x and earlier, only when not done already.
" For version 5.8 and later, only when an item doesn't have highlighting yet.
if version >= 508 || !exists("did_command_cmd_syn_inits")
  if version < 508
    let did_command_cmd_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink commandName        SpecialKey
  HiLink commandTitle       Title
  HiLink commandName        SpecialKey
  delcommand HiLink
endif
let b:current_syntax = "command"
