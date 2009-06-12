" Vim color file
" Maintainer:	Zaki Mughal

set background=dark
highlight clear
" help cterm-colors

if exists("syntax_on")
	syntax reset
endif
let g:colors_name="zaki"

" let background=synIDattr(synIDtrans(hlID("Normal")), "bg"))
" TODO add something to allow the user to choose a background color
" help highlight-groups
highlight Normal					ctermbg=Black		ctermfg=Grey				guibg=Black		guifg=White
" highlight Normal					ctermbg=Black		ctermfg={8,9}				guibg=Black		guifg=White
highlight Visual	term=reverse	cterm=none	ctermbg=fg		ctermfg=bg				guibg=fg		guifg=bg

" Check for cterm background
highlight StatusLine					ctermbg=DarkBlue	ctermfg=Blue		gui=reverse	guibg=Aquamarine2	guifg=SeaGreen
highlight StatusLineNC					ctermbg=DarkGrey	ctermfg=Grey				guibg=Lavender		guifg=SlateGrey
if $TERM=="xterm"|highlight StatusLine ctermbg=green cterm=none|endif

"highlight CursorLine			cterm=none	ctermbg=LightBlue						guibg=#0045CD
highlight CursorLine	term=reverse	cterm=reverse	ctermbg=DarkGrey						guibg=Grey35
highlight CursorColumn	term=reverse	cterm=reverse	ctermbg=DarkGrey						guibg=Grey38
highlight WarningMsg	term=standout	cterm=none 				ctermfg=DarkRed							guifg=Red

highlight TabLine								ctermfg=DarkRed
highlight TabLineSel					ctermbg=DarkBlue	ctermfg=Grey		gui=none	guibg=bg		guifg=fg
" Making the background of TabLineSel the same as the Normal background looks nice as well.
highlight TabLineFill					ctermbg=Grey		ctermfg=none							guifg=Grey

highlight LineNr								ctermfg=Blue							guifg=#1DC0FF
highlight Folded					ctermbg=none		ctermfg=DarkGreen			guibg=bg		guifg=#12D71F
highlight FoldColumn					ctermbg=DarkGrey	ctermfg=Green				guibg=DarkGrey		guifg=SpringGreen1
"highlight Folded ctermbg=none ctermfg=4
highlight Pmenu						ctermbg=DarkBlue						guibg=SlateBlue
highlight PmenuSel			cterm=bold	ctermbg=Cyan		ctermfg=Black				guibg=DarkBlue

" help group-name
highlight Comment								ctermfg=DarkCyan						guifg=#00C4C4

highlight Constant								ctermfg=DarkMagenta						guifg=#0468FF
highlight String								ctermfg=DarkMagenta						guifg=#1E72A0
highlight Character								ctermfg=DarkMagenta						guifg=#C74547
highlight Number								ctermfg=Blue							guifg=#4372D7
highlight Boolean								ctermfg=DarkGreen						guifg=#4CC76F
"highlight Float									ctermfg=Blue							guifg=#2F82DC
highlight Function	term=none	cterm=none				ctermfg=Green							guifg=#358f53
highlight Function	term=none	cterm=none
"	Constant	any constant
"	String		a string constant: "this is a string"
"	Character	a character constant: 'c', '\n'
"	Number		a number constant: 234, 0xff
"	Boolean	a boolean constant: TRUE, false
"	Float		a floating point constant: 2.3e10
"
highlight Identifier			cterm=none				ctermfg=DarkMagenta	gui=NONE				guifg=#009090
"	Identifier	any variable name
"	Function	function name (also: methods for classes)
"
highlight Statement								ctermfg=Green							guifg=#C88EEE
" TODO sometimes I want it to be DarkYellow and sometimes Yellow because
" DarkYellow sometimes looks like orange
"	Statement	any statement
"	Conditional	if, then, else, endif, switch, etc.
"	Repeat		for, do, while, etc.
"	Label		case, default, etc.
"	Operator	"sizeof", "+", "*", etc.
"	Keyword	any other keyword
"	Exception	try, catch, throw
"
"	PreProc	generic Preprocessor
"	Include	preprocessor #include
"	Define		preprocessor #define
"	Macro		same as Define
"	PreCondit	preprocessor #if, #else, #endif, etc.
"
highlight Type																	guifg=#33CC66
"	Type		int, long, char, etc.
"	StorageClass	static, register, volatile, etc.
"	Structure	struct, union, enum, etc.
"	Typedef	A typedef
" I made this one up.
highlight Class									ctermfg=DarkRed							guifg=#EC91C5
"
"	Special	any special symbol
highlight SpecialChar								ctermfg=Red							guifg=#FF3399
"	SpecialChar	special character in a constant
"	Tag		you can use CTRL-] on this
"	Delimiter	character that needs attention
"	SpecialComment	special things inside a comment
"	Debug		debugging statements
"
"	Underlined	text that stands out, HTML links
"
"	Ignore		left blank, hidden
"
"highlight Error
"	Error		any erroneous construct
"
highlight Todo						ctermbg=DarkRed		ctermfg=Magenta				guibg=#61AEBE		guifg=#004040
"	Todo		anything that needs extra attention; mostly the
"			keywords TODO FIXME and XXX
