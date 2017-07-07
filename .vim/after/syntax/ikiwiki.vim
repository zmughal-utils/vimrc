if exists("b:current_syntax")
	unlet b:current_syntax
endif
"syn include @PlantUML syntax/plantuml.vim
"syn region ikiDirUml start=+\[\[\!uml src="""\zs+ end=+\ze"""\]\]+ contains=@PlantUML fold skipnl
