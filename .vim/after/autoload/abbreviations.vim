" From Vimdocs

function abbreviations#Eatchar(pat)
	let c = nr2char(getchar(0))
	return (c =~ a:pat) ? '' : c
endfunction

function abbreviations#EatSpaceSeq()
	return "<Left><C-R>=abbreviations#Eatchar('\s')<CR>"
endfunction
