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

" Disable syntastic for now
let g:loaded_syntastic_plugin = 1

" No LaTeX-Suite under Debian {{{
set runtimepath-=/var/lib/vim/addons
set runtimepath-=/usr/share/vim/addons
set runtimepath-=/usr/share/vim/addons/after
set runtimepath-=/var/lib/vim/addons/after
"}}}

if !exists("vim_script_path")
	let g:vim_script_path=expand("$HOME")	" Enviroment variable is set by z.bat
endif

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
	autocmd BufNewFile *.c		call Read_template("c")
	autocmd BufNewFile *.html,*.htm	call Read_template("html")
	autocmd BufNewFile *.sh		call Read_template("sh")
	autocmd BufNewFile *.bat	call Read_template("bat")
	autocmd BufNewFile *.java	call Read_template("java")
	autocmd BufNewFile *.py		call Read_template("py")
augroup END "}}}
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

cabbr cdir	<C-R>=expand("%:p:h")<C-J>

nmap \o	o<Esc>

" Makes more sense and yy is easy enough
nnoremap Y y$

" http://groups.google.com/group/vim_use/browse_frm/thread/f9810b486df4d78
" http://vim.wikia.com/wiki/Recover_from_accidental_Ctrl-U
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

if &term =~# "screen"
	map [1;2P	<S-F1>
	map [1;2Q	<S-F2>
	map [1;2R	<S-F3>
	map [1;2S	<S-F4>
	map [15;2~	<S-F5>
	map [17;2~	<S-F6>
	map [18;2~	<S-F7>
	map [19;2~	<S-F8>
	map [20;2~	<S-F9>
	map [21;2~	<S-F10>
	map [23;2~	<S-F11>
	map [24;2~	<S-F12>
endif

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

" Swap words
" http://vim.wikia.com/wiki/Exchanging_adjacent_words
nnoremap <silent> ,sw	:call SwapWords()<CR>
function! SwapWords()
	let lastpat = @/
	silent exe "normal m`"
	silent s/\v(<\k*%#\k*>)(\_.{-})(<\k+>)/\3\2\1/
	silent exe "normal g``"
	let @/ = lastpat
endfunction

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

if exists("*strftime")
	if has("win32")
		let strftime_iso_fmt="%Y-%m-%d"
		let strftime_time_fmt="%H:%M:%S"
	else
		let strftime_iso_fmt="%F"
		let strftime_time_fmt="%T"
	endif
	let strftime_isotime_fmt=strftime_iso_fmt." ".strftime_time_fmt
	inoreabbr xdate	<C-R>=strftime("%a %Y %b %d")<CR>
	inoreabbr xiso	<C-R>=strftime(strftime_iso_fmt)<CR>
	inoreabbr xtime	<C-R>=strftime(strftime_time_fmt)<CR>
	inoreabbr xfulltd	<C-R>=strftime(strftime_isotime_fmt)<CR>
	inoreabbr xfiletd	<C-R>=strftime(strftime_isotime_fmt,getftime(expand('%')))<CR>
endif
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
		autocmd BufReadCmd	*.pdf		silent exe "keepjumps %s//".repeat('-',66)."/g"
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
	autocmd BufRead *.ahk	setf ahk

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
	au BufReadCmd *.odb call zip#Browse(expand("<amatch>"))
	au BufReadCmd *.odt call zip#Browse(expand("<amatch>"))
endif "}}}

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
	autocmd FileType c	autocmd QuickFixCmdPost <buffer> call AutoOpenQF(0)
	autocmd FileType c	call PreviewMaps()

	" C++
	autocmd FileType cpp	autocmd QuickFixCmdPost <buffer> call AutoOpenQF(0)
	autocmd FileType cpp	compiler gcc
	autocmd FileType cpp	call PreviewMaps()

	autocmd FileType c,cpp,java	let b:surround_indent=1

	autocmd FileType cpp	if !filereadable('Makefile')
	autocmd FileType cpp	if has("win32") | let exeext=".exe" | else | let exeext="" | endif
	autocmd FileType cpp		exe 'setlocal makeprg=g++\ -o\ %:r'.exeext.'\ %\ -Wall'
	autocmd FileType cpp	endif

	autocmd FileType html	vmap <buffer> ,del s<del datetime="<C-R>=strftime('%Y-%m-%dT%H:%M:%S%z')<CR>"<CR>
	autocmd FileType html	vmap <buffer> ,ins s<ins datetime="<C-R>=strftime('%Y-%m-%dT%H:%M:%S%z')<CR>"<CR>

	autocmd FileType sh	nnoremap <buffer> <F6>	:call SheBangRun()<CR>

	autocmd FileType remind setlocal isfname+=],[,(,),34
	"autocmd FileType remind setlocal include=\\c^\\s*include\\s\\+\\zs\\(\\f\\\|[()\\[\\]\"]\\)\\+
	autocmd FileType remind setlocal include=\\c^\\s*include
	autocmd FileType remind setlocal includeexpr=substitute(system(\"remind\ -k\'echo\ -n\ %s\'\ -\",v:fname),'\ $','','')

	autocmd FileType mail	setlocal spell
augroup END "}}}
let g:alternateExtensions_CXX = "HXX,hxx"
let g:alternateExtensions_HXX = "CXX,cxx"
let g:alternateExtensions_cxx = "hxx,HXX"
let g:alternateExtensions_hxx = "cxx,CXX"
"}}}
"**********************************************************************************"
" Java {{{
"let g:omni_syntax_group_include_java = 'javaC_,javaR_,javaE_,javaX_'
augroup Java "{{{
	au!
	autocmd FileType java	nnoremap <buffer> <F9> :!ctags --languages=java -R .<CR>
	autocmd FileType java	autocmd QuickFixCmdPost <buffer> call AutoOpenQF(0)
	autocmd FileType java	setlocal omnifunc=javacomplete#Complete
				\ completefunc=syntaxcomplete#Complete
	" Too annoyingly slow
	"autocmd FileType java	imap <buffer> . .<C-X><C-O><C-P>
	if has("menu")
		autocmd FileType java	amenu PopUp.Goto\ tag :exe "ptag ".expand("<cword>")<CR>
	endif
	autocmd FileType java	setl foldtext=JavaFoldText()
	"{{{ Java abbrevs
	"autocmd FileType java	inoreabbr <buffer> sop	System.out.println();<C-O>1h
	"autocmd FileType java	inoreabbr <buffer> sopf	System.out.printf("\n",)<C-O>4h

	"autocmd FileType java	inoreabbr <buffer> println	System.out.println();<C-O>1h
	"autocmd FileType java	inoreabbr <buffer> printf	System.out.printf("\n",);<C-O>1h
	"autocmd FileType java	inoreabbr <buffer> print	System.out.print();<C-O>1h
	"}}}
augroup END "}}}

function! JavaFoldText()
	let curline=v:foldstart
	let removestring='\/\*\*\=\|\*\/\|\/\/\|{'.
				\ '{{\d\=\|^\s*\*\s*'
	let empty="^\\s*$"
	let vfold=substitute(getline(curline),removestring,'','g')
	while(curline<=v:foldend && vfold=~empty)
		let vfold=substitute(getline(curline),removestring,'','g')
		let curline+=1
	endwhile
	if curline==v:foldend && vfold=~empty
		let vfold=getline(v:foldstart)
	endif
	let vfold=substitute(vfold,'^\s\+','','g')
	return "+-".v:folddashes." ".printf("%2d",v:foldend-v:foldstart+1)." lines: ".vfold
endfunction


function! AddJavaCompCP()
	let jcdir=fnamemodify(globpath(&rtp,'autoload/Reflection.class'),':p:h')
	let sep=':'
	if has("win32")
		let sep=';'
	endif
	if index(split($CLASSPATH,sep),jcdir) == -1
		exe "let $CLASSPATH .= '".sep.jcdir."'"
	endif
endfunction
call AddJavaCompCP()

function! Javadoc(classname)
	let tmpfile = tempname()
	if executable("findjavadoc.sh")
		exe "!findjavadoc.sh ".a:classname.">".tmpfile
		if filereadable(tmpfile)
			exe "silent! new ".tmpfile
			let fqn=getline(1)
			if bufexists(fqn)
				let delnr=bufnr(fqn)
				exe delnr."bd"
			endif
			exe "silent! keepalt file ".fqn
			normal gg
			exe "autocmd BufEnter ".fqn."setlocal buftype=nowrite"
			exe "autocmd BufEnter ".fqn."setlocal nomod noma noswapfile"
			exe "autocmd BufEnter ".fqn."setlocal nomod noma noswapfile"
			exe "autocmd BufEnter ".fqn."nmap <buffer> <C-]>	:call JavapWord()<CR>"

		endif
	else
		echoerr "Error [Javadoc]: findjavadoc.sh is not in your path."
	endif
endfunction
nmap <silent> \jd :call Javadoc(expand("<cword>"))<CR>
"}}}
"**********************************************************************************"
" TeX {{{
command! -nargs=0 PDFTeX	let &l:makeprg= 'pdftex -interaction=nonstopmode'
command! -nargs=0 PDFLaTeX	let &l:makeprg= 'pdflatex -interaction=nonstopmode'
command! -nargs=0 LaTeX		let &l:makeprg= 'latex -interaction=nonstopmode'
augroup MyFileType
	autocmd FileType tex	nnoremap <buffer>	<F6>	:call TeXSmartOpen()<CR>
	autocmd FileType tex	imap	<buffer>	<F6>	<Esc><F6>
	autocmd FileType tex	if &makeprg!='make' && executable("pdflatex")|exe "PDFLaTeX"|endif
	autocmd FileType tex	let b:surround_69 = "\\[\r\\]"
	autocmd FileType tex	let b:surround_101 = "\\(\r\\)"
augroup END
"if has('win32') &&  executable('yap.exe') "{{{
"	command! -nargs=1 -complete=file Yap	silent !start yap -1 <args>
"	augroup MyFileType
"		autocmd FileType tex	nnoremap <buffer>	<F6>	:Yap %:r<CR>
"		autocmd FileType tex	imap	<buffer>	<F6>	<Esc><F6>
"	augroup END
"endif "}}}

command! -nargs=0 TeXSubstituteEmDash	%s/\%u2014/---/gc
command! -nargs=0 TeXSubstituteEnDash	%s/\%u2013/--/gc

function! TeXSmartOpen() "{{{
	let curfile=expand("%")
	let p_pdf=fnamemodify(curfile,":r").".pdf"
	let p_dvi=fnamemodify(curfile,":r").".dvi"
	let p_ps =fnamemodify(curfile,":r").".ps"
	let p_files=[p_pdf, p_dvi, p_ps]
	for vfile in p_files
		if filereadable(vfile)
			if has("win32")
				if vfile =~ '.*\.pdf'
					call OpenPDF(vfile)
				else
					call command#Background("see ".vfile)
				endif
			elseif has("unix") && exists("$DISPLAY")
				exe "!see '".vfile."' &"
			endif
			break	" first readable
		endif
	endfor
endfunction "}}}
"}}}
"**********************************************************************************"
" Miscellaneous functions {{{
function! Test() "{{{
	let javapath="~/javadocs"
	let sub=substitute(expand("<cfile>"),"\\.","/","g")
	let fullpath=javapath."/".sub.".html"
	execute "!".g:browser." ".fullpath
endfunction "}}}

function! OpenPDF(pdffile)
	if filereadable(a:pdffile)
		if has("win32")
			if !exists('g:pdf_viewer')
				if executable('SumatraPDF')
					call command#Background("start SumatraPDF \"".a:pdffile."\"")
				else
					call command#Background("see ".a:pdffile)
				endif
			else
				call command#Background(g:pdf_viewer." ".a:pdffile)
			endif
		elseif has("unix") && exists("$DISPLAY")
			exe "!see '".a:pdffile."' &"
		endif
	endif
endfunction

" Window things {{{
function! DefaultSize()
	" TODO	does 'set columns& lines&' work for everything?
	if has("win32") || expand("$TERM")=~#'linux'
		set columns=80 lines=25
	else	" X11
		set columns=80 lines=24
	endif
endfunction
command! -nargs=0 DefaultSize	call DefaultSize()
command! -nargs=0 OrigSize	set lines& columns&
command! -nargs=0 Size	set columns=120 lines=70

command! -nargs=0 VSize	set columns=80 lines=60

command! -nargs=0 WSize	set columns=125 lines=40

command! -nargs=0 CenterandWSize winpos 125 70|WSize

command! -nargs=0 MoveToCorner	winpos 0 0

if has("gui")
	function! ToggleFullscreen()
		if has("gui")
			let l:saved_l=&lines
			let l:saved_c=&columns
			let l:guiopt=(match(&guioptions,'\C[mTrl]')>0)
			if l:guiopt
				let &guioptions=substitute(&guioptions,"\\C[mTrl]","","g")
			else
				set guioptions+=mTr
			endif
			sleep 200m
			let &lines=l:saved_l
			let &columns=l:saved_c
		endif
	endfunction
	nnoremap <silent>	<Leader>fs	:call ToggleFullscreen()<CR>
endif

command! -nargs=1 ExpandColumnsTo	let &columns+=(<args>-winwidth('.'))
command! -nargs=0 ExpandColumnsTo80	ExpandColumnsTo 80

function! Rxvt_ip()
	let i=0
	while i<2
		highlight Normal ctermbg=none
		let i=i+1
	endwhile
endfunction
" }}}

command! -nargs=0 LCD		lcd %:p:h

" Perldoc {{{
function! Perldoc(doc)
	exe 'silent new +r!perldoc\ -T\ '.shellescape(a:doc)
	while getline(1)=~'^\s*$'
		silent normal gg"_dd
	endwhile
	while getline('$')=~'^\s*$'
		silent normal G"_dd
	endwhile
	setlocal nomodifiable buftype=nofile noswapfile
	exe "file ".a:doc." [perldoc]"
	"setf man
	runtime! syntax/man.vim
endfunction
command! -nargs=1 Perldoc	call Perldoc(<f-args>)
"}}}

com! PerlCore	!corelist <cword>
autocmd FileType perl	nmap <buffer> ,pc	:PerlCore<Return>

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

let g:utl_cfg_hdl_mt_application_pdf__xpdf="call Utl_if_hdl_mt_application_pdf_xpdf('%p', '%f')"
fu! Utl_if_hdl_mt_application_pdf_xpdf(path,fragment)
	if !filereadable(a:path)
		redraw | echom "File '".a:path."' not found"
		return
	endif
	let page = ''
	if a:fragment != ''
		let ufrag = UtlUri_unescape(a:fragment)
		if ufrag =~ '^page='
			let page = substitute(ufrag, '^page=', '', '')
		else 
			echohl ErrorMsg
			echo "Unsupported fragment `#".ufrag."' Valid only `#page='"
			echohl None
			return
		endif
	endif

	let cmd = ':silent !xpdf -q '.'"'.a:path.'"'.' '.l:page.' &'
	exe cmd
endfu
if has("unix")
	command! -nargs=0 Shell		silent execute "!xterm&"| redraw!
	command! -nargs=0 Clear		silent execute "!clear"|redraw!
	if exists("$DISPLAY")
		let g:utl_cfg_hdl_scm_http="silent !firefox '%u' &"
	else
		let g:utl_cfg_hdl_scm_http="silent !lynx '%u'"
	endif
	let g:utl_cfg_hdl_mt_application_pdf = g:utl_cfg_hdl_mt_application_pdf__xpdf
	let g:utl_cfg_hdl_mt_generic = "silent !see '%p'"
endif


nnoremap <Leader>sh	<Esc>:Shell<CR>

command! -nargs=0 SouceVIMRC	so $MYVIMRC
command! -nargs=1 ReadHTTP	silent execute "read ++edit !wget -q -O - ".<args>
command! -nargs=0 UnixFile	set ff=unix nomodified
command! -nargs=0 KeywordDict	set keywordprg=dict

" Toggle {{{
command! -nargs=0 SpellToggle	setl spell! spell?
nnoremap <silent>	,ts	:SpellToggle<CR>
command! -nargs=0 PasteToggle	setl paste! paste?
nnoremap <silent>	,tp	:PasteToggle<CR>
command! -nargs=0 ListToggle	setl list! list?
nnoremap <silent>	,tl	:ListToggle<CR>
command! -nargs=0 NumberToggle	setl number! number?
nnoremap <silent>	,tn	:NumberToggle<CR>
command! -nargs=0 CursorLineToggle	setl cursorline! cursorline?
nnoremap <silent>	,tcl	:CursorLineToggle<CR>
command! -nargs=0 WrapToggle	setl wrap! wrap?
nnoremap <silent>	,tw	:WrapToggle<CR>
" }}}
"}}}
"**********************************************************************************"
" Statusline and Ruler {{{
" TODO make ruler
let g:alt_ft_txt='text'
let g:alt_ft_dosbatch='DOS Batch file'
let g:alt_ft_html='HTML'
let g:alt_ft_css='CSS'
let g:alt_ft_tex='TeX'
let g:alt_ft_make='Makefile'
let g:alt_ft_man='Man page'
let g:alt_ft_cpp='C++'
set statusline=%<%f\ %{SLFiletype()}%h%{'['.&ff.']'}%{SLModified()}%r%=%-14.(%l,%c%V%)\ %P
function! SLFiletype()
	if strlen(&ft)>0 &&  &ft !=# 'help'
		let filev=&ft
		if exists("g:alt_ft_{&ft}")
			let filev=g:alt_ft_{&ft}
		endif
		return '['.substitute(filev,'.','\u&','').']'
	endif
	return ''
endfunction
function! SLModified()
	if &modified
		return "[+]"
	endif
	return ""
endfunction
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
" Close Buffers {{{
function! CloseWastedBuffers(method)
	let last_buffer=bufnr("$")
	let cur_buffer=bufnr("%")
	let i=1
	while i<=last_buffer
		if i!=cur_buffer && bufexists(i) && bufname(i) == "" && !getbufvar(i, "&modified")
			call CloseBuff(a:method,i)
		endif
		let i=i+1
	endwhile
endfunction
command! -nargs=0 CloseBuffersDel	call CloseWastedBuffers(0)
command! -nargs=0 CloseBuffersWipe	call CloseWastedBuffers(1)
function! CloseOtherBuffers(method)
	let cur_buffer=bufnr("%")
	bufdo	if bufnr("%")!=cur_buffer |try|call CloseBuff(a:method,-1)|catch|echo "Could not close ".bufname("%")|endtry|endif
endfunction

function! CloseBuff(method,number)
	let num=string(a:number)
	if !bufexists(a:number)
		if a:number==-1
			let num=""
		else
			return
		endif
	endif

	let meth=""
	if a:method==0
		let meth="bdelete"
	elseif a:method==1
		let meth="bwipeout"
	endif
	if meth!=""
		try
			exe num.meth
		catch
		endtry
	endif
endfunction
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
" To own tab {{{
" Only side effect would be winnr in target tabpage
function! ToOwnTab(tabpage,winnr)
	if a:tabpage>tabpagenr("$")
		return 1
	endif
	let curtp=tabpagenr()
	exe "tabnext ".a:tabpage
	if winnr("$")!=1 && a:winnr<=winnr("$")
		exe a:winnr."wincmd w"
		exe "tab split"
		let newtp=tabpagenr()
		exe "tabnext ".a:tabpage
		exe a:winnr."wincmd w"
		exe "close"
		return newtp
	endif
	return curtp
endfunction

function! ToOwnTab_This()
	call ToOwnTab(tabpagenr(),winnr())
endfunction
"}}}
"}}}
"**********************************************************************************"
" Preview tags {{{
" XXX breaks when used with taglist because taglist jumps
" in and out and the previous window is not maintained
"
let g:prevword=0
command! -nargs=0 -bar AutoPrevWordToggle	let g:prevword=!g:prevword
" actually a bit annoying
" using it with CursorMoved is slow
" from CursorHold-example
au! CursorHold *.[ch] nested	if g:prevword |call PreviewWord()|endif
" CHANGE
func! PreviewWord()
	if &previewwindow			" don't do this in the preview window
		return
	endif
	let w = expand("<cword>")		" get the word under cursor
	if w =~ '\a'			" if the word contains a letter

		" Delete any existing highlight before showing another tag
		silent! wincmd P			" jump to preview window
		if &previewwindow			" if we really get there...
			match none			" delete existing highlight
			wincmd p			" back to old window
		endif

		" Try displaying a matching tag for the word under the cursor
		try
			exe "ptag " . w
		catch
			return
		endtry

		silent! wincmd P			" jump to preview window
		if &previewwindow		" if we really get there...
			if has("folding")
				" CHANGE
				"	   silent! .foldopen		" don't want a closed fold
				silent! normal zo
			endif
			call search("$", "b")		" to end of previous line
			let w = substitute(w, '\\', '\\\\', "")
			call search('\<\V' . w . '\>')	" position cursor on match
			" Add a match highlight to the word at this position
			hi previewWord term=bold ctermbg=green guibg=green
			exe 'match previewWord "\%' . line(".") . 'l\%' . col(".") . 'c\k*"'
			wincmd p			" back to old window
		endif
	endif
endfun

function! PreviewMaps()
	nnoremap <buffer> <silent> <F9>	:call PreviewWordToggle()<CR>
	imap <buffer> <silent> <F9>	<Esc><F9>
endfunction

function! PreviewWordToggle()
	silent! wincmd P
	if &previewwindow
		pclose
		wincmd p
	else
		call PreviewWord()
	endif
endfunction
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
command! -nargs=0 -bar BoxesList	if bufexists('Boxes list') |
			\ let delnr=bufnr('Boxes list') |
			\ exe delnr."bd" |
			\ endif |
			\ silent exe 'new +0r!boxes\ -l|grep\ "[[:alnum:]_-]\\+[[:blank:]](.*):"'
			\ | exe 'normal G"_ddgg' |
			\ file Boxes\ list |
			\ setl buftype=nofile noma nomod

nmap <Leader>gu	:Utl<CR>zv
vmap <Leader>gu	:Utl o v<CR>zv
nmap <Leader>gU	:split<bar>Utl<CR>zv
vmap <Leader>gU	:split<bar>Utl o v<CR>zv

command! -nargs=1 SetTabstops	set tabstop=<args> softtabstop=<args> shiftwidth=<args> noexpandtab 
command! Wsudo	:w !sudo tee % >/dev/null

function! ReverseLines(line1,line2)
	let oldp=@/
	exe string(a:line1).",".string(a:line2)."g/^/m".string(a:line1-1)
	let @/=oldp
endfunction
command! -range=% -nargs=0 ReverseLines	call ReverseLines(<line1>,<line2>)
command! -nargs=0 Alphabet	call append(line("."),"abcdefghijklmnopqrstuvwxyz")


command! -nargs=0 Duplicates	/\(\<[[:alnum:]]\+\>\)\([[:space:]]\|\n\)\+\<\1\>

function! SetUpEnv()
	if &term!~#'win32' && &term!~#'xterm'
		"CenterandWSize
		WSize
	endif
	call EnvSideBars()
endfunction

function! IsNERDTreeOpen()
	let l:curwin=winnr()
	let l:ntopen=0
	windo if bufname('%')=~".*NERD_tree_" |let l:ntopen=1|endif
	execute curwin."wincmd w"
	return l:ntopen
endfunction

function! EnvSideBarsToggle()
	let closed=0
	if IsNERDTreeOpen()
		NERDTreeClose
		let closed=1
	endif
	if bufwinnr('__Tag_List__')!=-1
		TlistClose
		let closed=1
	endif
	if !closed
		call EnvSideBars()
	endif
endfunction

function! EnvSideBars()
	NERDTreeToggle
	"CNERDTree
	if exists(':TlistOpen')
		TlistOpen
	endif
	wincmd p
	wincmd l
endfunction
nnoremap <Leader>sb	:call EnvSideBarsToggle()<CR>

command! -nargs=0 -bar SetUpEnv	call SetUpEnv()

command! -nargs=0 PrintSize	set co? lines?
command! -nargs=0 UpdateTime	set updatetime& updatetime?

command! -nargs=0 -range=% AutoFormat <line1>,<line2>!perl -MText::Autoformat -e'autoformat({all => 1})'
command! -nargs=0 AutoFormatPara .,$!perl -MText::Autoformat -e'autoformat'

let RunLineChangePre=""
if has("win32")
	let RunLineChangePre='sed "s/.*/cmd \/C &/"|'
endif
exe "command! -nargs=0 RunCurrentLine	.w !".RunLineChangePre."sh"
nnoremap \rl	:RunCurrentLine<CR>

vnoremap \wc :w !wc -w<CR>
nnoremap \wc :w !wc -w<CR>
vnoremap \st :w !style\|$PAGER <CR>
nnoremap \st :w !style\|$PAGER<CR>
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

function! DictLoad(word)
	let dword=escape(a:word," \"'\\();<>&|!?")
	let bname="/dict:".a:word
	let name="/dict:".dword
	if bufexists(bname)
		let delnr=bufnr(name)
		exe delnr."bd"
	endif
	silent exe "new +setlocal\\ modifiable\\|r!dict\\ ".escape(dword," \"'\\()<>&|!?")
	silent exe "file ".name
	normal gg"_dd
	setlocal nomod noma
	set buftype=nofile
	setf txt
endfunction
command! -nargs=1 DictLookup	call DictLoad(<f-args>)
nnoremap \dl	:DictLookup <C-R>=expand("<cword>")<CR><CR>
vnoremap \dl	y:DictLookup <C-R>"<CR>

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

function! SheBangRun()
	let first=getline(1)
	if first =~ "^#!"
		exe '!'.substitute(first,'^#!','','').' '.fnameescape(expand('%'))
	endif
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

digraph !? 8253	" Interrobang
digraph ?! 8253
digraph .3 8230 " Ellipsis
digraph ~= 8773 " Approximately equal to

"nnoremap <Leader>rf	:FuzzyFinderMruFile<CR>
" For v. 3.0
nnoremap <Leader>rf	:FufMruFile<CR>


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
