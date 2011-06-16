finish
" TODO: what was I doing here?
function! Javadoc(classname)
	let tmpfile = tempname()
	if executable("findjavadoc.sh")
		exe "!findjavadoc.sh ".a:classname.">".tmpfile
		if filereadable(tmpfile)
			exe "silent! new ".tmpfile
			let fqn=getline(1)
			if bufexists(fqn)
				let delnr=bufnr(fqn)
				exe delnr."bd"
			endif
			exe "silent! keepalt file ".fqn
			normal gg
			exe "autocmd BufEnter ".fqn."setlocal buftype=nowrite"
			exe "autocmd BufEnter ".fqn."setlocal nomod noma noswapfile"
			exe "autocmd BufEnter ".fqn."setlocal nomod noma noswapfile"
			exe "autocmd BufEnter ".fqn."nmap <buffer> <C-]>	:call JavapWord()<CR>"

		endif
	else
		echoerr "Error [Javadoc]: findjavadoc.sh is not in your path."
	endif
endfunction
nmap <silent> \jd :call Javadoc(expand("<cword>"))<CR>
