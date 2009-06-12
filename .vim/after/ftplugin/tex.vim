" Vim filetype plugin file
" Language:	LaTeX (ft=tex)

" Filetype plugin for [La]TeX
" TODO make this have better options
call programming#Programming()

setlocal tw=66
highlight link texAccent SpecialChar
autocmd QuickFixCmdPost <buffer> call AutoOpenQF(1)

compiler tex

"if &makeprg=~'make'
"        "nmap <buffer> <F5> :make<CR>
"else
"        nmap <buffer> <F5> :make %:r<CR>
"endif
