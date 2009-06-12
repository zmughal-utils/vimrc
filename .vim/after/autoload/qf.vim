" Vim autoload file for manipulating the quickfix window

" TODO make it use winrestview()
function qf#ToggleQuickFix(height)		" An ugly hack to make the QuickFix window open and close
	let l:curwin=winnr()
	let l:qfopen=qf#IsQuickFix()

	if qfopen==0
		execute "botright copen ".a:height
		" could use :cwindow instead
	else
		cclose
	endif
	execute curwin."wincmd w"
	" go to orginal window
endfunction

function qf#IsQuickFix()
	let l:curwin=winnr()
	let l:qfopen=0
	windo if &buftype=="quickfix" |let l:qfopen=1|endif	" see if there is already a QuickFix window open
	execute curwin."wincmd w"
	return l:qfopen
endfunction

function qf#D_ToggleQuickFix()
	let qfheight=qf#GetQuickFixHeight()
	call qf#ToggleQuickFix(qfheight)
endfunction

function qf#GetQuickFixHeight()
	let qfheight=10
	if &lines<40	" TODO could use an equation
		let qfheight=4
	endif
	return qfheight
endfunction
