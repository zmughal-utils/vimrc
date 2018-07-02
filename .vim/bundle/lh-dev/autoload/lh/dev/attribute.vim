"=============================================================================
" File:         autoload/lh/dev/attribute.vim                     {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://github.com/LucHermitte/lh-dev>
" Version:      001
" Created:      22nd Aug 2011
" Last Update:  16th Oct 2017
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
function! lh#dev#attribute#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = 0
function! lh#dev#attribute#verbose(...)
  if a:0 > 0 | let s:verbose = a:1 | endif
  return s:verbose
endfunction

function! s:Verbose(expr)
  if s:verbose
    echomsg a:expr
  endif
endfunction

function! lh#dev#attribute#debug(expr)
  return eval(a:expr)
endfunction


"------------------------------------------------------------------------
" ## Exported functions {{{1
" Function: lh#dev#attribute#analyse(definition) {{{3
" For an attribute definition, returns a dictionary containing:
" - "name"      : its name
" - "type"      : its type
" - "visibility": "public", "protected", "private"
" - "static"    : boolean (0/1)
function! lh#dev#attribute#analyse(definition)
  return lh#dev#option#call('attribute#analyse', &ft, a:definition)
endfunction
"------------------------------------------------------------------------
" ## Internal functions {{{1

" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
