call NERDTreeAddKeyMap({
	\ 'key': '\gu',
	\ 'callback': 'NERDTreeUTL',
	\ 'quickhelpText': 'open file with UTL' })

function! NERDTreeUTL()
	let n = g:NERDTreeFileNode.GetSelected()
	if n != {}
		call Set_utl_system()
		exe "Utl openLink " . substitute(fnameescape(n.path.str()), "'", "''", 'g')
	endif
endfunction
