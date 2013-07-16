" commands to create the path to a file while opening a file
" via <http://stackoverflow.com/questions/10394707/create-file-inside-new-directory-in-vim-in-one-step>
"
if exists('loaded_file_mkpath')
	finish
endif
let g:loaded_file_mkpath = 1

if exists('*mkdir')
	function! Mkdir_cond(dir)
		if !isdirectory(a:dir)
			call mkdir(a:dir,"p")
		endif
	endfunc
	command! -nargs=1 -complete=file E	call Mkdir_cond(fnamemodify(<q-args>,":h")) <Bar> e <args>
	command! -nargs=1 -complete=file New	call Mkdir_cond(fnamemodify(<q-args>,":h")) <Bar> new <args>
endif
