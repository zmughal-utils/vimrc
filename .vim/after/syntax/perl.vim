" Vim syntax file
" Language:	Perl

syntax region perlParenthesis start="(" end=")" transparent fold
syntax region perlCommentFold start=+\(^\s*#.*\n\)\@<!\zs\(\_^\s*#.*\)+ end=+\ze\_^\(\s*#.*\n\)\@!.*$+ transparent fold

syntax sync fromstart
