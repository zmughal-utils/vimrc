command! MuPDFNext call system("xdotool search --onlyvisible mupdf key Next 2>/dev/null")
command! MuPDFPrev call system("xdotool search --onlyvisible mupdf key Prior 2>/dev/null")

nnoremap <buffer> <PageUp> :silent MuPDFPrev<Return>
nnoremap <buffer> k :silent MuPDFPrev<Return>
nnoremap <buffer> <PageDown> :silent MuPDFNext<Return>
nnoremap <buffer> j :silent MuPDFNext<Return>
