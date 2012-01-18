" Vim filetype plugin file
" Language:	Python

setlocal number
nnoremap <buffer> <F6>	:!python %<CR>
setl ts=2 sw=2 sts=2

runtime ftplugin/jpythonfold.vim
setl foldcolumn=1
