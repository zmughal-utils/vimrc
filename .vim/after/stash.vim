function! Test() "{{{
	let javapath="~/javadocs"
	let sub=substitute(expand("<cfile>"),"\\.","/","g")
	let fullpath=javapath."/".sub.".html"
	execute "!".g:browser." ".fullpath
endfunction "}}}

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

function! SetUpEnv()
	if &term!~#'win32' && &term!~#'xterm'
		"CenterandWSize
		WSize
	endif
	call EnvSideBars()
endfunction
command! -nargs=0 -bar SetUpEnv	call SetUpEnv()

function! Rxvt_ip()
	let i=0
	while i<2
		highlight Normal ctermbg=none
		let i=i+1
	endwhile
endfunction
" }}}

command! -nargs=0 -bar BoxesList	if bufexists('Boxes list') |
			\ let delnr=bufnr('Boxes list') |
			\ exe delnr."bd" |
			\ endif |
			\ silent exe 'new +0r!boxes\ -l|grep\ "[[:alnum:]_-]\\+[[:blank:]](.*):"'
			\ | exe 'normal G"_ddgg' |
			\ file Boxes\ list |
			\ setl buftype=nofile noma nomod
