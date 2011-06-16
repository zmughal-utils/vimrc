" Vim filetype plugin file
" Language:	C

call programming#Programming()
call programming#CurlyBraces()
setlocal foldmethod=syntax

let s:ext=""
if has("win32")
	let s:ext=".exe"
endif
if !filereadable('Makefile')
	exe 'setlocal makeprg=gcc\ -o\ %:r'.s:ext.'\ %\ -Wall'
endif

nmap <buffer> <F6> :!%:p:r<CR>
imap <buffer> <F6> <Esc><F6>

autocmd QuickFixCmdPost <buffer> call AutoOpenQF(0)
call PreviewMaps()
