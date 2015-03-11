" a shortcut to call commit with --verbose flag
augroup fugitive_Gci
	au!
	au VimEnter,BufNew,BufEnter * if len(fugitive#statusline())
	au VimEnter,BufNew,BufEnter *     command! -buffer -bar -bang -nargs=* Gci	Gcommit<bang> --verbose <args>
	au VimEnter,BufNew,BufEnter * endif
augroup END

