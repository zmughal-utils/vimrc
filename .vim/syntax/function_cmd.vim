"   Copyright (c) 2007, Michael Shvarts <shvarts@akmosoft.com>
" For version 5.x, clear all syntax items.
" For version 6.x, quit when a syntax file was already loaded.
if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif
if b:0
    try
        %s/^\d\+//
        %s/^\s*function\s\+<SNR>/function s:/
    catch /^Vim\%((\a\+)\)\=:E/
    endtry
    silent set ft=vim
    silent normal G=gg 
    finish
else
    syn match funcSpecialChar '<[^<>]\{2,\}>'
endif
" Define the default highlighting.
" For version 5.x and earlier, only when not done already.
" For version 5.8 and later, only when an item doesn't have highlighting yet.
if version >= 508 || !exists("did_function_cmd_syn_inits")
    if version < 508
        let did_function_cmd_syn_inits = 1
        command -nargs=+ HiLink hi link <args>
    else
        command -nargs=+ HiLink hi def link <args>
    endif
    HiLink funcSpecialChar SpecialKey
    delcommand HiLink
endif
let b:current_syntax = "menu"
