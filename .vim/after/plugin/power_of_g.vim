" Commands from <http://vim.wikia.com/wiki/Power_of_g>

command! -range=% DoubleSpace <line1>,<line2>g/^/pu _

function! ReverseLines(line1,line2)
	let oldp=@/
	exe string(a:line1).",".string(a:line2)."g/^/m".string(a:line1-1)
	let @/=oldp
endfunction
command! -range=% -nargs=0 ReverseLines	call ReverseLines(<line1>,<line2>)
