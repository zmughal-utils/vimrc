" Vim autoload file for Vim configuration

function vimrc#Vim_cp()					" After I change setting for Vim on my flash drive, copy them to my $HOME
	let copyscript=escape(g:vim_script_path,' ')."/.vim_cp.sh"
	if executable(copyscript) 
		silent execute "!".copyscript
	else
		silent execute "!sh ".copyscript
	endif
	echo "Files copied"
endfunction

function vimrc#Open_vimrc()				" Opens the correct vimrc
	silent execute "edit ".escape(substitute(g:vim_script_path,'[/\\]$','',''),' ')."/.vimrc"
endfunction

function vimrc#Open_gvimrc()				" Opens the correct gvimrc
	silent execute "edit ".escape(substitute(g:vim_script_path,'[/\\]$','',''),' ')."/.gvimrc"
endfunction

function vimrc#Open_after()				" Opens after directory
	silent execute "edit ".escape(substitute(g:vim_script_path,'[/\\]$','',''),' ')."/.vim/after"
endfunction

function vimrc#Open_options()				" Opens my options
	silent execute "edit ".escape(substitute(g:vim_script_path,'[/\\]$','',''),' ')."/.vim/after/options.vim"
endfunction

function vimrc#Open_zakicolor()				" Opens my colorscheme
	silent execute "edit ".escape(substitute(g:vim_script_path,'[/\\]$','',''),' ')."/.vim/after/colors/zaki.vim"
endfunction
