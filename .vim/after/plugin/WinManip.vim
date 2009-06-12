function! WinManip(what)
	let name=""
	if a:what==0
		let name=escape("Window Size",' ')
	elseif a:what==1
		let name=escape("Window Position",' ')
	else
		return
	endif
	exe "tabe ".name
	setlocal buftype=nofile
	setlocal nomodifiable
	if a:what==0
		map <buffer> k		:set lines-=3<CR>
		map <buffer> <Up>	:set lines-=3<CR>
		map <buffer> j		:set lines+=3<CR>
		map <buffer> <Down>	:set lines+=3<CR>
		map <buffer> h		:set columns-=5<CR>
		map <buffer> <Left>	:set columns-=5<CR>
		map <buffer> l		:set columns+=5<CR>
		map <buffer> <Right>	:set columns+=5<CR>
	elseif a:what==1
		map <buffer> k		:exe "winpos ".string(getwinposx())." ".string(getwinposy()-3)<CR>
		map <buffer> <Up>	:exe "winpos ".string(getwinposx())." ".string(getwinposy()-3)<CR>
		map <buffer> j		:exe "winpos ".string(getwinposx())." ".string(getwinposy()+3)<CR>
		map <buffer> <Down>	:exe "winpos ".string(getwinposx())." ".string(getwinposy()+3)<CR>
		map <buffer> h		:exe "winpos ".string(getwinposx()-3)." ".string(getwinposy())<CR>
		map <buffer> <Left>	:exe "winpos ".string(getwinposx()-3)." ".string(getwinposy())<CR>
		map <buffer> l		:exe "winpos ".string(getwinposx()+3)." ".string(getwinposy())<CR>
		map <buffer> <Right>	:exe "winpos ".string(getwinposx()+3)." ".string(getwinposy())<CR>
	endif
	map <buffer> q	:bdelete!<CR>
endfunction

autocmd VimEnter *	if has("menu") && (exists("g:load_WinManip_menu") && g:load_WinManip_menu==1)
autocmd VimEnter *		amenu &Plugin.&WinManip.&Position	<Esc>:call WinManip(1)<CR>
autocmd VimEnter *		amenu &Plugin.&WinManip.&Size		<Esc>:call WinManip(0)<CR>
autocmd VimEnter *	endif
