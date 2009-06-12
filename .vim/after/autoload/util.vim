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
