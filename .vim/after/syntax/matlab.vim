syntax region matlabCommentFold start=+\(^\s*%.*\n\)\@<!\zs\(\_^\s*%.*\)+ end=+\ze\_^\(\s*%.*\n\)\@!.*$+ transparent fold
syntax match matlabCommentSection +\(^\s*%%\)\@=\zs.*$+ containedin=matlabComment


" Data handling
syn keyword matlabFunc exist single

" File system
syn keyword matlabFunc fullfile

" Strings
syn keyword matlabFunc strcat fprintf sprintf

" FFT
syn keyword matlabFunc fftn ifftn

hi link matlabCommentSection SpecialComment
hi link matlabFunc Function
