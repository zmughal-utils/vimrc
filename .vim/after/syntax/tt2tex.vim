" Language:      TT2 embedded with TeX

if exists("b:current_syntax")
    finish
endif

" At top of TeX file:
" Set the template tags to:
"
" [% TAGS %« »  %]

SetMarker «<+ +>»
let b:tt2_syn_tags = '%« »'

runtime! syntax/tex.vim
unlet b:current_syntax

runtime! syntax/tt2.vim
unlet b:current_syntax

syn cluster texCommentGroup	add=@tt2_top_cluster

let b:current_syntax = "tt2tex"
