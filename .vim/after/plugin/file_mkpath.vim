" commands to create the path to a file while opening a file
" via <http://stackoverflow.com/questions/10394707/create-file-inside-new-directory-in-vim-in-one-step>
"
if exists('loaded_file_mkpath')
	finish
endif
let g:loaded_file_mkpath = 1

if exists('*mkdir')
	command -nargs=1 E	call mkdir(fnamemodify(<q-args>,":h"),"p") <Bar> e <args>
	command -nargs=1 New	call mkdir(fnamemodify(<q-args>,":h"),"p") <Bar> new <args>
end
