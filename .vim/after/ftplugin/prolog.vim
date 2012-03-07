" Vim filetype plugin file
" Language:	Prolog

call programming#Programming()

if !exists("PrologSettingsLoaded")
	let PrologSettingsLoaded=1
	amenu	Prolog.GNU-Prolog.Run		<Esc>:exe "!".GNUPrologInterp(expand("%"))<CR>
	amenu	Prolog.GNU-Prolog.Run\ BG	<Esc>:call command#Background(GNUPrologInterp(expand("%")))<CR>
	amenu	Prolog.SWI-Prolog.Run		<Esc>:exe "!".SWIPrologInterp(expand("%"))<CR>
	amenu	Prolog.SWI-Prolog.Run\ BG	<Esc>:call command#Background(SWIPrologInterp(expand("%")))<CR>
	amenu	Prolog.SWI-Prolog.Run\ (Non-interactive)	<Esc>:exe "!"."swipl -q -t ".PrologLoad(expand("%")))<CR>
	amenu	Prolog.SWI-Prolog.Run\ (Non-interactive)\ BG	<Esc>:call command#Background("swipl -q -t ".PrologLoad(expand("%")))<CR>

	function GNUPrologInterp(file)
		return 'gprolog --init-goal "'.PrologLoad(a:file).'"'
	endfunction

	function SWIPrologInterp(file)
		" TODO: look in to allowing for calling other goals and using
		" the -s option
		return 'swipl -g "'.PrologLoad(a:file).'"'
	endfunction

	function PrologLoad(file)
		return "['".escape(a:file," '\\")."']"
	endfunction

	if executable('swipl')
		let PrologInterp=function("SWIPrologInterp")
	elseif executable('gprolog')
		let PrologInterp=function("GNUPrologInterp")
	endif
endif

nmap <buffer> <F6> :exe "!".PrologInterp(expand("%"))<CR>
imap <buffer> <F6> <Esc><F6>

nmap <buffer> <F7> :call command#Background(PrologInterp(expand("%")))<CR>
imap <buffer> <F7> <Esc><F7>
