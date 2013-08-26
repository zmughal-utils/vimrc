setl foldlevel=0
if executable("boxes")
	command! -nargs=0 -range VOobj		<line1>,<line2>!boxes -d vo-cmt -t 4k
	command! -nargs=0 -range VOobjRM	<line1>,<line2>!boxes -r -d vo-cmt -t 4u
else
	command! -nargs=0 -range VOobj		<line1>,<line2>!sed 's/^\(\s*\)\(\S\)/\1: \2/'| sed 's/^$/:/'
	command! -nargs=0 -range VOobjRM	<line1>,<line2>!sed 's/^\(\s*\):/\1/' | sed 's/^:$//'
endif

" VimExec(line) {{{2
" Execute an executable line in vim [copied from Spawn()]
function! VimExec()
		let theline=getline(line("."))
		let idx=matchend(theline, "_vim_\\s*")
		if idx == -1
			echo "Not an vim executable line"
		else
			let command=strpart(theline, idx)
			exec command
		endif
endfunction
"}}}2
nmap <silent><buffer>  <localleader>v           :call VimExec()<cr>
