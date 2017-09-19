" Increment and decrement the last number in the filename
function! AddNumPrefixed(str, delta)
	let width = 0
	let num = str2nr(a:str)
	if match(a:str, "^0") != -1
		let width = len(a:str)
	end
	return printf("%0". width . "d", num + a:delta)
endfunction

function! AddNumPath(path, delta)
	let regex = '^\(.\{-}\)\([[:digit:]]\+\)\([^[:digit:]]*\)$'
	let m = matchlist(a:path, regex)
	let m_d = AddNumPrefixed(m[2], a:delta)
	while len(m[2]) > len(m_d)
		let m_d = '0' . m_d
	endwhile

	return m[1].m_d.m[3]
endfunction

nmap <C-N> :exe "e ". AddNumPath(expand("%"), 1)<CR>
nmap <C-P> :exe "e ". AddNumPath(expand("%"), -1)<CR>
