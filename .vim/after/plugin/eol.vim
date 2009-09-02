" http://vim.wikia.com/wiki/Preserve_missing_end-of-line_at_end_of_text_files
"
" Preserve noeol (missing trailing eol) when saving file. In order
" to do this we need to temporarily 'set binary' for the duration of
" file writing, and for DOS line endings, add the CRs manually.
" Does not work with Mac line endings, but silently writes the
" file with Unix line endings.

augroup automatic_noeol
au!

au BufWritePre  * :call TempSetBinaryForNoeol()
au BufWritePost * :call TempRestoreBinaryForNoeol()

fun! TempSetBinaryForNoeol()
  let g:save_binary = &binary
  if ! &eol && ! &binary
    setlocal binary
    if &ff == "dos"
      silent 1,$-1s/$/\="\\".nr2char(13)
    endif
  endif
endfun

fun! TempRestoreBinaryForNoeol()
  if ! &eol && ! g:save_binary
    if &ff == "dos"
      silent 1,$-1s/\r$/
    endif
    setlocal nobinary
  endif
endfun

aug END
