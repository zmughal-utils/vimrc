"=============================================================================
" File:         autoload/lh/dev/types.vim                         {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} gmail {dot} com>
"               <URL:http://github.com/LucHermitte>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-dev/tree/master/License.md>
" Version:      2.0.0
let s:k_version = '2.0.0'
" Created:      26th Feb 2015
" Last Update:  17th Oct 2016
"------------------------------------------------------------------------
" Description:
"       Generic functions related to types.
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
" ## Misc Functions     {{{1
" # Version {{{2
function! lh#dev#types#version()
  return s:k_version
endfunction

" # Debug   {{{2
if !exists('s:verbose')
  let s:verbose = 0
endif
function! lh#dev#types#verbose(...)
  if a:0 > 0 | let s:verbose = a:1 | endif
  return s:verbose
endfunction

function! s:Log(expr, ...)
  call call('lh#log#this',[a:expr]+a:000)
endfunction

function! s:Verbose(expr, ...)
  if s:verbose
    call call('s:Log',[a:expr]+a:000)
  endif
endfunction

function! lh#dev#types#debug(expr)
  return eval(a:expr)
endfunction


"------------------------------------------------------------------------
" ## Exported functions {{{1

" # Type Deduction {{{2
" Function: lh#dev#types#deduce(expr) {{{3
function! lh#dev#types#deduce(expr)
  let res = lh#dev#option#call('types#_deduce', &ft, a:expr)
  return res
endfunction

" Function: lh#dev#types#of_var(expr) {{{3
function! lh#dev#types#of_var(expr, ...)
  let res = call('lh#dev#option#call',['types#_of_var', &ft, a:expr]+a:000)
  return res
endfunction

"------------------------------------------------------------------------
" ## Internal functions {{{1

" # Type Deduction {{{2
" Explicitly typed languages {{{3
let g:ada_is_explicitly_typed = 1
let g:c_is_explicitly_typed = 1
let g:cs_is_explicitly_typed = 1
let g:eiffel_is_explicitly_typed = 1
let g:java_is_explicitly_typed = 1
let g:pascal_is_explicitly_typed = 1

" Function: lh#dev#types#_deduce(expr) {{{3
" Default implementation
function! lh#dev#types#_deduce(expr)
  if lh#ft#option#get('is_explicitly_typed', &ft, 0)
    " Ada, Pascal, C, C++, Java, C#
    return lh#marker#txt('type')
  else
    " VimL, Python, Ruby, bash, Perl, ...
    return ''
  endif
endfunction

" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
