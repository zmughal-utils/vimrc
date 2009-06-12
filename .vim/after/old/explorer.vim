" File Explorer
let g:explHideFiles='^\.,\.class$'
let g:explVertical=1
let g:explSplitRight=1
let g:explStartRight=0
nmap <silent> <S-F2> :Sexplore<CR>
imap <silent> <S-F2> <Esc><S-F2>
nmap <silent> <F2> :topleft vsplit .<CR>
imap <silent> <F2> <Esc><F2>
