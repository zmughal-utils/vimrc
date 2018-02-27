" :help abbreviations
func! Eatchar(pat)
	let c = nr2char(getchar(0))
	return (c =~ a:pat) ? '' : c
endfunc
" iabbr <silent> if if ()<Left><C-R>=Eatchar('\s')<CR>
