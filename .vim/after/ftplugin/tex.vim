" Vim filetype plugin file
" Language:	LaTeX (ft=tex)

" Filetype plugin for [La]TeX
" TODO make this have better options
call programming#Programming()

setlocal tw=66
highlight link texAccent SpecialChar
autocmd QuickFixCmdPost <buffer> call AutoOpenQF(1)

compiler tex

"if &makeprg=~'make'
"        "nmap <buffer> <F5> :make<CR>
"else
"        nmap <buffer> <F5> :make %:r<CR>
"endif

nnoremap <buffer>	<F6>	:call TeXSmartOpen()<CR>
imap	<buffer>	<F6>	<Esc><F6>
if &makeprg!='make' && executable("pdflatex")|exe "PDFLaTeX"|endif
let b:surround_69 = "\\[\r\\]"
let b:surround_101 = "\\(\r\\)"

"if has('win32') &&  executable('yap.exe') "{{{
"	command! -nargs=1 -complete=file Yap	silent !start yap -1 <args>
"	augroup MyFileType
"		autocmd FileType tex	nnoremap <buffer>	<F6>	:Yap %:r<CR>
"		autocmd FileType tex	imap	<buffer>	<F6>	<Esc><F6>
"	augroup END
"endif "}}}

command! -nargs=0 PDFTeX	let &l:makeprg= 'pdftex -interaction=nonstopmode'
command! -nargs=0 PDFLaTeX	let &l:makeprg= 'pdflatex -interaction=nonstopmode'
command! -nargs=0 LaTeX		let &l:makeprg= 'latex -interaction=nonstopmode'

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
