function! SheBangRun()
	let first=getline(1)
	if first =~ "^#!"
		exe '!'.substitute(first,'^#!','','').' '.fnameescape(expand('%'))
	endif
endfunction
