" Settings for vim-test bundle

" Run inside of an X11 virtual framebuffer. For testing GUI apps without having
" windows coming up into focus.
function! XvfbTransform(cmd) abort
	return 'xvfb-run -a ' . a:cmd
endfunction

let g:test#custom_transformations = {'xvfb': function('XvfbTransform')}

if has('unix')
	let g:test#transformation = 'xvfb'
endif

let g:test#strategy='dispatch'
