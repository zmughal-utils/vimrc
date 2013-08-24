setlocal isfname+=],[,(,),34
"setlocal include=\\c^\\s*include\\s\\+\\zs\\(\\f\\\|[()\\[\\]\"]\\)\\+
setlocal include=\\c^\\s*include
setlocal commentstring=#%s

function! RemindIncExpr(name)
	let remind_expr = system("remind -k'echo -n %s' -", a:name)
	let cleanup = substitute(l:remind_expr, ' $','','')
	let cleanup = substitute(l:cleanup, '^\.', expand("%:p:h"), '')
	return cleanup
endfunction
setlocal includeexpr=RemindIncExpr(v:fname)
