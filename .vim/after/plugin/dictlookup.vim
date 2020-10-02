function! DictLoad(word)
	let dword=escape(a:word," \"'\\();<>&|!?")
	let bname="dict:".a:word
	let name="dict:".dword
	if bufexists(bname)
		let delnr=bufnr(name)
		exe delnr."bd"
	endif
	silent exe "new +setlocal\\ modifiable\\|r!/usr/bin/dict\\ -d\\ all\\ \\ ".escape(dword," \"'\\()<>&|!?")
	silent exe "file ".name
	normal gg"_dd
	setlocal nomod noma
	setl buftype=nofile noswapfile bufhidden=hide
	setf txt
endfunction
command! -nargs=1 DictLookup	call DictLoad(<f-args>)
nnoremap \dl	:DictLookup <C-R>=expand("<cword>")<CR><CR>
vnoremap \dl	y:DictLookup <C-R>"<CR>

augroup DictAu
        au!
        au BufReadCmd   dict:*  call DictLoad(substitute(expand("<amatch>:t"), "^dict:", "", ""))
        au FileReadCmd  dict:*  call DictLoad(substitute(expand("<amatch>:t"), "^dict:", "", ""))
augroup END
