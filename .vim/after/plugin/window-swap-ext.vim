" [w]indow [m]ove
" takes a [count] and swaps with that window and closes the current window
nnoremap <Leader>wm :<C-U>call WindowSwap#MarkWindowSwap()<Bar>exe v:count."wincmd w"<Bar>call WindowSwap#DoWindowSwap()<Bar>wincmd p<Bar>wincmd c<Bar>wincmd p<Return>

" [w]indow [s]wap
" swap with [count] window
nnoremap <Leader>ws :<C-U>call WindowSwap#MarkWindowSwap()<Bar>exe v:count."wincmd w"<Bar>call WindowSwap#DoWindowSwap()<Return>
