" Vim autoload file for simplifying programming

function programming#Programming()			" Generic settings for most programming languages
	setlocal number				" Show line numbers on side
	call programming#QuickFixMaps(1)
	inoremap <buffer> <C-G>	<C-X><C-I>
	" TODO
	" Silly little shortcut for completion
	" (would be better to have language specific completion)
	" omni-func
endfunction

" 0 global
" 1 buffer
function programming#QuickFixMaps(where)		" Mappings that make using QuickFix easier
	" TODO: need to fix the <S-Fx> keys to work in the /dev/console
	" <F12> is used to display errors
	let option=""
	if a:where==1
		let option="<buffer>"
	endif
	exe "nmap ".option." <silent> <F12> :QFtoggle<CR>"
	exe "imap ".option." <silent> <F12> <Esc><F12>"
	exe "nmap ".option." <silent> <S-F12> :cc<CR>"
	exe "imap ".option." <silent> <S-F12> <Esc><S-F12>"

	" <F11> is used to move from one error to the next
	exe "nmap ".option." <S-F11> :cprevious<CR>zv"
	exe "imap ".option." <S-F11> <Esc><S-F11>"
	exe "nmap ".option." <F11> :cnext<CR>zv"
	exe "imap ".option." <F11> <Esc><F11>"
endfunction

function programming#CurlyBraces()			" Lets you match braces...in an interesting way
	" if you type '{' and carriage return quickly in succession
	" then it types the other brace/bracket for you
	inoremap <buffer> {<CR> {<CR>}<Esc>O
endfunction
