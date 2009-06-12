"   Copyright (c) 2007, Michael Shvarts <shvarts@akmosoft.com>
" For version 5.x, clear all syntax items.
" For version 6.x, quit when a syntax file was already loaded.
if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif
syn match messError '^E\d\+:.*$'
syn match messWarning '^W\d\+:.*$'
syn match messWarning '^search\s\+hit\s\+\u\+[,]\s\+continuing\s\+at\s\+\u\+'
syn match messQuestion '^Scanning:.*$'
syn match messQuestion '^.*(\(\([ynaql]\|\^[EY]\)\(/\|)?\)\)\{2,\}$'
" Define the default highlighting.
" For version 5.x and earlier, only when not done already.
" For version 5.8 and later, only when an item doesn't have highlighting yet.
if version >= 508 || !exists("did_messages_cmd_syn_inits")
    if version < 508
        let did_messages_cmd_syn_inits = 1
        command -nargs=+ HiLink hi link <args>
    else
        command -nargs=+ HiLink hi def link <args>
    endif
    HiLink messError ErrorMsg
    HiLink messWarning WarningMsg
    HiLink messQuestion Question
    delcommand HiLink
endif
let b:current_syntax = "messages_cmd"
