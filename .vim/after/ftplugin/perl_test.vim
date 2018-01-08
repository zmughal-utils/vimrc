noremap <buffer> ,gg :call perltest#GotoCorresponding()<cr>


nmap <buffer> <silent> ,r :exe ":TestSuite " . perltest#GetTestFile() \| redraw!<CR>
nmap <buffer> <silent> ,,r :exe ":TestSuite -strategy=basic " . perltest#GetTestFile() \| redraw!<CR>
nmap <buffer> <silent> ,,,r :TestFile \| redraw!<CR>
nmap <buffer> <silent> ,R :TestSuite -v t \| redraw!<CR>
nmap <buffer> <silent> ,,R :TestSuite -strategy=basic -v t \| redraw!<CR>
