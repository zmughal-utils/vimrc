" Vim filetype plugin file
" Language:	Java

call programming#Programming()
call programming#CurlyBraces()
setlocal foldmethod=syntax

" http://java.sun.com/docs/books/tutorial/java/nutsandbolts/_keywords.html
exe "setlocal dict=".fnamemodify(findfile('dict/java_keywords', &rtp), ":p")

setlocal suffixesadd=.java,.html
" the html was for the Javadocs but I do not know if I should keep it
"
"	setlocal cdpath+="". fnamemodify(%,":p:h")
"
"	map gf	:execute "!".browser." ".expand("<cfile>")<CR>

compiler javac
"	setlocal makeprg=javac\ -nowarn\ -classpath\ $CLASSPATH:.\ -d\ .
setlocal makeprg=javac\ -nowarn\ -d\ .
if filereadable("Makefile")
	setlocal makeprg&
endif

" compile
" TODO
" -classpath $CLASSPATH:.:%:p:h
" -d %:p:h

" run
nmap <buffer> <F6> :call java#Run()<CR>
imap <buffer> <F6> <Esc><F6>

nmap <buffer> <F7> :call java#Run_background()<CR>
imap <buffer> <F7> <Esc><F7>

" iabbr <silent> <buffer> println System.out.println("");<Left><Esc>hhi
