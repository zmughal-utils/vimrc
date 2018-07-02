"=============================================================================
" File:         spec/support/c-snippets.vim                       {{{1
" Author:       Luc Hermitte <EMAIL:luc {dot} hermitte {at} gmail {dot} com>
"		<URL:http://github.com/LucHermitte/lh-dev>
" Version:      2.0.0.
let s:k_version = '200'
" Created:      09th Aug 2017
" Last Update:  09th Aug 2017
"------------------------------------------------------------------------
" Description:
"       Support definitions for lh-deb vimrunner tests
"       -> Duplicate some functions from lh-cpp
"
"------------------------------------------------------------------------
" History:      «history»
" TODO:         «missing features»
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
function! LH_cpp_snippets_def_abbr(key, expr) abort
  if getline('.') =~ '^\s*#'
    return a:key
  endif
  " Default behaviour
  if type(a:expr) == type({})
    " This is a switch
    let exprs = filter(items(a:expr), 'eval(v:val[0])')
    call lh#assert#value(exprs).not().empty("No case found for the mapping ". string(a:key)." --> ".string(a:expr))
    let expr = exprs[0][1]
  else
    let expr = a:expr
  endif
  let rhs = lh#dev#style#apply(expr)
  return lh#map#insert_seq(a:key, rhs)
endfunction

Inoreabbr <buffer> <silent> if <C-R>=LH_cpp_snippets_def_abbr('if ',
      \ '\<c-f\>if(!cursorhere!){!mark!}!mark!')<cr>

let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
