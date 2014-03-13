syntax region matlabCommentFold start=+\(^\s*%.*\n\)\@<!\zs\(\_^\s*%.*\)+ end=+\ze\_^\(\s*%.*\n\)\@!.*$+ transparent fold
syntax match matlabCommentSection +\(^\s*%%\)\@=\zs.*$+ containedin=matlabComment

hi link matlabCommentSection SpecialComment
