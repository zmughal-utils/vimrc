" Perldoc {{{
function! Perldoc(doc)
	exe 'silent new +r!perldoc\ -T\ '.shellescape(a:doc)
	while getline(1)=~'^\s*$'
		silent normal gg"_dd
	endwhile
	while getline('$')=~'^\s*$'
		silent normal G"_dd
	endwhile
	setlocal nomodifiable buftype=nofile noswapfile
	exe "file ".a:doc." [perldoc]"
	"setf man
	runtime! syntax/man.vim
endfunction
command! -nargs=1 Perldoc	call Perldoc(<f-args>)
"}}}
