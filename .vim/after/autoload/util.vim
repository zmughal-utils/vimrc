" Vim autoload file
" Some useful functions

function util#NoMiddleMouse()		" No middle click (single and double)
	map <MiddleMouse> <Nop>
	imap <MiddleMouse> <Nop>
	map <2-MiddleMouse> <Nop>
	imap <2-MiddleMouse> <Nop>
endfunction

function util#No_bells()		" No bells at all
	set visualbell t_vb=
endfunction

" go through every tab and window and run Glcd in them if possible
function util#Glcd_all()
	for ttp in range(1, tabpagenr('$'))
		exe "tabn ".ttp
		for i in range(1, winnr('$'))
			exe i . "wincmd W"
			if exists(":Glcd")
				Glcd
			endif
		endfor
		exe 1 . "wincmd W"
	endfor
	exe "tabn ".1
endfunction
