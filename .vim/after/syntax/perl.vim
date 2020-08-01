" Vim syntax file
" Language:	Perl

syntax region perlParenthesis start="(" end=")" transparent fold
"syntax region perlCurlyFold start="{" end="}" transparent fold
syntax region perlCommentFold start=+\(^\s*#.*\n\)\@<!\zs\(\_^\s*#.*\)+ end=+\ze\_^\(\s*#.*\n\)\@!.*$+ transparent fold

" MooX::Lsub
syntax match perlStatementProc '\<\%(lsub\)\>'

let g:perl_inline_c=1 " Inline::C sections
runtime syntax/perl_inline.vim

syntax sync fromstart
