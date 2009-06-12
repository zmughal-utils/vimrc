" BufExplorer things {{{
autocmd VimEnter * if exists(":BufExplorer")==2
autocmd VimEnter * 	command! -nargs=0 SBufExplorer	call StartBufExplorer("split")|nmap <buffer> q :close<CR>
autocmd VimEnter * 	command! -nargs=0 VSBufExplorer	call StartBufExplorer("vertical split")|nmap <buffer> q :close<CR>
"autocmd VimEnter * 	command! -nargs=0 SBufExplorer	split|BufExplorer
"autocmd VimEnter * 	command! -nargs=0 VSBufExplorer	vertical split|BufExplorer
autocmd VimEnter * 	nnoremap <Leader>bs	:SBufExplorer<CR>
autocmd VimEnter * 	nnoremap <Leader>bv	:VSBufExplorer<CR>
autocmd VimEnter * endif
"}}}
