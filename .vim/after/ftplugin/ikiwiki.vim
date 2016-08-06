setl sua+=.mdwn
setl fdm=expr
setl foldexpr=markdown_fold#MarkdownLevel()

" open render in buffer with window width
nmap <buffer> <F5> :exe "new +r!ikiwiki_render\\ ". fnameescape(expand("%")) ."\|html_to_text\\ --width\\ ".winwidth(0) \| setl buftype=nofile \| normal 1G<CR>
" open render in Firefox
nmap <buffer> <F6> :exe "!ikiwiki_render ".fnameescape(expand('%')). "\| pipe_into_firefox"<CR>

" So that markdown syntax gets loaded by syntax/ikiwiki.vim
let g:ikiwiki_render_filetype="markdown"

setl ts=4 sts=4 sw=4 et
