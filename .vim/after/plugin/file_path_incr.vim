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
	let incr_filename = substitute(a:path,
				\ '^\(.\{-}\)\([[:digit:]]\+\)\([^[:digit:]]*\)$',
				\ '\=submatch(1).AddNumPrefixed(submatch(2), a:delta).submatch(3)',
				\ "")
	return incr_filename
endfunction

nmap <C-N> :exe "e ". AddNumPath(expand("%"), 1)<CR>
nmap <C-P> :exe "e ". AddNumPath(expand("%"), -1)<CR>
