if has("gui")
	function! ToggleFullscreen()
		if has("gui")
			let l:saved_l=&lines
			let l:saved_c=&columns
			let l:guiopt=(match(&guioptions,'\C[mTrl]')>0)
			if l:guiopt
				let &guioptions=substitute(&guioptions,"\\C[mTrl]","","g")
			else
				set guioptions+=mTr
			endif
			sleep 200m
			let &lines=l:saved_l
			let &columns=l:saved_c
		endif
	endfunction
	nnoremap <silent>	<Leader>fs	:call ToggleFullscreen()<CR>
endif
