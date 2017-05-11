au BufNewFile,BufRead *.svg setf svg

" BeanShell
au BufNewFile,BufRead *.bsh setf java

au BufNewFile,BufRead *.rem	setf remind

" Not idlang
au BufNewFile,BufRead *.pro	setf prolog
au BufNewFile,BufRead *.prolog	setf prolog

autocmd BufNewFile,BufRead *.ahk	setf ahk

autocmd BufNewFile,BufRead *.txx	setf cpp	" templates

autocmd BufNewFile,BufRead bash-fc*	setf sh

autocmd BufNewFile,BufRead *.lsh	setf lisp

autocmd BufNewFile,BufRead *.rq	setf sparql

autocmd BufNewFile,BufRead *.cir	setf spice

autocmd BufNewFile,BufRead *.i	set filetype=swig
autocmd BufNewFile,BufRead *.swg	set filetype=swig 

autocmd BufNewFile,BufRead *.neato	setf dot

autocmd BufNewFile,BufRead *.md	setf markdown

autocmd BufNewFile,BufRead Vagrantfile	setf ruby

autocmd BufNewFile,BufRead *.tjp	setf tjp
autocmd BufNewFile,BufRead *.tji	setf tjp

runtime! ftdetect/*.vim
