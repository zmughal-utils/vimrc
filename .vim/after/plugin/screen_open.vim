nmap <Leader><Leader>s	:silent exe "!screen"." -t ". fnamemodify(getcwd(),":p:h:t")<Return>:redraw!<Return>
