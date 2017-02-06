"=============================================================================
" $Id$
" File:         autoload/lh/dev/java/attribute.vim                {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
" Version:      001
" Created:      23rd Aug 2011
" Last Update:  $Date$
"------------------------------------------------------------------------
" Description:
"       «description»
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
" ## Misc Functions     {{{1
" # Version {{{2
let s:k_version = 1
function! lh#dev#java#attribute#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = 0
function! lh#dev#java#attribute#verbose(...)
  if a:0 > 0 | let s:verbose = a:1 | endif
  return s:verbose
endfunction

function! s:Verbose(expr)
  if s:verbose
    echomsg a:expr
  endif
endfunction

function! lh#dev#java#attribute#debug(expr)
  return eval(a:expr)
endfunction


"------------------------------------------------------------------------
" ## Exported functions {{{1
" Function: lh#dev#java#attribute#analyse(definition) {{{3
" TODO: this analysis is totally incomplete!
" - [ ] static
function! lh#dev#java#attribute#analyse(definition)
  let clean_def = matchstr(a:definition, '^\s*\zs[^;=]*\ze[;=]\=.*$')
  let [dummy, prefix, name;tail] = matchlist(clean_def, '\(.\{-}\)\s\+\(\S\+\)$')
  let words = split(prefix)
  let static = 0
  let type   = ''
  for w in words
    if w == 'static'
      let static = 1
    elseif w =~ 'public\|protected\|private'
      let visibility = w
    else
      let type .= ' '.w
    endif
  endfor
  let res = {
        \ 'visibility': visibility,
        \ 'type'      : type[1:],
        \ 'name'      : name,
        \ 'static'    : static
        \ }
  return res
endfunction

"------------------------------------------------------------------------
" ## Internal functions {{{1

"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
