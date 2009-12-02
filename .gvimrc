" GVIM configuration file
" Author:	Zaki Mughal

set guioptions-=e	" no GUI tabs
set guioptions-=L
set guioptions-=c
set guioptions-=m
set guioptions-=T
set nohlsearch
call util#No_bells()

let g:font_menu=1
" Unix font menu
if has("menu") && g:my_menu==1 && g:font_menu==1 && has("unix")
	amenu M&y\ Settings.F&ont.Courier.10pt	<Esc>:set guifont=Courier\ 10<CR>
	amenu M&y\ Settings.F&ont.Courier.12pt	<Esc>:set guifont=Courier\ 12<CR>

	amenu M&y\ Settings.F&ont.Fixed.8pt	<Esc>:set guifont=Fixed\ 8<CR>
	amenu M&y\ Settings.F&ont.Fixed.9pt	<Esc>:set guifont=Fixed\ 9<CR>
	amenu M&y\ Settings.F&ont.Fixed.10pt	<Esc>:set guifont=Fixed\ 10<CR>
	amenu M&y\ Settings.F&ont.Fixed.12pt	<Esc>:set guifont=Fixed\ 12<CR>

	amenu M&y\ Settings.F&ont.Lucida\ Typewriter.8pt	<Esc>:set guifont=LucidaTypewriter\ 8<CR>
	amenu M&y\ Settings.F&ont.Lucida\ Typewriter.9pt	<Esc>:set guifont=LucidaTypewriter\ 9<CR>
	amenu M&y\ Settings.F&ont.Lucida\ Typewriter.10pt	<Esc>:set guifont=LucidaTypewriter\ 10<CR>

	"amenu M&y\ Settings.F&ont.Monospace.10pt <Esc>:set guifont=Monospace\ 10<CR>

	amenu M&y\ Settings.F&ont.Terminal.10pt	<Esc>:set guifont=Terminal\ 10<CR>

	amenu M&y\ Settings.F&ont.Terminus.10pt	<Esc>:set guifont=Terminus\ 10<CR>
endif
" GUI Win32 font menu
if has("menu") && g:my_menu==1 && g:font_menu==1 && has("gui_win32")
	amenu M&y\ Settings.F&ont.Courier\ New.8pt	<Esc>:set guifont=Courier_New:h8<CR>
	amenu M&y\ Settings.F&ont.Courier\ New.10pt	<Esc>:set guifont=Courier_New:h10<CR>

	amenu M&y\ Settings.F&ont.Lucida\ Console.8pt		<Esc>:set guifont=Lucida_Console:h8<CR>
	amenu M&y\ Settings.F&ont.Lucida\ Console.10pt	<Esc>:set guifont=Lucida_Console:h10<CR>
endif

" GUI only menu
if has("menu") && g:my_menu==1
	let g:load_WinManip_menu=1
endif

if has("unix")
	"if v:version==700
		"set guifont=-rfx-fixed-medium-r-semicondensed-*-*-120-*-*-c-*-microsoft-cp1251
		"set guifont=Courier\ 10\ Pitch\ 10
		if !exists("g:loaded_gvimrc") || g:loaded_gvimrc!=1
			"set guifont=Fixed\ 10
			"set guifont=Fixed\ 8
			set guifont=Terminus\ 8
			"set guifont=Courier\ New\ 8
		endif
		"set showtabline=2
		set fillchars+=vert:┃
	"else
		"set guifont=Courier\ 12
	"endif
	if filereadable(expand("~/scripts/xterm_man.sh"))
		set keywordprg=~/scripts/xterm_man.sh
	endif
endif

if has("gui_win32")
	if !exists("g:loaded_gvimrc") || g:loaded_gvimrc!=1
		set guifont=Courier\ New:h8:cANSI
	endif
	if g:my_menu==1
		amenu MSWin.Maximize	<Esc>:simalt ~x<CR>
		amenu MSWin.Restore	<Esc>:simalt ~r<CR>
		amenu MSWin.Minimize	<Esc>:simalt ~n<CR>
	endif
endif

runtime! optload/colorsel.vim

let g:loaded_gvimrc=1
