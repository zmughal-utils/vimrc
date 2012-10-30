" <http://stackoverflow.com/questions/3828606/vim-markdown-folding>
" Extended from <http://stackoverflow.com/questions/3828606/vim-markdown-folding#comment16309004_4677454>
function markdown_fold#MarkdownLevel()
	let h = matchstr(getline(v:lnum), '^#\+')
	if empty(h)
		let l = matchstr(getline(v:lnum), '^\s*\*')
		let ln = matchstr(getline(v:lnum+1), '^\s*\*')
		let lp = matchstr(getline(v:lnum-1), '^\s*\*')
		let blp = match(getline(v:lnum-1), '^$')
		let bln = match(getline(v:lnum+1), '^$')
		if empty(l)
			return "="
		elseif len(l)==1 && blp != -1
			return "a1"
		elseif len(l)==1 && bln != -1
			return "s1"
		elseif len(l) < len(ln) 
			return "a1"
		elseif  len(l) > len(ln) 
			return "s1"
		elseif  len(l) == len(ln) 
			return "="
		end
	else
		return ">" . len(h)
	endif
endfunction
