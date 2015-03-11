augroup fugitive
  au BufEnter * if exists(':Gcommit')
  au BufEnter *     command! -buffer -bar -bang -nargs=* Gci	:Gcommit<bang> --verbose <args>   " a shortcut to call commit with --verbose flag
  au BufEnter * endif
augroup END
