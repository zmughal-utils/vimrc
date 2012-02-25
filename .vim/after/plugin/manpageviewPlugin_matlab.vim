if executable('/usr/local/bin/matlab')
	let g:manpageview_pgm_matlab = "matlab_doc"
else
	let g:manpageview_pgm_matlab = "octave_doc"
end
let g:manpageview_syntax_matlab ="txt"
autocmd FileType matlab	nno <buffer> K  :<c-u>exe v:count."Man ".expand("<cword>").".matlab"<cr>
