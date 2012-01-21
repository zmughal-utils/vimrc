au BufNewFile,BufRead *.svg setf svg

" BeanShell
au BufNewFile,BufRead *.bsh setf java

au BufNewFile,BufRead *.rem	setf remind

" Not idlang
au BufNewFile,BufRead *.pro	setf prolog
au BufNewFile,BufRead *.prolog	setf prolog

autocmd BufNewFile,BufRead *.ahk	setf ahk

autocmd BufNewFile,BufRead *.txt	if( expand("<afile>") == "CMakeLists.txt" )
autocmd BufNewFile,BufRead *.txt		setf cmake
autocmd BufNewFile,BufRead *.txt	else
autocmd BufNewFile,BufRead *.txt		setf txt
autocmd BufNewFile,BufRead *.txt	endif

autocmd BufNewFile,BufRead bash-fc*	setf sh

autocmd BufNewFile,BufRead *.lsh	setf lisp

runtime! ftdetect/*.vim
