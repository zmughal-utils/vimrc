"=============================================================================
" File:         autoload/lh/dev/cpp/import.vim                    {{{1
" Author:       Luc Hermitte <EMAIL:luc {dot} hermitte {at} gmail {dot} com>
"		<URL:http://github.com/LucHermitte/lh-dev>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-dev/blob/master/License.md>
" Version:      2.0.0.
let s:k_version = '200'
" Created:      25th Nov 2019
" Last Update:  25th Nov 2019
"------------------------------------------------------------------------
" Description:
"       «description»
"
"------------------------------------------------------------------------
" History:      «history»
" TODO:         «missing features»
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
" ## Misc Functions     {{{1
" # Version {{{2
function! lh#dev#cpp#import#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = get(s:, 'verbose', 0)
function! lh#dev#cpp#import#verbose(...)
  if a:0 > 0 | let s:verbose = a:1 | endif
  return s:verbose
endfunction

function! s:Log(expr, ...) abort
  call call('lh#log#this',[a:expr]+a:000)
endfunction

function! s:Verbose(expr, ...) abort
  if s:verbose
    call call('s:Log',[a:expr]+a:000)
  endif
endfunction

function! lh#dev#cpp#import#debug(expr) abort
  return eval(a:expr)
endfunction


"------------------------------------------------------------------------
" ## Exported functions {{{1

"------------------------------------------------------------------------
" ## Overridden functions {{{1
" # Import C++ standard things
" Function: lh#dev#cpp#import#_nottagged(symbol) {{{3
function! lh#dev#cpp#import#_not_tagged(symbol) abort
  " From lh-cpp
  try
    let symbol = substitute(a:symbol, '.*::', '', '')
    let includes = lh#cpp#types#get_includes(symbol)
    return includes
  catch /.*/
    return []
  endtry
endfunction

" ## Internal functions {{{1

"------------------------------------------------------------------------
" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
