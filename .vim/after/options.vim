" Vim script for options

set nocompatible

" Man {{{
if executable('man')
	runtime ftplugin/man.vim		" Plugin for manpages
endif
"}}}

let g:skip_syntax_sel_menu=1

" Perldoc {{{
if !executable('perldoc')&&!executable('perldoc.exe')
	let g:loaded_perlhelp=1
endif
"}}}

" Taglist {{{
if !executable('ctags')&&!executable('ctags.exe')
	let g:loaded_taglist=1
endif
let g:Tlist_WinWidth=20
let g:Tlist_Enable_Fold_Column=0
let g:Tlist_Show_One_File=1
let g:Tlist_File_Fold_Auto_Close=0
let Tlist_Use_Right_Window=1
"}}}

" Netrw {{{
let g:netrw_list_hide= '^\..*'
let g:netrw_keepdir=0	" change pwd while browsing
"}}}

" NERD_Tree {{{
let g:NERDTreeWinSize=15
"autocmd VimEnter *	call extend(g:NERDTreeIgnore,map(split(&suffixes,","),'v:val."$"'))
let g:NERDTreeIgnore=['.class$','.\(log\|aux\|out\|snm\|toc\|nav\|vrb\|bbl\|blg\)$','\~$']

let g:NERDTreeSortOrder=['\/$', '\.sh$', '\.bat$', '\.java$', '\.html$', '*', '^\(\u\|\A\)\+$', '^tags$', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeHijackNetrw=0
"}}}

" NERD_comments {{{
"let g:NERDSpaceDelims=1
"}}}

" bexec {{{
let g:bexec_filter_types = {'html': 'lynx -dump',
			\ 'lisp': 'clisp'}
" 'html': 'elinks -dump 1',
"}}}

" From latexsupport.zip {{{
" http://lug.fh-swf.de/vim/vim-latex/vim-latex.html
" slightly modified
" see ~/.ctags
let tlist_bib_settings   = 'bib;e:BibTeX-Entries;s:BibTeX-Strings'
let tlist_make_settings  = 'make;m:Macros;t:Targets'
let tlist_tex_settings   = 'latex;s:Contents;g:Graphics;i:Listings;l:\label;r:\ref;p:\pageref;b:\bibitem'
"}}}

" FuzzyFinder {{{
"let g:FuzzyFinder_InfoFile = ""

" for v2.0
"let g:FuzzyFinderOptions={
	"\	'info_file' : ''
"\}

" for v.2.1 {{{
"if !exists("g:FuzzyFinderOptions")
"        let g:FuzzyFinderOptions = { 'Base':{}, 'Buffer':{}, 'File':{},
"                \ 'MruFile':{}, 'Dir':{}, 'Tag':{},
"                \ 'TaggedFile':{}}
"endif }}}

"let g:FuzzyFinderOptions.Base.info_file=''

" For v. 3.0
let g:fuf_modesDisable = [ 'mrucmd', ]

"}}}

" WinManager {{{
let winManagerWindowLayout="FileExplorer,TagList|BufExplorer"
"}}}

" TwitVim {{{
if filereadable(expand("~/.twitvim"))
	exe "so ".expand("~/.twitvim")
endif
"}}}

let g:SrcExpl_pluginList = [
	\ "__Tag_List__",
	\ "_NERD_tree_",
	\ "Source_Explorer"
\ ] 

" :help align-multibyte
let g:Align_xstrlen=3

set helpheight=8
set previewheight=4
set switchbuf+=useopen,usetab	",split
set fileformats=unix,dos
set nobackup		" Do not backup edited files
set laststatus=2	" Always have a statusline
set ruler		" Show the ruler
set showcmd		" Show incomplete commands
set incsearch		" Search while typing
set ignorecase		" Ignore case
set smartcase		" Smart ignore case

" set nohlsearch	" Do not highlight search.
"set hlsearch		" Highlight search
			" can remove highlight by calling :nohlsearch

set noexpandtab		" Use real tab
set tabstop=8		" Use multiples of 8 for <Tab>

" I am not using this right. See vim.org for an autocmd
" set noendofline	" TODO get this to work
			" Do not modify the file if it does not have an <EOL>
			" on last line
" set showmatch		" Show matching brace/bracket after typing
set noshowmatch
" set cursorline	" Highlight the current line
			" TODO
			" Where should I put this?
			" I want to use a make sure it is readable
			" Should I put in the Programming function?
			" It is REALLY slow.
set nowrap		" Do not wrap around long lines
set hidden		" Hide buffer when abandoned
set history=500		" Store commands and searches
set viewoptions+=unix,slash

" set foldlevelstart=99	" No folds open (I do not feel happy about making it '99'
			" but I do not think that it is very probable it would
			" have that high a fold level (see: hrair limit))
" setlocal nofoldenable	" when first opened none of the folds are closed
set fillchars+=fold:\ 

set listchars+=tab:\|_	" Characters to use when 'list' is on
set listchars+=nbsp:·

set completeopt=menu,menuone,preview

if has("balloon_evel")
	set ballooneval
endif

let g:ack_qhandler = ''
if executable('ack')
	let g:ackprg = 'ack' . " -H --nocolor --nogroup --column"
endif

"set synmaxcol=0

call util#No_bells()

" Options for programming {{{
" TODO these might be better in a ftplugin
set suffixes+=.class		" for Java [in default ftplugin already]
set suffixes+=.log,.aux,.out,.snm,.toc,.nav	" for TeX
let g:c_syntax_for_h=1		" *.h should be C

" highlight when you use a mixture of tabs and spaces
" and when you have whitespace at end of line        					
" (only in code, not comments)                       					
let g:c_space_errors=1
let g:java_space_errors=1
let g:python_highlight_space_errors=1

" Java
let g:java_highlight_java_lang_ids=1		" highlight java.lang.*
						" identifiers

" let g:java_highlight_functions="style"	" Not too good

" Shell scripts
let g:sh_fold_enabled=1

" Perl
let g:perl_fold=1
let g:perl_fold_blocks=1

" TeX
let g:tex_flavor="latex"
let g:tex_fold_enabled=1

" Lisp
let g:lisp_rainbow=1

" BC
let tlist_bc_settings   = 'bc;f:Functions'

" Prolog
" http://www-rocq.inria.fr/~soliman/gprolog.ctags
let tlist_prolog_settings   = 'prolog;p:Predicates'

let tlist_c_settings = 'c;d:macro;g:enum;s:struct;u:union;t:typedef;' .
			\ 'v:variable;f:function;' .
			\ 'p:prototype'

" Coffeescript <https://gist.github.com/yury/2624883>
let tlist_coffee_settings = 'coffee;c:class;v:variable;f:function'

"}}}
" vim:fdm=marker
