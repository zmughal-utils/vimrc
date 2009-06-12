" Vim filetype plugin file
" Language:	Vim

setlocal number
setlocal foldmethod=syntax
setlocal keywordprg=:help

" Because of ftplugin in vimruntime
setlocal textwidth=0

inoremap <buffer> <C-G> <C-X><C-V>

nmap <buffer> <F6> :source %<CR>
imap <buffer> <F6> <Esc><F6>
