" Mappings so that the section braces ({ and }) are not necessarily in the
" first column.
" See :help section
" Note: these mappings use the mappings in <url:search_noclobber.vim>.
map [[ ,?{<CR>w99[{
map ][ ,/}<CR>b99]}
map ]] j0[[%,/{<CR>
map [] k$][%,?}<CR>
