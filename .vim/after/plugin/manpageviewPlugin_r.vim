let g:manpageview_pgm_r = "R_doc"
let g:manpageview_syntax_r="txt"
autocmd FileType r	nno <buffer> K  :<c-u>exe v:count."Man ".expand("<cword>").".r"<cr>
