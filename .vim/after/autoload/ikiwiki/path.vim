function! ikiwiki#path#GetPageNameFromPath()
	let page_name = expand("%:t") == "index.mdwn"
				\ ? substitute(expand("%:p"), '^.*/\([^/]\+\)/index\.mdwn' ,'\1','g')
				\ : expand("%:t:r")
	return page_name
endfunction

function! ikiwiki#path#GetTitleFromPath()
	return substitute(ikiwiki#path#GetPageNameFromPath(), '_', ' ', 'g')
endfunction
