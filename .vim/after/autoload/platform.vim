" Identify platform {{{
silent function! platform#OSX()
	return has('macunix')
endfunction
silent function! platform#LINUX()
	return has('unix') && !has('macunix') && !has('win32unix')
endfunction
silent function! platform#WINDOWS()
	return (has('win16') || has('win32') || has('win64'))
endfunction
"}}}
