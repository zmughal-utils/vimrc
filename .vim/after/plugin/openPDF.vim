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
