" Adapted from <https://github.com/thoughtstream/Damian-Conway-s-Vim-Setup>.
"====[ Show when lines extend past column 80 ]=================================>-<=====================

highlight ColorColumn ctermfg=208 ctermbg=blue

let g:MarkMargin_enabled = 1

command  MarkMarginEnable  let g:MarkMargin_enabled = 1
command  MarkMarginDisable let g:MarkMargin_enabled = 0

function! MarkMargin (on)
    if exists('b:MarkMargin')
        try
            call matchdelete(b:MarkMargin)
        catch /./
        endtry
        unlet b:MarkMargin
    endif
    if a:on && g:MarkMargin_enabled
        let b:MarkMargin = matchadd('ColorColumn', '\%81v\s*\S', 100)
    endif
endfunction

augroup MarkMargin
    autocmd!
    autocmd  BufEnter  *       :call MarkMargin(1)
    autocmd  BufEnter  *.vp*   :call MarkMargin(0)
augroup END
