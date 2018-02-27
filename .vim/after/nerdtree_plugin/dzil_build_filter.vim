if exists("loaded_nerdtree_dzil_build_filter")
    finish
endif
let loaded_nerdtree_dzil_build_filter = 1

call NERDTreeAddPathFilter('NERDTreeDzilBuildIgnoreFilter')

function! NERDTreeDzilBuildIgnoreFilter(params)
    return a:params['path'].str() =~ 'p5-\(.*\)/\1-[.0-9]\+\(.tar.gz\)\?$'
endfunction
