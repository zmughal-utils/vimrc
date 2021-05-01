nmap <silent> <Leader>ut :echo system("ikiwiki_urititle.pl", getline('.'))<CR>
vmap <silent> <Leader>ut :w !ikiwiki_urititle.pl<CR>
