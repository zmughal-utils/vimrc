function! ikiwiki#path#GetFullPagePath()
	let l:sys_getpath = "cd " . shellescape(expand('%:p:h'))
				\ . " && git ls-tree --full-name --name-only HEAD ". shellescape(expand('%:p'))
	let output = system(l:sys_getpath)
	let output = substitute( output, "\n", "", "")
	return substitute(output, '/index\.mdwn', '/', '')
endfunction

function! ikiwiki#path#GetPageNameFromPath()
	let page_name = expand("%:t") == "index.mdwn"
				\ ? substitute(expand("%:p"), '^.*/\([^/]\+\)/index\.mdwn' ,'\1','g')
				\ : expand("%:t:r")
	return page_name
endfunction

function! ikiwiki#path#GetTitleFromPath()
	return substitute(ikiwiki#path#GetPageNameFromPath(), '[-_]', ' ', 'g')
endfunction
