" ingocmdargs.vim: Custom functions for command arguments.
"
" DEPENDENCIES:
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	25-Nov-2012	file creation from CaptureClipboard.vim.

function! ingocmdargs#GetStringExpr( argument )
    try
	if a:argument =~# '^\([''"]\).*\1$'
	    " The argument is quotes, evaluate it.
	    execute 'let l:expr =' a:argument
	elseif a:argument =~# '\\'
	    " The argument contains escape characters, evaluate them.
	    execute 'let l:expr = "' . a:argument . '"'
	else
	    let l:expr = a:argument
	endif
    catch /^Vim\%((\a\+)\)\=:E/
	let l:expr = a:argument
    endtry
    return l:expr
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
