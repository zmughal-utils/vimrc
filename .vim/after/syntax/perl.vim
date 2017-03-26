" Vim syntax file
" Language:	Perl

syntax region perlParenthesis start="(" end=")" transparent fold
"syntax region perlCurlyFold start="{" end="}" transparent fold
syntax region perlCommentFold start=+\(^\s*#.*\n\)\@<!\zs\(\_^\s*#.*\)+ end=+\ze\_^\(\s*#.*\n\)\@!.*$+ transparent fold

syn region perlSubFold     start="\<sub\>[^\n;]*{" end="};" transparent fold keepend extend
" MooX::Lsub
syntax match perlStatementProc '\<\%(lsub\)\>'

let g:perl_inline_c=1 " Inline::C sections
runtime syntax/perl_inline.vim

syntax sync fromstart
