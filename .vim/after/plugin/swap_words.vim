" Swap words
" http://vim.wikia.com/wiki/Exchanging_adjacent_words
nnoremap <silent> ,sw	:call SwapWords()<CR>
function! SwapWords()
	let lastpat = @/
	silent exe "normal m`"
	silent s/\v(<\k*%#\k*>)(\_.{-})(<\k+>)/\3\2\1/
	silent exe "normal g``"
	let @/ = lastpat
endfunction
