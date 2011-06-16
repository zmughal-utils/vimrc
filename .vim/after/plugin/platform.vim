if has("win32")
	command! -nargs=0 ExploreCurDir	silent execute "!start explorer ".expand(".")
	command! -nargs=0 ExploreFileDir	silent execute "!start explorer ".expand("%:p:h")
	if executable("start_session.bat")
		command! -nargs=0 Shell		silent execute "!start_session.bat"
	else
		command! -nargs=0 Shell		silent execute "!start cmd"
	endif

	command! -nargs=0 Clear		silent execute "!cls"
endif

if has("unix")
	command! -nargs=0 Shell		silent execute "!xterm&"| redraw!
	command! -nargs=0 Clear		silent execute "!clear"|redraw!
endif

nnoremap <Leader>sh	<Esc>:Shell<CR>
