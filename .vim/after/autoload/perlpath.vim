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
	return expand("%:p:s?.*/lib/*??:s?\.pm$??:gs?/?::?")
endfunction


