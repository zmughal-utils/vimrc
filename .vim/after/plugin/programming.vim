" Vim global plugin to set up useful things for programming

if exists("loaded_programming")
	finish
endif
let loaded_programming=1

if !exists(":QFtoggle")
	command QFtoggle	call qf#D_ToggleQuickFix()
endif

if !exists(":QFmaps")
	command QFmaps		call programming#QuickFixMaps()
endif

function SmartMakeCall()
	if &makeprg=~'^.\?make' || &makeprg=~'.*%.*'
		exe 'make'
	else
		exe 'make '.fnameescape(expand('%'))
	endif
endfunction
nmap <F5> :call SmartMakeCall()<CR>
imap <F5> <Esc><F5>

amenu ToolBar.Make	:call SmartMakeCall()<CR>
amenu Tools.Make	:call SmartMakeCall()<CR>

" Quick fix window opener {{{
if !exists("g:disable_auto_open_qf")
	let g:disable_auto_open_qf = 0
end
command! ToggleAutoOpenQF let g:disable_auto_open_qf = ! g:disable_auto_open_qf
" Type 0 is for when the errorformat correct
" Type 1 is for when you want to use the return value
function! AutoOpenQF(type)
	if g:disable_auto_open_qf
		return
	endif
	" TODO just the return value of a javac error
	if a:type==0
		exe "botright cwindow ".qf#GetQuickFixHeight()
	elseif a:type==1
		if v:shell_error!=0
			exe "botright copen ".qf#GetQuickFixHeight()
		else
			exe "cclose"
		endif
	endif
endfunction "}}}
