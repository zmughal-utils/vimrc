"=============================================================================
" File:         autoload/lh/dev/cpp/function.vim                  {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} gmail {dot} com>
"               <URL:http://github.com/LucHermitte>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-dev/License.md>
" Version:      2.0.0
let s:k_version = '2.0.0'
" Created:      23rd Aug 2011
" Last Update:  20th Feb 2018
"------------------------------------------------------------------------
" Description:
"       «description»
"
"------------------------------------------------------------------------
" Installation:
"       Drop this file into {rtp}/autoload/lh/dev/cpp
"       Requires Vim7+
"       «install details»
" History:      «history»
" TODO:         «missing features»
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
" ## Misc Functions     {{{1
" # Version {{{2
let s:k_version = 1
function! lh#dev#cpp#function#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = 0
function! lh#dev#cpp#function#verbose(...)
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

function! lh#dev#cpp#function#debug(expr)
  return eval(a:expr)
endfunction

"------------------------------------------------------------------------
" ## Exported functions {{{1

"------------------------------------------------------------------------
" ## Internal functions {{{1

" [ ] arrays
" [ ] array-references
" [ ] function-pointers
" [X] templates
" [/] type
" [X] const
" [ ] in/out
" [X] pointer/reference
" [X] multiple tokens types (e.g. "unsigned long long int")
" [ ] default value
" [X] new line before (when analysing non ctags-signatures, but real text)
" [ ] TU
function! lh#dev#cpp#function#_build_param_decl(param) abort "{{{2
  if a:param.dir == 'in'
    let type = lh#dev#cpp#types#ConstCorrectType(a:param.type)
  else " if a:param.dir == 'out'
    let type = a:param.type . '&'
  endif
  return type . ' ' . a:param.formal
endfunction

function! lh#dev#cpp#function#_build_param_call(param) abort "{{{2
  return a:param.name
endfunction

" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
