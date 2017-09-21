" https://stackoverflow.com/questions/3828606/vim-markdown-folding

" fold region for headings
syn region mkdHeaderFold
    \ start="^\z(#\+\)"
    \ skip="^\z1#\+"
    \ end="^\(#\)\@="
    \ fold contains=TOP

" fold region for lists
syn region mkdListFold
    \ start="^\z(\s*\)[\*\-]\z(\s*\)"
    \ skip="^\z1 \z2\s*[^#]"
    \ end="^\(.\)\@="
    \ fold contains=TOP

syn sync fromstart
