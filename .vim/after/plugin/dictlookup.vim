function! DictLoad(word)
	let dword=escape(a:word," \"'\\();<>&|!?")
	let bname="/dict:".a:word
	let name="/dict:".dword
	if bufexists(bname)
		let delnr=bufnr(name)
		exe delnr."bd"
	endif
	silent exe "new +setlocal\\ modifiable\\|r!/usr/bin/dict\\ -d\\ all\\ \\ ".escape(dword," \"'\\()<>&|!?")
	silent exe "file ".name
	normal gg"_dd
	setlocal nomod noma
	set buftype=nofile
	setf txt
endfunction
command! -nargs=1 DictLookup	call DictLoad(<f-args>)
nnoremap \dl	:DictLookup <C-R>=expand("<cword>")<CR><CR>
vnoremap \dl	y:DictLookup <C-R>"<CR>
