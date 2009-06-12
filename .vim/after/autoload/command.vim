" Vim autoload file for command line

function command#Background_string(commandline)		" Returns argument so that when run, it will run in the background
	let background=a:commandline
	if has("win32")
		let background="start vimrun ".a:commandline
	elseif has("unix")
		let background='xterm -hold -e '.shellescape(a:commandline).' &'
	endif
	return background
endfunction

function command#Background(commandline)		" Executes in background
	silent execute "!".command#Background_string(a:commandline)
endfunction
