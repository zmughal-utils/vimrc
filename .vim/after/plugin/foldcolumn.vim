augroup Foldcolumn "{{{
	au!
	autocmd FileType *		if &foldmethod=="syntax" && &foldcolumn==0
	autocmd FileType *			setlocal foldcolumn=1
	autocmd FileType *		endif
augroup END "}}}
