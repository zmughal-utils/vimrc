function! IsNERDTreeOpen()
	let l:curwin=winnr()
	let l:ntopen=0
	windo if bufname('%')=~".*NERD_tree_" |let l:ntopen=1|endif
	execute curwin."wincmd w"
	return l:ntopen
endfunction
function! EnvSideBarsToggle()
	let closed=0
	if IsNERDTreeOpen()
		NERDTreeClose
		let closed=1
	endif
	if bufwinnr('__Tag_List__')!=-1
		TlistClose
		let closed=1
	endif
	if !closed
		call EnvSideBars()
	endif
endfunction
function! EnvSideBars()
	NERDTreeToggle
	"CNERDTree
	if exists(':TlistOpen')
		TlistOpen
	endif
	wincmd p
	wincmd l
endfunction

nnoremap <Leader>sb	:call EnvSideBarsToggle()<CR>

