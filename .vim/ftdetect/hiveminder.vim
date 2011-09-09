" Vim filetype detect file
" Language:	Hiveminder tasks file
" Maintainer:	Marc Hartstein <marc.hartstein@alum.vassar.edu>
" Last Change:	2007 Dec 22

augroup filetypedetect
    " Hiveminder names its files tasks.txt by default
    au BufNewFile,BufRead tasks\.txt      setf hiveminder
augroup END
