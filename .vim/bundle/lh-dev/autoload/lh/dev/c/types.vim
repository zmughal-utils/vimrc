"=============================================================================
" $Id$
" File:         autoload/lh/dev/c/types.vim                       {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} gmail {dot} com>
"		<URL:http://code.google.com/p/lh-vim/>
" Version:      1.1.3.
let s:k_version = '1.1.3'
" Created:      27th Feb 2015
" Last Update:  $Date$
"------------------------------------------------------------------------
" Description:
"       C specialization of lh#dev#types
"
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
" ## Misc Functions     {{{1
" # Version {{{2
function! lh#dev#c#types#version()
  return s:k_version
endfunction

" # Debug   {{{2
if !exists('s:verbose')
  let s:verbose = 0
endif
function! lh#dev#c#types#verbose(...)
  if a:0 > 0 | let s:verbose = a:1 | endif
  return s:verbose
endfunction

function! s:Verbose(expr)
  if s:verbose
    echomsg a:expr
  endif
endfunction

function! lh#dev#c#types#debug(expr)
  return eval(a:expr)
endfunction


"------------------------------------------------------------------------
" ## Exported functions {{{1

"------------------------------------------------------------------------
" ## Overridden functions {{{1

" Function: lh#dev#c#types#_deduce(expr) {{{3
function! lh#dev#c#types#_deduce(expr)
  " 1- try with clang
  " 2- try with ctags/hand analyze
  " 3- return default
  return lh#marker#txt('type')
endfunction

"------------------------------------------------------------------------
" ## Internal functions {{{1

"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
