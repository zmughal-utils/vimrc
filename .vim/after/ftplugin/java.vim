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

"let g:omni_syntax_group_include_java = 'javaC_,javaR_,javaE_,javaX_'
nnoremap <buffer> <F9> :!ctags --languages=java -R .<CR>
autocmd QuickFixCmdPost <buffer> call AutoOpenQF(0)
setlocal omnifunc=javacomplete#Complete
			\ completefunc=syntaxcomplete#Complete
" Too annoyingly slow
"autocmd FileType java	imap <buffer> . .<C-X><C-O><C-P>
if has("menu")
	amenu PopUp.Goto\ tag :exe "ptag ".expand("<cword>")<CR>
endif
setl foldtext=JavaFoldText()
"{{{ Java abbrevs
"inoreabbr <buffer> sop	System.out.println();<C-O>1h
"inoreabbr <buffer> sopf	System.out.printf("\n",)<C-O>4h

"inoreabbr <buffer> println	System.out.println();<C-O>1h
"inoreabbr <buffer> printf	System.out.printf("\n",);<C-O>1h
"inoreabbr <buffer> print	System.out.print();<C-O>1h
"}}}

function! JavaFoldText()
	let curline=v:foldstart
	let removestring='\/\*\*\=\|\*\/\|\/\/\|{'.
				\ '{{\d\=\|^\s*\*\s*'
	let empty="^\\s*$"
	let vfold=substitute(getline(curline),removestring,'','g')
	while(curline<=v:foldend && vfold=~empty)
		let vfold=substitute(getline(curline),removestring,'','g')
		let curline+=1
	endwhile
	if curline==v:foldend && vfold=~empty
		let vfold=getline(v:foldstart)
	endif
	let vfold=substitute(vfold,'^\s\+','','g')
	return "+-".v:folddashes." ".printf("%2d",v:foldend-v:foldstart+1)." lines: ".vfold
endfunction


function! AddJavaCompCP()
	let jcdir=fnamemodify(globpath(&rtp,'autoload/Reflection.class'),':p:h')
	let sep=':'
	if has("win32")
		let sep=';'
	endif
	if index(split($CLASSPATH,sep),jcdir) == -1
		exe "let $CLASSPATH .= '".sep.jcdir."'"
	endif
endfunction
call AddJavaCompCP()
