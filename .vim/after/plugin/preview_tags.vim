" Preview tags {{{
" XXX breaks when used with taglist because taglist jumps
" in and out and the previous window is not maintained
"
let g:prevword=0
command! -nargs=0 -bar AutoPrevWordToggle	let g:prevword=!g:prevword
" actually a bit annoying
" using it with CursorMoved is slow
" from CursorHold-example
au! CursorHold *.[ch] nested	if g:prevword |call PreviewWord()|endif
" CHANGE
func! PreviewWord()
	if &previewwindow			" don't do this in the preview window
		return
	endif
	let w = expand("<cword>")		" get the word under cursor
	if w =~ '\a'			" if the word contains a letter

		" Delete any existing highlight before showing another tag
		silent! wincmd P			" jump to preview window
		if &previewwindow			" if we really get there...
			match none			" delete existing highlight
			wincmd p			" back to old window
		endif

		" Try displaying a matching tag for the word under the cursor
		try
			exe "ptag " . w
		catch
			return
		endtry

		silent! wincmd P			" jump to preview window
		if &previewwindow		" if we really get there...
			if has("folding")
				" CHANGE
				"	   silent! .foldopen		" don't want a closed fold
				silent! normal zo
			endif
			call search("$", "b")		" to end of previous line
			let w = substitute(w, '\\', '\\\\', "")
			call search('\<\V' . w . '\>')	" position cursor on match
			" Add a match highlight to the word at this position
			hi previewWord term=bold ctermbg=green guibg=green
			exe 'match previewWord "\%' . line(".") . 'l\%' . col(".") . 'c\k*"'
			wincmd p			" back to old window
		endif
	endif
endfun

function! PreviewMaps()
	nnoremap <buffer> <silent> <F9>	:call PreviewWordToggle()<CR>
	imap <buffer> <silent> <F9>	<Esc><F9>
endfunction

function! PreviewWordToggle()
	silent! wincmd P
	if &previewwindow
		pclose
		wincmd p
	else
		call PreviewWord()
	endif
endfunction
"}}}
