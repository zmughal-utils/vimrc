" Mini Buffer Explorer
let g:miniBufExplForceSyntaxEnable=1	" for that one bug
let g:miniBufExplMapWindowNavVim=1
let g:miniBufExplMapWindowNavArrows=1
let g:miniBufExplMapCTabSwitchBufs=1
nmap <silent> <F3> :TMiniBufExplorer<CR>
imap <silent> <F3> <Esc><F3>
nmap <silent> <F4> :MBEbn<CR>
imap <silent> <F4> <Esc><F4>
nmap <silent> <S-F4> :MBEbp<CR>
imap <silent> <S-F4> <Esc><S-F4>
