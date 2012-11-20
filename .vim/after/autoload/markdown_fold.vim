" <http://stackoverflow.com/questions/3828606/vim-markdown-folding>
" Extended from <http://stackoverflow.com/questions/3828606/vim-markdown-folding#comment16309004_4677454>
function markdown_fold#MarkdownLevel()
	let h = matchstr(getline(v:lnum), '^#\+')
	if empty(h)
		let l = matchstr(getline(v:lnum), '^\s*[*+-]')
		let ln = matchstr(getline(v:lnum+1), '^\s*[*+-]')
		let lp = matchstr(getline(v:lnum-1), '^\s*[*+-]')
		let blp = match(getline(v:lnum-1), '^$')
		let bln = match(getline(v:lnum+1), '^$') 
		let beglist = blp!=-1 || v:lnum == 1
		let endlist = bln!=-1 || v:lnum == line('$')
		if empty(l)
			let q = matchstr(getline(v:lnum), '^\s*>')
			let qp = match(getline(v:lnum-1), '^\s*>')
			let qn = match(getline(v:lnum+1), '^\s*>')
			if empty(q) && qp==-1
				return "="
			elseif len(q) && qn==-1
				return "s1"
			elseif len(q) && qp==-1
				return "a1"
			elseif len(q) && qp!=-1
				return "="
			end
		elseif len(l) && beglist && endlist
			return "="
		elseif len(l) && beglist
			let diff = (len(l)-1)/2 + 1
			return "a".diff
		elseif len(l) && endlist
			let diff = (len(l)-1)/2 + 1
			return "s".diff
		elseif len(l) < len(ln) 
			let diff = (len(ln) - len(l)-2)/2 + 1
			return "a".diff
		elseif  len(l) > len(ln) 
			let diff = (len(l)-len(ln)-2)/2 + 1
			return "s".diff
		elseif  len(l) == len(ln) 
			return "="
		end
	else
		return ">" . len(h)
	endif
endfunction
