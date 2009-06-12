"  vim: set sw=4 sts=4:
"  Maintainer	: Gergely Kontra <kgergely@mcl.hu>
"  Revised on	: 2002.02.18. 23:34:05
"  Language	: Prolog

" TODO:
"   checking with respect to syntax highlighting
"   ignoring multiline comments
"   detecting multiline strings

" Only load this indent file when no other was loaded.
"if exists("b:did_indent")
"    finish
"endif

let b:did_indent = 1

setlocal indentexpr=GetPrologIndent()
setlocal indentkeys-=:,0#
setlocal indentkeys+=0%,-,0;,>,0)

" Only define the function once.
"if exists("*GetPrologIndent")
"    finish
"endif

" TODO
" needs a more thorough check of syntax
" such as ->/2 conditional
function! GetPrologIndent()
    if InPrologComment(v:lnum,2)
	return cindent(v:lnum)
    endif

    " Find a non-blank line above the current line.
    let pnum = prevnonblank(v:lnum - 1)
    " that is not in a comment
    "if !InPrologComment(v:lnum,0)
	while pnum>0 && InPrologComment(pnum,0)
	    let pnum = prevnonblank(pnum - 1)
	endwhile
    "endif

    " Hit the start of the file, use zero indent.
    if pnum == 0
       return 0
    endif
    let line = getline(v:lnum)
    let pline = getline(pnum)

    let ind = indent(pnum)
    "" Previous line was comment -> use previous line's indent
    if pline =~ '^\s*%'
       retu ind
    endif
    " Check for clause head on previous line
    if pline =~ ':-\s*\(%.*\)\?$'
	let ind = ind + &sw
    elseif pline =~ ':-\s*.*,\(%.*\)\?$'
	let ind = ind + &sw
    " Check for end of clause on previous line
    elseif pline =~ '\.\s*\(%.*\)\?$'
	"let ind = ind - &sw
	let ind = 0
    endif
    " Check for opening conditional on previous line
    if pline =~ '^\s*\([(;]\|->\)'
	let ind = ind + &sw
    endif
    " Check for closing an unclosed paren, or middle ; or ->
    if line =~ '^\s*\([);]\|->\)'
	let ind = ind - &sw
    endif
    return ind
endfunction

function! InPrologComment(line,which)
    if a:line>line('$') || a:line<1
	return 0
    endif
    let ccomment=synIDattr(synID(a:line,match(a:line,'\S')+1,1),"name")=='prologCComment'
    let comment=synIDattr(synID(a:line,match(a:line,'\S')+1,1),"name")=='prologComment'
    return ((a:which==0 || a:which==1) && comment) || ((a:which==0 || a:which==2) && ccomment)
    "let theline=getline(a:line)
    "let nonb=match(theline,'\S')
    ""theline[nonb]
    "let name=synIDattr(synID(a:line,1,1), "name")
    ""echoerr name." ".theline
    "if a:which==1 && name=='prologComment'
    "    return 1
    "endif
    "if a:which==2 && name=='prologCComment'
    "    return 1
    "endif
    "if a:which==0 && (name=='prologComment' || name=='prologCComment')
    "    return 1
    "endif
    "return 0
endfunction
