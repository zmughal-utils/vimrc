function! perlpath#IsCpanfile()
	return expand("%:t") == "cpanfile"
endfunction

function! perlpath#IsFileAModule()
	return expand("%:e") == "pm"
endfunction

function! perlpath#IsFileATestScript()
	return expand("%:e") == "t"
endfunction

function! perlpath#GetModuleNameFromPath()
	return expand("%:p:s,\\C\\(.*/*\\)\\?lib/,,:s?\.pm$??:gs?/?::?")
endfunction

function! perlpath#AddToPerl5Lib(libpath)
	let list_of_paths = split($PERL5LIB, ":")
	if ! len(filter(list_of_paths, 'v:val == a:libpath'))
		let $PERL5LIB = $PERL5LIB . ":" . a:libpath
	end
endfunction
