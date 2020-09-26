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
set statusline=%!SLExpression()

function SLExpression() abort
	let l:sl = ''
	let l:sl .= "%<%f\ %{SLFiletype()}%h%{'['.&ff.']'}%{SLModified()}%r%{'[W:'.winnr().']'}"
	let l:sl .= SLSpell()
	let l:sl .= "%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P"
	return l:sl
endfunction
function! SLSpell() abort
	if &spell
		return '%2*[spell]%*'
	else
		return '%1*[nospell]%*'
	end
endfunction
function! SLFiletype() abort
	if strlen(&ft)>0 &&  &ft !=# 'help'
		let filev=&ft
		if exists("g:alt_ft_{&ft}")
			let filev=g:alt_ft_{&ft}
		endif
		return '['.substitute(filev,'.','\u&','').']'
	endif
	return ''
endfunction
function! SLModified() abort
	if &modified
		return "[+]"
	endif
	return ""
endfunction
"}}}

highlight User1 ctermfg=Green guifg=Green
highlight User2 ctermfg=Red guifg=Red
