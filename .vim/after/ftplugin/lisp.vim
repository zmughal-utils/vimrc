" Vim filetype plugin file
" Language:	Lisp

call programming#Programming()
set showmatch
nnoremap <buffer> <F6>	:!clisp %<CR>
