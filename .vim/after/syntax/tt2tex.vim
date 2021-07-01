" Language:      TT2 embedded with TeX

if exists("b:current_syntax")
    finish
endif

let b:tt2_syn_tags = '« »'

"runtime! syntax/tex.vim
"unlet b:current_syntax

runtime! syntax/tt2.vim
unlet b:current_syntax

syn cluster texCmdGroup add=@tt2_top_cluster

let b:current_syntax = "tt2tex"
