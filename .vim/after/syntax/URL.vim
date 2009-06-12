" Vim syntax file
" Language:	URL

"let protocols="\\(http\\|ftp\\|https\\|telnet\\|news\\)"
let protocols="\\(jar:\\)\\?\\(http\\|ftp\\|https\\|telnet\\|news\\|file\\)"

execute "syntax match URL +".protocols."://[^\\t )\"]*+ contains=@NoSpell"

highlight link URL String
