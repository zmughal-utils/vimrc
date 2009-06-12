" Vim filetype plugin file
" Language:	Perl

call programming#Programming()
call programming#CurlyBraces()
setlocal foldmethod=syntax

compiler perl

nmap <buffer> <F6> :!"%:p"<CR>
imap <buffer> <F6> <Esc><F6>

setlocal iskeyword+=:
