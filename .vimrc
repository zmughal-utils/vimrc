" Vim configuration file
" Author:	Zaki Mughal

" Notes {{{
" My scripts:
" ~/flash_drive/vim/vimfiles/after
" $VIM\vimfiles\after
" cd $VIM; grep -r TODO vim/_*vimrc vim/vimfiles/after
" cd $VIM; grep -r "syntax sync" vim/_*vimrc vim/vimfiles/after
"
" TODO	* look at $VIMRUNTIME/ftplugin/vim.vim
" 	  it changes the 'textwidth'
"
" 	* :help termcap-cursor-color
"
" 	* make an include completion for Java
"
" 	* make something that highlights based on imports
" 	  and highlight function names(using parentheses)
"
" 	* make a dictionary of Java keywords
"
" 	* map something for code completion
" 	  like NetBeans
" 	* color : #30659A
" 	          #FFCB00
" StickyCursor
"}}}

set exrc

" TODO look at this
if !exists("loaded_vimrc_example")
	let loaded_vimrc_example=1
	source $VIMRUNTIME/vimrc_example.vim
endif
" My options
runtime options.vim

if isdirectory(expand("~/.vimlocal"))
	let &rtp=substitute(&rtp,",",",".expand("~/.vimlocal").",","")
endif

autocmd BufNew,BufRead,BufWritePre * setl noundofile

" No LaTeX-Suite under Debian {{{
set runtimepath-=/var/lib/vim/addons
set runtimepath-=/usr/share/vim/addons
set runtimepath-=/usr/share/vim/addons/after
set runtimepath-=/var/lib/vim/addons/after
"}}}

if !exists("vim_script_path")
	let g:vim_script_path=expand("$HOME")	" Enviroment variable is set by z.bat
endif

call pathogen#infect("bundle/{}", "bundle-vim-scripts/{}", "bundle-other/{}")

" Specific config {{{
if has("menu")
	let g:my_menu=1
endif
if has("menu") && !has("gui_running")				" see console-menus
       source $VIMRUNTIME/menu.vim
endif

" Microsoft Windows specific settings {{{
if has("win32")
	autocmd VimEnter *	if &term !=# "builtin_gui"
	autocmd VimEnter *		set encoding=utf-8
	autocmd VimEnter *	endif
	if !exists("vim_script_path")
		let g:vim_script_path=expand("$HOME")	" Enviroment variable is set by z.bat
	endif
	set spellfile+=$HOME\vim\vimfiles\spell\en.ascii.add
	let marvim_store = '$HOME\vim\vimfiles\marvim'
	if executable('grep')||executable('grep.exe')
		set grepprg=grep\ -Hn
	endif

"	source $VIMRUNTIME/mswin.vim
"	behave mswin

"	set guioptions-=mt
"	autocmd GUIEnter * simalt ~x			" Maximise the window on start
	autocmd GUIEnter * call util#NoMiddleMouse()
	"let g:browser="iexplore"
	"let javadoc_path="C:\\jdk1.5.0\\Docs\\api"
"	set path+=C:\\jdk1.5.0\\Docs\\api
"	nmap <F3> :call OpenJavadoc()<CR>
endif
"}}}
" Unix specific settings {{{
if has("unix")
	" Path to the shell script that copies the Vim scripts
	" TODO make some type of framework so you can have local
	" vimscripts, something like:
	" but maybe with a shorter name for MS-DOS
	" let localfile=expand("$MYVIMRC").".local"
	" if filereadable(localfile)
	"	exe "so ".localfile
	" endif
	"if !exists("vim_script_path")
		""let g:vim_script_path="/mnt/sda1"
		""let g:vim_script_path="/media/sdb1"
		""let g:vim_script_path=resolve($HOME."/flash_drive")
	"endif

	" $TERM=='linux' {{{
	if expand("$TERM")=~#'linux'		" TODO get this to work
		map	O2P    	<S-F1>
		map	O2Q    	<S-F2>
		map	O2R    	<S-F3>
		map	O2S    	<S-F4>
		map	[15;2~ 	<S-F5>
		map	[17;2~ 	<S-F6>
		map	[18;2~ 	<S-F7>
		map	[19;2~ 	<S-F8>
		map	[20;2~ 	<S-F9>
		map	[21;2~ 	<S-F10>
		map	[23;2~ 	<S-F11>
		map	[24;2~ 	<S-F12>
	endif
	"}}}
	" $TERM=='xterm' {{{
	if expand("$TERM")=~#'xterm'
		set mouse=a
		set encoding=utf-8
		set listchars=eol:¶,tab:»>
		set fillchars+=vert:┃
	endif
	"}}}

	set spellfile+=~/.vim/spell/en.ascii.add
	let marvim_store = '~/.vim/marvim'

	if !exists("$DISPLAY") || !executable("~/scripts/fork_see.sh")
		let g:netrw_browsex_viewer="see"
	else
		let g:netrw_browsex_viewer=expand("~/scripts/fork_see.sh")
	endif

	"	set tags+=~/.systags	" for omni-func completion
	if executable("firefox")
		let g:browser="firefox"
	elseif executable("konqueror")
		let g:browser="konqueror"
	endif
	"	set path+=~/javadocs
	augroup Xresources "{{{
		au!
		autocmd BufWritePost ~/.Xresources  !xrdb -merge ~/.Xresources
	augroup END "}}}
endif
"}}}
"}}}
"**********************************************************************************"
" Colors {{{
if !exists("loaded_color_vimrc")
	let loaded_color_vimrc=1
	if has("win32") && !has("gui")
		colorscheme blue
	else
		"if v:version==700
		"        autocmd VimEnter * if !exists("g:colors_name")|colorscheme zaki|endif
		"else
			colorscheme zaki
		"endif
	endif
	" ~/flash_drive/vim/vimfiles/after/colors/zaki.vim
	" $VIM\vimfiles\after\colors\zaki.vim
	" colorscheme baycomb
	" colorscheme default
	" colorscheme pablo
	" colorscheme koehler
endif

"}}}
"**********************************************************************************"
" Maps and Abbreviations {{{
nnoremap ,p		:setlocal path+=<C-R>=expand("%:p:h")<CR>
nnoremap <Leader>hl	:nohlsearch<CR>
nnoremap ,l		:LCD<CR>
nnoremap <Leader>nt	:NERDTreeToggle<CR>
nnoremap <Leader>bw	:bwipeout<CR>
nnoremap <Leader>bd	:bdelete<CR>

" inserts the name of the previous window
imap <C-R>w <C-R>=bufname(winbufnr(winnr('#')))<Return>

cabbr cdir	<C-R>=expand("%:p:h")<C-J>

nmap \o	o<Esc>
nmap \gf :sb <C-R>=expand("<cfile>")<CR><CR>

" Makes more sense and yy is easy enough
nnoremap Y y$

" http://groups.google.com/group/vim_use/browse_frm/thread/f9810b486df4d78
" http://vim.wikia.com/wiki/Recover_from_accidental_Ctrl-U
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" Taglist
nnoremap <silent> <F8>	:TlistToggle<CR>

" Save file
" TODO does not work on Debian Linux
noremap <S-Space>	:update<CR>
imap <S-Space>	<Esc><S-Space>
noremap <C-CR>	:update<CR>
imap <C-CR>	<Esc><C-CR>a
nnoremap ZA	:update<CR>

" GUI register
noremap \p	:put *<CR>
noremap \P	:put! *<CR>

noremap \y "*yy
vnoremap \y "*y

nnoremap <C-MiddleMouse> :put *<CR>
imap <C-MiddleMouse> <Esc><C-MiddleMouse>i

" clear line
"nmap <Leader>c 0D
" use S instead
" and <C-U>

" Switch buffers
nnoremap <silent> <F4> :bn<CR>
imap <silent> <F4> <Esc><F4>
nnoremap <silent> <S-F4> :bN<CR>
imap <silent> <S-F4> <Esc><S-F4>

" Tabs {{{
nnoremap <silent> <F3>	:tabn<CR>
imap <silent> <F3>	<Esc><F3>
nnoremap <silent> <S-F3>	:tabN<CR>
imap <silent> <S-F3>	<Esc><S-F3>

nnoremap <silent> <C-Right>	:tabn<CR>
imap <silent> <C-Right>	<Esc><F3>
nnoremap <silent> <C-Left>	:tabN<CR>
imap <silent> <C-Left>	<Esc><C-Left>

nnoremap <silent> <Leader>t	:tabnew<CR>
nnoremap <silent> <Leader>T	:tabclose<CR>
"}}}

"}}}
"**********************************************************************************"
" Autocommands {{{
augroup MyAutocmds "{{{
	au!
	" For specific files
	autocmd BufRead idea		call URL_ft()
	autocmd BufRead b		call URL_ft()
	autocmd BufRead file.txt.look	call URL_ft()

	autocmd FileType URL		URLHighlight
	autocmd FileType txt		URLHighlight
	autocmd FileType txt		let b:match_words = '<:>,“:”'

	autocmd BufRead idea		set fdm=marker
	function! IdeaFoldtext()
		let ft=foldtext()
		let num=match(ft,":\\ #\\+")
		if num==-1
			return ft
		endif
		return substitute(ft,":\\ #\\+",": ".substitute(getline(v:foldstart+1),"\\(^#\\s*\\)\\|\\(\\s*#$\\)","","g"),"")
	endfunction
	autocmd BufRead idea		setlocal foldtext=IdeaFoldtext()

	if executable('pdftotext')
		autocmd BufReadCmd	*.pdf	if filereadable(expand('<afile>'))
		autocmd BufReadCmd	*.pdf		silent exe 'silent read !pdftotext -layout '.escape(expand('<afile>'),' \&').' -'
		"autocmd BufReadCmd	*.pdf		silent let b:winview=winsaveview()
		autocmd BufReadCmd	*.pdf		silent let b:counter = 1
		autocmd BufReadCmd	*.pdf		silent exe "keepjumps g//s//\\=repeat('-',66).' [ Page '.b:counter.' ]'.''/ | let b:counter += 1"
		autocmd BufReadCmd	*.pdf		silent exe "normal g`\""
		"autocmd BufReadCmd	*.pdf		silent call winrestview(b:winview)
		"autocmd BufReadCmd	*.pdf		silent unlet b:winview
		autocmd BufReadCmd	*.pdf		setl wrap
		autocmd BufReadCmd	*.pdf		setf txt
		autocmd BufReadCmd	*.pdf	endif
	endif
	autocmd BufRead,BufEnter	*.pdf	setlocal buftype=nofile noswapfile
	autocmd BufRead,BufEnter	*.pdf	nmap <buffer>	<F6>	:call OpenPDF(expand("%"))<CR>
	"autocmd BufRead,BufEnter	*.pdf	setl nomodifiable

	" AutoHotkey

	autocmd BufRead *.class	set binary

	if has("balloon_eval")
		autocmd BufEnter *NERD_tree_	call setbufvar(expand('<afile>'),'&balloonexpr','substitute(getbufline(v:beval_bufnr,v:beval_lnum)[0],"^[|`][+~-]","","")')
	endif


	" I like to have my EOL be a '\n'
	" TODO check the events
	" if the old file did not have a name
	"autocmd BufNewFile *	set fileformat=unix

	" help zip-extension
augroup END "}}}
if !exists("loaded_zip_extensions") "{{{
	let loaded_zip_extensions=1
	au BufReadCmd *.jar,*.xpi call zip#Browse(expand("<amatch>"))
	" Monticello
	au BufReadCmd *.mcz call zip#Browse(expand("<amatch>"))
	au BufReadCmd *.odb call zip#Browse(expand("<amatch>"))
	au BufReadCmd *.odt call zip#Browse(expand("<amatch>"))
endif "}}}

" set exec bit
if has("unix")
	autocmd BufWritePost *.pl if &ft == "perl" | silent exe "!chmod +x ".fnameescape(expand('<afile>')) | endif
endif

" TODO make a ft
function! URL_ft()
	URLHighlight
	set autoindent foldmethod=indent
endfunction
" From ft-syntax-omni {{{
augroup MyAutocmds
	if has("autocmd") && exists("+omnifunc")
		autocmd Filetype *
			\	if &omnifunc == "" |
			\		setlocal omnifunc=syntaxcomplete#Complete |
			\	endif
	endif
augroup END "}}}
"}}}
"**********************************************************************************"
" Settings to do with programming {{{
" syntax sync fromstart
" When you run a program you need the full path to
" make sure you run the right program
" the program could be at the end of the $PATH

" My additions to Java syntax:
" ~/flash_drive/vim/vimfiles/after/syntax/java.vim
" $VIM\vimfiles\after\syntax\java.vim

augroup MyFileType " {{{
	au!
	autocmd FileType conf,cfg	setlocal number
	if has("win32") || has("dos32") || has("dos16")
		autocmd FileType dosbatch	setlocal keywordprg=help
	endif

	autocmd FileType c,cpp,java	let b:surround_indent=1
augroup END "}}}
"}}}
"**********************************************************************************"
" Miscellaneous functions {{{
command! -nargs=1 ExpandColumnsTo	let &columns+=(<args>-winwidth('.'))
command! -nargs=0 ExpandColumnsTo80	ExpandColumnsTo 80

command! -nargs=0 LCD		lcd %:p:h

command! -nargs=0 SouceVIMRC	so $MYVIMRC
command! -nargs=1 ReadHTTP	silent execute "read ++edit !wget -q -O - ".<args>
command! -nargs=0 UnixFile	set ff=unix nomodified
command! -nargs=0 KeywordDict	set keywordprg=dict

"}}}
"**********************************************************************************"
" Some functions {{{
" From eval-examples {{{
function! ToHex(nr)
	let n = a:nr
	let r = ""
	while n
		let r = '0123456789ABCDEF'[n % 16] . r
		let n = n / 16
	endwhile
	return r
endfunction "}}}
function! Pow(base, exp) "{{{
	let pow=1
	let i=0
	while i<a:exp
		let pow=pow*a:base
		let i=i+1
	endwhile
	return pow
endfunction "}}}
" From synID() {{{
function! SynID()
	return synIDattr(synID(line("."), col("."), 1), "name")
endfunction
command! -nargs=0 SynID	echo SynID()
"}}}
"}}}
"**********************************************************************************"
" Backgrounds {{{
command! -nargs=0 -bar Peachpuff	highlight Normal guifg=Black guibg=PeachPuff | call LightColors()
command! -nargs=0 -bar AliceBlue	highlight Normal guifg=Black guibg=AliceBlue | call LightColors()
command! -nargs=0 -bar AntiqueWhite	highlight Normal guifg=Black guibg=AntiqueWhite | call LightColors()
command! -nargs=0 -bar Khaki		highlight Normal guifg=Black guibg=khaki1 | call LightColors()
command! -nargs=0 -bar LightPurple	highlight Normal guifg=Black guibg=#EEEEFF | call LightColors()
command! -nargs=0 -bar Grey50	highlight Normal guibg=Grey50
command! -nargs=0 -bar LightYellow	highlight Normal guifg=Black guibg=#FFFFDA | call LightColors()
command! -nargs=0 -bar RedText	highlight Normal guifg=#A67A7A
function! LightColors()
	highlight CursorLine guibg=grey
	highlight CursorColumn guibg=grey75
	highlight Comment guifg=DarkCyan

	highlight Pmenu	guibg=grey50 guifg=grey96
	highlight PmenuSel guibg=grey80 guifg=white
endfunction
function! Ctermhighlight()
	highlight Normal ctermfg=Gray ctermbg=DarkGreen
	highlight Ignore ctermfg=DarkGreen
	highlight Folded ctermbg=Black
	highlight Comment ctermbg=Black
	highlight Function ctermfg=DarkRed
	highlight MatchParen ctermbg=Green
	highlight Boolean ctermfg=Magenta
endfunction
augroup ColorAdjust
	au!
	autocmd ColorScheme * highlight link Class Constant
	autocmd ColorScheme * if exists("g:colors_name") && g:colors_name=="beauty256"
	autocmd ColorScheme * 	highlight VertSplit cterm=NONE
	autocmd ColorScheme * 	highlight Todo ctermfg=120
	autocmd ColorScheme * endif
augroup END

command! -nargs=0 -bar Term256colors		if expand("$TERM")=~#'xterm'|set t_Co=256|endif
command! -nargs=0 -bar TermXTerm		let $TERM='xterm'
"}}}
"**********************************************************************************"
" Commands {{{
command! -nargs=0 -bar URLHighlight	runtime syntax/URL.vim
command! -nargs=0 -bar MakeprgReset	set makeprg&
if executable('ack-grep')
	command! -nargs=0 -bar AckGrep	set grepprg=ack-grep\ -H
endif
"if has("unix")
"        command! -nargs=0 CNERDTree		exe "NERDTree ".escape(getcwd(),' \\')
"        command! -nargs=0 CNERDTreeToggle	exe "NERDTreeToggle ".escape(getcwd(),' \\')
"elseif has("win32")
"        command! -nargs=0 CNERDTree		exe "NERDTree ".getcwd()
"        command! -nargs=0 CNERDTreeToggle	exe "NERDTreeToggle ".getcwd()
"endif
"}}}
"**********************************************************************************"
" Tabs {{{
command! -nargs=? -complete=help Help tab help <args>
" Tab open {{{
function! Tab_Open_hack(...)
	for f_args in a:000
		let file_n=glob(f_args)
		let spvar=split(file_n,'\n')
		for s in spvar
			silent exe "tabe ".s
		endfor
	endfor
endfunction
command! -nargs=+ -complete=file TabOpen call Tab_Open_hack(<f-args>)
" }}}
"}}}
"**********************************************************************************"
" Menu {{{
if has("menu") && g:my_menu==1
	autocmd VimEnter * if exists(":BufExplorer")==2
	autocmd VimEnter * 	amenu &Plugin.&Buffer\ Explorer.&BufExplorer			<Esc>:BufExplorer<CR>
	autocmd VimEnter * 	amenu &Plugin.&Buffer\ Explorer.&Horizontal\ BufExplorer	<Esc>:SBufExplorer<CR>
	autocmd VimEnter * 	amenu &Plugin.&Buffer\ Explorer.&Vertical\ BufExplorer		<Esc>:VSBufExplorer<CR>
	autocmd VimEnter * endif
	amenu M&y\ Settings.&Toggle\ back&ground	<Esc>:let &background=&background=="light"?"dark":"light"<CR>
endif
"}}}
"**********************************************************************************"
" Stuff {{{
command! -nargs=1 SetTabstops	set tabstop=<args> softtabstop=<args> shiftwidth=<args> noexpandtab 
command! Wsudo	:w !sudo tee % >/dev/null

let g:surround_{char2nr("o")}="\n\r\n\n"	" open line above and below

function! ReverseLines(line1,line2)
	let oldp=@/
	exe string(a:line1).",".string(a:line2)."g/^/m".string(a:line1-1)
	let @/=oldp
endfunction
command! -range=% -nargs=0 ReverseLines	call ReverseLines(<line1>,<line2>)
command! -nargs=0 Alphabet	call append(line("."),"abcdefghijklmnopqrstuvwxyz")
command! -range=% -nargs=0 CharCountNoHardReturns <line1>,<line2>w !perl -00 -lpE 's/\n/ /g; s/ +/ /g; $total += length $_; }{ say "Characters: $total" '

command! -nargs=0 Duplicates	/\(\<[[:alnum:]]\+\>\)\([[:space:]]\|\n\)\+\<\1\>

command! -nargs=0 PrintSize	set co? lines?
command! -nargs=0 UpdateTime	set updatetime& updatetime?

command! -nargs=0 -range=% AutoFormat <line1>,<line2>!perl -MText::Autoformat -e'autoformat({all => 1})'
command! -nargs=0 -range=% AutoFormatBreakWrap <line1>,<line2>!perl -MText::Autoformat=autoformat,break_wrap -e'autoformat({all => 1, break => break_wrap})'
command! -nargs=0 -range=% AutoFormatBreakAt <line1>,<line2>!perl -MText::Autoformat=autoformat,break_at -e'autoformat({ all => 1, break => break_at("-", { except => qr/<[^>]*>/ }) })'
command! -nargs=0 AutoFormatPara .,$!perl -MText::Autoformat -e'autoformat'
command! -nargs=0 -range=% SortNaturally <line1>,<line2>!perl -MSort::Naturally -E 'say nsort( <> )'

command! -nargs=0 -range=% PandocMtoL <line1>,<line2>!pandoc -t latex -f markdown <Bar> grep -v '\\itemsep1pt\\parskip0pt\\parsep0pt'
command! -nargs=0 -range=% PandocLtoM <line1>,<line2>!pandoc -t markdown -f latex

let RunLineChangePre=""
if has("win32")
	let RunLineChangePre='sed "s/.*/cmd \/C &/"|'
endif
exe "command! -range -nargs=0 RunCurrentLine	<line1>,<line2>w !".RunLineChangePre."sh"
nnoremap \rl	:RunCurrentLine<CR>
vnoremap \rl	:RunCurrentLine<CR>

vnoremap \wc :w !detex <Bar> wc -w<CR>
nnoremap \wc :w !detex <Bar> wc -w<CR>
vnoremap \st :w !detex <Bar> style\|$PAGER <CR>
nnoremap \st :w !detex <Bar> style\|$PAGER<CR>
command! -nargs=0 ExplodePara	'{,'}join | exe "normal O\<Esc>jo\<Esc>k" | '{,'}s/\([.?!]\)\s*/\1\r/g | exe "normal {j"

vnoremap \rc :w !recode ..dump<CR>
nnoremap \rc :w !recode ..dump<CR>

vnoremap \u :w !urlview<CR>
nnoremap \u :w !urlview<CR>

command! -nargs=0 -bar CurlyBraceFold	syntax region Curly start="{" end="}" transparent fold|set fdm=syntax

" TODO make this better
function! BC(list)
	return substitute(system("bc -l",a:list."\n"),"\\\\\n","","g")
endfunction

function! ZiptoJar(zipfile)
	if a:zipfile =~ "^zipfile:"
		return substitute(substitute(a:zipfile,"^zipfile:","jar:file://",""),"::","!/","")
	endif
	return a:zipfile
endfunction

function! JartoZip(jarfile)
	if a:jarfile =~ "^jar:file://"
		return substitute(substitute(a:jarfile,"^jar:file://","zipfile:",""),"!/","::","")
	endif
	return a:jarfile
endfunction

function! ZiptoJarThis()
	return ZiptoJar(expand("%"))
endfunction

call programming#QuickFixMaps(0)

" Supertab thing
"let g:SuperTabDefaultCompletionType = "<C-N>"
"au VimEnter *	if exists("*CtrlXPP()")
"au VimEnter *		exe "im <C-X> <C-r>=CtrlXPP()<C-J>"
""au VimEnter *		ino <C-n> <C-R>=<SID>SuperTab('n')<C-P><C-J>
""au VimEnter *		ino <C-p> <C-R>=<SID>SuperTab('p')<C-N><C-J>
"au VimEnter *	endif
"

" IndexedSearch.vim breaks things
au VimEnter *		silent! cunmap <CR>

digraph sb 8226	" Puce (bullet)
digraph !? 8253	" Interrobang
digraph ?! 8253
digraph .3 8230 " Ellipsis
digraph ~= 8773 " Approximately equal to
digraph -^ 8593 " Up arrow (down arrow is -v, right ->, left <-)

digraph =^ 8657 " Up double arrow (right =>, left <=)
digraph =v 8659 " Down double arrow


" For FuzzyFinder >= v3.0
nnoremap <Leader>rf	:FufMruFile<CR>
nnoremap <Leader>rt	:FufFileWithFullCwd<CR>

" For CtrlPSmartTabs
nnoremap <C-P><C-P>	:CtrlPSmartTabs<CR>


"if exists("g:loaded_nerd_tree")
"command! -n=? NERDTree :call s:CreateNERDTreeWin()
"function s:CreateNERDTreeWin()
"    let a:NERDTreeWinName = '_NERD_tree_'
"    "create the nerd tree window
"    let splitLocation = (g:NERDTreeWinPos == "top" || g:NERDTreeWinPos == "left") ? "topleft " : "botright "
"    let splitMode = (g:NERDTreeWinPos == 'left' || g:NERDTreeWinPos == 'right') ? "vertical " : ""
"    let splitSize = g:NERDTreeWinSize
"    let t:NERDTreeWinName = localtime() . a:NERDTreeWinName
"    let cmd = splitLocation . splitMode . splitSize . ' new ' . t:NERDTreeWinName
"    silent! execute cmd

"    setlocal winfixwidth
"endfunction
"endif

let g:LustyExplorerSuppressRubyWarning=1
let g:CSApprox_verbose_level=0

let g:project_manager_script = expand("~/sw_projects/zmughal/p5-Project-Manager/p5-Project-Manager/editor/pm.vim")
if filereadable(g:project_manager_script)
	exe "so " . g:project_manager_script
endif

let g:ikiwiki_preview_rtp = expand("~/sw_projects/ikiwiki-tavi/ikiwiki-preview/ikiwiki-preview/vim")
if isdirectory(g:ikiwiki_preview_rtp)
	exe "set rtp+=".g:ikiwiki_preview_rtp
endif

let g:otl_agenda_script = expand("~/sw_projects/zmughal/otl-parser/otl-parser/editor/vo_agenda.vim")
if filereadable(g:otl_agenda_script)
	exe "so " . g:otl_agenda_script
endif

"}}}
"**********************************************************************************"
" A.vim things {{{
augroup MyAutocmds
	autocmd VimEnter * "if hasmapto("<Leader>ih","i")
	autocmd VimEnter * 	silent! iunmap <Leader>ih
	autocmd VimEnter * 	silent! iunmap <Leader>is
	autocmd VimEnter * 	silent! iunmap <Leader>ihn
	autocmd VimEnter * "endif
augroup END
"}}}
" vim:fdm=marker
