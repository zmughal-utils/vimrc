"=============================================================================
" File:         autoload/lh/dev/c/attribute.vim                   {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://github.com/LucHermitte/lh-dev>
" Version:      1.7.0
" Created:      22nd Aug 2011
" Last Update:  27th May 2016
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
function! lh#dev#c#attribute#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = 0
function! lh#dev#c#attribute#verbose(...)
  if a:0 > 0 | let s:verbose = a:1 | endif
  return s:verbose
endfunction

function! s:Verbose(expr)
  if s:verbose
    echomsg a:expr
  endif
endfunction

function! lh#dev#c#attribute#debug(expr)
  return eval(a:expr)
endfunction


"------------------------------------------------------------------------
" ## Exported functions {{{1
" Function: lh#dev#c#attribute#analyse(definition) {{{3
function! lh#dev#c#attribute#analyse(definition)
  let clean_def = matchstr(a:definition, '^\s*\zs[^;=]*\ze[;=]\=.*$')
  let res = lh#dev#c#function#_analyse_parameter(clean_def)
  return res
endfunction
"------------------------------------------------------------------------
" ## Internal functions {{{1

" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
