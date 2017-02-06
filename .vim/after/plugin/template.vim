" Templates {{{
" Opens template files in correct directory {{{
function! Read_template(type)
	if has("win32")
		let dir_pre=expand("$VIM\\vimfiles\\after\\template\\")
	elseif has("unix")
		let dir_pre=expand("~/.vim/after/template/")
	endif
	let file_name=dir_pre."template.".a:type
	if filereadable(file_name)
		execute "read ++edit ".file_name
		normal gg"_dd
		" Ugly looking
		" TODO only error is when there is an extra line at the end
	endif
endfunction
"}}}
augroup Templates "{{{
	au!
	"autocmd BufNewFile *.c		call Read_template("c")
	"autocmd BufNewFile *.h		call Read_template("h")
	"autocmd BufNewFile *.html,*.htm	call Read_template("html")
	"autocmd BufNewFile *.sh		call Read_template("sh")
	"autocmd BufNewFile *.bat	call Read_template("bat")
	"autocmd BufNewFile *.java	call Read_template("java")
	"autocmd BufNewFile *.py		call Read_template("py")
	"autocmd BufNewFile *.pl		call Read_template("pl")
	"autocmd BufNewFile *.pm		call Read_template("pm")
	"autocmd BufNewFile *.p6		call Read_template("p6")
	"autocmd BufNewFile *.mdwn	call Read_template("mdwn")
augroup END "}}}
"}}}
