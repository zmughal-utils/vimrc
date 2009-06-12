" Vim autoload file for Java

function java#Run_background()
	call command#Background(java#Run_string())
endfunction

" TODO
" (bad: make it better(automagically figure out options))
" -classpath %:p:h
function java#Run_string()
	return "java ".java#GetFullClassName()
endfunction

function java#Run()
	execute "!".java#Run_string()
endfunction

" returns the package that the current file is in
" kind of a hack
" TODO rewrite to actually parse the file
" somehow
function java#GetPackage()
	let cur=getpos(".")[1:]
	call cursor(1,1)
	let line=search('\C^package\s\+')
	if line==0
		call cursor(cur)
		return ""
	endif
	let lstr=getline(line)

	let dotpack='\(\h\w*\.\)*\(\h\w*\)'
	let regex='package\s\+'.dotpack.'\s*;'

	let s=match(lstr,regex)
	let e=matchend(lstr,regex)
	let packagepart=lstr[s : e-1]

	let s=matchend(packagepart,'package\s\+')
	let e=match(packagepart,'\s*;')
	let package=packagepart[s : e-1]

	call cursor(cur)
	return package
endfunction

function java#GetFullClassName()
	let class=expand("%:t:r")
	let pack=java#GetPackage()
	if pack!=""
		let class=pack.".".class
	endif
	return class
endfunction
