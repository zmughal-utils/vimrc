" Search without clobbering the last search pattern.
" From <http://superuser.com/questions/793571/vim-move-to-pattern-without-changing-current-pattern>.
nnoremap ,/ :<C-u>call search(input("/"))<CR>
nnoremap ,? :<C-u>call search(input("?"),"b")<CR>
