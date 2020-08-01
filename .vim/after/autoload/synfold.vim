function synfold#fold_by_name(names)
	let l:lnum = 1
	while l:lnum < line('$')
		if foldclosed(l:lnum) != -1
			let l:lnum = foldclosedend(l:lnum) + 1
			continue
		endif
		let l:synname = map(synstack(l:lnum, 1), 'synIDattr(v:val, "name")')
		let l:synname_next = map(synstack(l:lnum+1, 1), 'synIDattr(v:val, "name")')
		for name in a:names
			if index(l:synname, name) > 0 && index(l:synname_next, name) > 0
				exe l:lnum . "foldclose"
				break
			endif
		endfor
		let l:lnum += 1
	endwhile
endfunction
