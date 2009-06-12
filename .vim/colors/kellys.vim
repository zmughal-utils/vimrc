" description:	color scheme based on kellys bicycles
"      author:	kamil.stachowski@gmail.com
"     license:	gpl 3+
"     version:	0.1 (2008.11.28)

" changelog:
"         0.1:	2008.11.28
"       		initial version


set background=dark

hi clear
if exists("syntax_on")
	syntax reset
endif

let colors_name = "kellys"

" blue			e6ac32
" blue slight	9ab2c8
" green			e1e338
" grey dark		555657
" grey light	e1e0e5
" green slight	d1c79e
" orange		62acce
" red			9de015

" diff*
" pmenu

hi Comment		guifg=#555657	guibg=#2a2b2f	gui=italic
hi Cursor 		guifg=#2a2b2f	guibg=#e1e0e5	gui=none
hi Constant 	guifg=#d1c79e	guibg=#2a2b2f	gui=none
hi CursorLine		          	guibg=#303132	gui=none
hi Folded 		guibg=#555657	guifg=#2a2b2f	gui=none
hi MatchParen	guibg=#2a2b2f	guifg=#e1e338	gui=bold,underline
hi ModeMsg		guifg=#e1e0e5	guibg=#2a2b2f	gui=bold
hi Normal 		guifg=#e1e0e5	guibg=#2a2b2f	gui=none
hi PreProc		guifg=#e1e338	guibg=#2a2b2f	gui=none
hi Search		guifg=#2a2b2f	guibg=#e1e0e5	gui=none
hi Special		guifg=#9ab2c8	guibg=#2a2b2f	gui=none
hi Statement	guifg=#62acce	guibg=#2a2b2f	gui=none
hi StatusLine 	guifg=#2a2b2f	guibg=#62acce	gui=bold
hi StatusLineNC guifg=#2a2b2f	guibg=#e1e0e5	gui=none
hi Todo 		guifg=#e1e0e5	guibg=#9d0e15	gui=bold
hi Type 		guifg=#e6ac32	guibg=#2a2b2f	gui=none
hi Underlined	guifg=#e1e0e5	guibg=#2a2b2f	gui=underline
hi Visual		guifg=#2a2b2f	guibg=#e1e0e5	gui=none
hi! link Boolean		Constant
hi! link Character		Constant
hi! link Conditional	Statement
hi! link CursorColumn	CursorLine
hi! link Debug			Special	
hi! link Define			PreProc
hi! link Delimiter		Special
hi! link Directory		Type
hi! link Error			Todo
hi! link ErrorMsg		Error
hi! link Exception		Statement
hi! link Float			Constant
hi! link FoldColumn		Folded
hi! link Function		Normal
hi! link Identifier		Special
hi! link Ignore			Comment
hi! link IncSearch		Search
hi! link Include		PreProc
hi! link Keyword		Statement
hi! link Label			Statement
hi! link LineNr			Comment
hi! link Macro			PreProc
hi! link MoreMsg		ModeMsg
hi! link NonText		Comment
hi! link Number			Constant
hi! link Operator		Special
hi! link PreCondit		PreProc
hi! link Question		MoreMsg
hi! link Repeat			Statement
hi! link SignColumn		FoldColumn
hi! link SpecialChar	Special
hi! link SpecialComment	Special
hi! link SpecialKey		Special
hi! link SpellBad		Error
hi! link SpellCap		Error
hi! link SpellLocal		Error
hi! link SpellRare		Error
hi! link StorageClass	Type
hi! link String			Constant
hi! link Structure		Type
hi! link Tag			Special
hi! link Title			ModeMsg
hi! link Typedef		Type
hi! link VertSplit		StatusLineNC
hi! link WarningMsg		Error

" c++
hi! link cppAccess		Type
" html
hi! link htmlArg		Statement
hi! link htmlLink		Underlined
hi! link htmlTagName	Type
" pas
hi! link pascalStatement	Type
" sh
hi! link shDerefVar		Special
hi! link shFunction		Type
" sql
hi! link sqlKeyword		Statement
" vim
hi! link vimCommand		Statement
hi! link vimEnvVar		Special
hi! link vimFuncKey		Type
hi! link vimOption		Special
hi! link vimSyntax		Special
hi! link vimSynType		Special
