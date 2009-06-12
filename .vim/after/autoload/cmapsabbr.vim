" Maps and Abbreviations for C-like languages

function cmapsabbr#If()
	exe "iabbr <silent> <buffer> if if()".abbreviations#EatSpaceSeq()
endfunction

function cmapsabbr#For()
	exe "iabbr <silent> <buffer> fori for(int i=0;i<;i++)".abbreviations#EatSpaceSeq()."<Esc>4hi"
endfunction
