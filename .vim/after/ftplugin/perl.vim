" Vim filetype plugin file
" Language:	Perl

call programming#Programming()
call programming#CurlyBraces()
setlocal foldmethod=syntax

compiler perl
let &l:makeprg = substitute(&l:makeprg, "\\s*%","","")

nmap <buffer> <F6> :!"%:p"<CR>
imap <buffer> <F6> <Esc><F6>

setlocal iskeyword+=:
