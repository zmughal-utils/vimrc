let g:manpageview_pgm_swipl = "swipl_doc"
let g:manpageview_syntax_swipl="txt"
let g:manpageview_syntax_swipl="txt"
autocmd FileType prolog	nno <buffer> K  :<c-u>exe v:count."Man ".expand("<cword>").".swipl"<cr>
