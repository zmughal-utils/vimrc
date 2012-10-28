" <http://stackoverflow.com/questions/3828606/vim-markdown-folding>
" From <http://stackoverflow.com/questions/3828606/vim-markdown-folding#comment16309004_4677454>
function markdown_level#MarkdownLevel()
	let h = matchstr(getline(v:lnum), '^#\+')
	if empty(h)
		return "="
	else
		return ">" . len(h)
	endif
endfunction
