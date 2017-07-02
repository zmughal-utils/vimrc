" Perl highlighting and folding for Function::Parameters keywords
" Maintainer:   vim-perl <vim-perl@groups.google.com>
" Installation: Put into after/syntax/perl/function-parameters.vim

let s:perl_function_parameters_keywords = [
			\ 'classmethod',
			\ 'method',
			\ 'fun',
			\ 'callback'
			\ ]
for kw in s:perl_function_parameters_keywords
	exe 'syn match perlFunction +\<' . kw  . '\>\_s*+ nextgroup=perlSubName'
endfor

if get(g:, 'perl_fold', 0)
	for kw in s:perl_function_parameters_keywords
		exe 'syn region perlSubFold  start="^\z(\s*\)\<' . kw . '\>.*[^};]$" end="^\z1}\s*\%(#.*\)\=$" transparent fold keepend'
	endfor
else
	for kw in s:perl_function_parameters_keywords
		exe 'syn region perlSubFold  start="\<' . kw . '\>[^;]*{" end="}" transparent fold extend'

		" Anonymous
		exe 'syn region perlSubFold     start="\<' . kw . '\>[^\n;]*{" end="}" transparent fold keepend extend'
	endfor
endif
