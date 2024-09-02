
function! HighlightSearchGroups()
    " Clear any existing matches
    silent! call clearmatches()

    highlight Search1    cterm=Bold      ctermbg=Red     ctermfg=None
    highlight Search2    cterm=Bold      ctermbg=Green   ctermfg=None
    highlight Search3    cterm=Bold      ctermbg=Blue    ctermfg=None
    highlight Search4    cterm=Bold      ctermbg=Yellow  ctermfg=None

    highlight SearchRef1 cterm=Underline ctermbg=Red     ctermfg=None
    highlight SearchRef2 cterm=Underline ctermbg=Green   ctermfg=None
    highlight SearchRef3 cterm=Underline ctermbg=Blue    ctermfg=None
    highlight SearchRef4 cterm=Underline ctermbg=Yellow  ctermfg=None

    " Get the current search pattern
    let l:pattern = @/

    " Track the current position in the pattern
    let l:start_idx = 0
    let l:group_num = 1

    let l:match_pri = 1000

    " Match each capturing group individually
    while match(l:pattern, '\\(', l:start_idx) != -1
        " Find the next capturing group
        let l:start = match(l:pattern, '\\(', l:start_idx)
        let l:end = match(l:pattern, '\\)', l:start) + 1

        " Construct the full pattern with \zs and \ze around the capturing group
        let l:group_pattern = l:pattern[:l:start-1] . '\zs' . l:pattern[l:start:l:end] . '\ze' . l:pattern[l:end+1:]
	"echo l:group_pattern

        " Add the match for this group in its full context
        call matchadd('Search' . l:group_num, l:group_pattern, l:match_pri)

        " Move the start index just after the current group's closing parenthesis
        let l:start_idx = l:end
        let l:group_num += 1
        "let l:match_pri -= 1
    endwhile

    " Reset start index for backreference search
    let l:start_idx = 0

    " Now handle backreferences (e.g., \1, \12)
    while match(l:pattern, '\\\d\+', l:start_idx) != -1
        " Find the next backreference
        let l:ref_start = match(l:pattern, '\\\d\+', l:start_idx)
        let l:ref_end = l:ref_start + strlen(matchstr(l:pattern, '\\\d\+', l:ref_start))

        " Extract the backreference number
        let l:ref_num = matchstr(l:pattern, '\d\+', l:ref_start + 1)

        " Construct the full pattern with \zs and \ze around the backreference
        let l:ref_pattern = l:pattern[:l:ref_start-1] . '\zs' . l:pattern[l:ref_start:l:ref_end-1] . '\ze' . l:pattern[l:ref_end:]
	"echo l:ref_pattern

        " Add the match for this backreference in its full context
        call matchadd('SearchRef' . l:ref_num, l:ref_pattern, l:match_pri)

        " Move the start index past the current backreference
        let l:start_idx = l:ref_end
    endwhile

    " Highlight the entire pattern if there are no groups or references
    if l:group_num == 1
        call matchadd('Search', l:pattern, 10)
    endif
endfunction

" Map the function to a key for easy access
nnoremap <leader>hs :call HighlightSearchGroups()<CR>
