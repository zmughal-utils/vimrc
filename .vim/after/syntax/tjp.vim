let s:tjp_file = "/usr/share/taskjuggler/data/tjp.vim"
if filereadable(s:tjp_file)
	exe "so ".s:tjp_file
endif
