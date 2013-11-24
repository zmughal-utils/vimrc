
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
