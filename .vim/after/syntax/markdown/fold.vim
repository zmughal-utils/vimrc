" https://stackoverflow.com/questions/3828606/vim-markdown-folding

" fold region for headings
syn region mkdHeaderFold
    \ start="^\z(#\+\)"
    \ skip="^\z1#\+"
    \ end="^\(#\)\@="
    \ transparent fold contains=TOP

" fold region for lists
syn region mkdListFold
    \ start="^\z(\s*\)[\*\-]\z(\s*\)"
    \ skip="^\z1 \z2\s*[^#]"
    \ end="^\(.\)\@="
    \ transparent fold contains=TOP

" fold region for code blocks
syn region mkdCodeBlockFold
    \ start="^\(    \|\t\)"
    \ skip="^\(    \|\t\)"
    \ end="\ze\_^$"
    \ transparent fold keepend contains=NONE

" fold region for tables
syn region mkdTableFold
    \ start="^|"
    \ skip="^|"
    \ end="\ze\_^$"
    \ transparent fold keepend contains=NONE

syn sync fromstart
