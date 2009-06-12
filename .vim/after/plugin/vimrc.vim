" Vim global plugin for Vim configuration

if exists("loaded_vimrc")
	finish
endif
let loaded_vimrc=1

command CopyVim		call vimrc#Vim_cp()

let $AFTER=g:vim_script_path."/vim/vimfiles/after"
command Vim		call vimrc#Open_vimrc()
command GVim		call vimrc#Open_gvimrc()
command After		call vimrc#Open_after()
command Options		call vimrc#Open_options()
command ColorZaki	call vimrc#Open_zakicolor()

command VimNew		new +Vim
command GVimNew		new +GVim
command AfterNew	new +After
command OptionsNew	new +Options
command ColorZakiNew	new +ColorZaki

" TODO could join these together in to some function 'copyable()'
if has("unix")
	augroup cp_scripts
		au!
		autocmd BufWritePost */vim/_*vimrc		if expand("<afile>:p")=~#g:vim_script_path
		autocmd BufWritePost */vim/_*vimrc			call vimrc#Vim_cp()
		autocmd BufWritePost */vim/_*vimrc		endif

		autocmd BufWritePost */vim/vimfiles/after/*	if expand("<afile>:p")=~#g:vim_script_path
		autocmd BufWritePost */vim/vimfiles/after/*		CopyVim
		autocmd BufWritePost */vim/vimfiles/after/*	endif
	augroup END
endif
