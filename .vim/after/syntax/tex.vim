
" adapted from system tex.vim
if has("conceal") && &enc == 'utf-8'

 " Math Symbols {{{2
 " (many of these symbols were contributed by Björn Winckler)
 if !exists("g:tex_conceal") || g:tex_conceal =~ 'm'
  let s:texMathList=[
    \ ['iff'	, '⇔']
  \]
  for texmath in s:texMathList
   if texmath[0] =~ '\w$'
    exe "syn match texMathSymbol '\\\\".texmath[0]."\\>' contained conceal cchar=".texmath[1]
   else
    exe "syn match texMathSymbol '\\\\".texmath[0]."' contained conceal cchar=".texmath[1]
   endif
  endfor
 endif
endif

" Taken from the system tex.vim but added a containedin so that it is always in
" the texComment syntax group. This is because there is a little error in the
" system tex.vim syntax that excludes contains=texTodo when folding is enabled.
syn case ignore
syn keyword texTodo		contained		combak	fixme	todo	xxx containedin=texComment
syn case match
