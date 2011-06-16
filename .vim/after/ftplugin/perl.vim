" Vim filetype plugin file
" Language:	Perl

call programming#Programming()
call programming#CurlyBraces()
setlocal foldmethod=syntax

" From <http://stackoverflow.com/questions/2182164/is-there-a-vim-plugin-that-makes-moose-attributes-show-up-in-tag-list>
" and <http://stackoverflow.com/questions/979359/vim-and-custom-tagging/980051#980051>
let tlist_perl_settings='perl;u:use;p:package;r:role;e:extends;c:constant;a:attribute;s:subroutine;l:label;m:method;q:requires;o:POD'

compiler perl
let &l:makeprg = substitute(&l:makeprg, "\\s*%","","")

nmap <buffer> <F6> :!"%:p"<CR>
imap <buffer> <F6> <Esc><F6>

setlocal iskeyword+=:
