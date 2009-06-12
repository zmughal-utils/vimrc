" Vim syntax file
" Language:	C

" do not need this any more because folding has been added
" to the runtime c.vim
" syntax region cFold start="{" end="}" transparent fold
" syntax region cCommentFold start="/\*" end="\*/" transparent fold keepend
syntax region cCommentLineFold start=+\(^\s*//.*\n\)\@<!\zs\(\_^\s*//.*\)+ end=+\ze\_^\(\s*//.*\n\)\@!.*$+ transparent fold

syntax sync fromstart
