" switch to last tab
" from <http://stackoverflow.com/questions/2119754/switch-to-last-active-tab-in-vim/2120168#2120168>
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()
