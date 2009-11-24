" javap {{{
" NOTE Math.tan(arg) works for java.lang.Math
" TODO	Java allow the syntax to go across multiple
" lines:
" >
" java . lang  .
" Math.tan()
" <
function! JavapWord()
	let regex='\(\k\|\.\)*\%#\(\k\|\.\)*'
	let [lnum, startcol]=searchpos(regex,'n')
	let [lnum, stopcol]=searchpos(regex,'ne')
	let line=getline(lnum)
	let class=line[startcol-1:stopcol-1]
	if line[stopcol]=='(' && line[0:startcol-2]!~ ".*new\\s\\+$"
		let class=class[0:strridx(class,".")-1]
	endif
	call Javap(class)
endfunction
function! JavapClassExists(class)
	call system("javap ".a:class)
	return v:shell_error==0
endfunction

function! JavapGetClassName(class)
	let classfqn=""

	" Test current package
	let packageregex='^package\s\+'.'\(\%(\h\w*\.\)*\%(\h\w*\)\)'.'\s*;'
	let winview=winsaveview()
	call cursor(1,1)
	let [lnum, startcol]=searchpos(packageregex,'n')
	if lnum != 0
		let packageline=getline(lnum)
		let packagetest=matchlist(packageline,packageregex)[1].'.'.a:class
		call winrestview(winview)
		if JavapClassExists(packagetest)
			return packagetest	" classfqn = packagetest
		endif
	endif
	
	" Not FQN
	if !JavapClassExists(a:class) && stridx(a:class,".")==-1
		" Does it exist in java.lang.* ?
		let langtest="java.lang.".a:class
		if JavapClassExists(langtest)
			let classfqn=langtest
		else
			" Read the import statements to find if it exists in one of theme.
			let lnum = 1
			let importfqnregex='\(\%(\h\w*\.\)*\)\(\h\w*\|\*\)'
			let importregex='^import\s\+\%(static\s+\)\@!\('.importfqnregex.'\)\s*;'
			while lnum <= line("$") && classfqn==""
				let curline=getline(lnum)
				if curline =~# importregex
					let fqnpart=matchlist(curline,importregex)[1]
					let fqnlist=matchlist(fqnpart,importfqnregex)
					if fqnlist[2] == a:class
						let classfqn=fqnpart
					elseif fqnlist[2] == "*"
						let tryclass=fqnlist[1].a:class
						if JavapClassExists(tryclass)
							let classfqn=tryclass
						endif
					endif
				endif
				let lnum = lnum + 1
			endwhile
		endif
	else
		let classfqn=a:class
	endif
	if classfqn=="" || !JavapClassExists(classfqn)
		echohl WarningMsg
		echo "The class '".a:class."' was not found"
		echohl None
		return
	endif
	return classfqn
endfunction

command! -nargs=1 Javap	call Javap(<f-args>)
function! Javap(class)
	let classfqn=JavapGetClassName(a:class)
	if classfqn !~ '.*'.a:class.'$'
		return
	endif
	let bn="~/".classfqn
	if !bufexists(bufname(expand(bn)))
		silent exe "new +r!javap\\ ".classfqn
		normal G"_ddgg"_dd
		silent %s/\s\{7,7\}/\t/ge
		setlocal nomod noma
		setf java
		lcd ~
		silent exe "file ".classfqn
	else
		silent exe "new ".bn
	endif
endfunction
" }}}
	autocmd FileType java	vnoremap <buffer> \jp y:Javap <C-R>"<CR>
	autocmd FileType java	nnoremap <buffer> \jp :call JavapWord()<CR>
