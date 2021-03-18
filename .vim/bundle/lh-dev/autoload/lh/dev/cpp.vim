"=============================================================================
" File:         autoload/lh/dev/cpp.vim                           {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} gmail {dot} com>
"               <URL:http://github.com/LucHermitte>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-dev/License.md>
" Version:      2.0.0.
let s:k_version = '2.0.0'
" Created:      31st Aug 2011
" Last Update:  09th Mar 2021
"------------------------------------------------------------------------
" Description:
"       «description»
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
" Import functions from lh-cpp if it's installed
runtime autoload/lh/cpp.vim
"------------------------------------------------------------------------
" ## Misc Functions     {{{1
" # Version {{{2
let s:k_version = 1
function! lh#dev#cpp#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = 0
function! lh#dev#cpp#verbose(...)
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

function! lh#dev#cpp#debug(expr)
  return eval(a:expr)
endfunction


"------------------------------------------------------------------------
" ## Exported functions {{{1
" Function: lh#dev#cpp#use_cpp11() {{{3
" this function is deprecated by the functions lh#cpp#use_cpp*() from lh-cpp,
" but still kept to not impose a dependency on lh-cpp in vim-refactor
function! lh#dev#cpp#use_cpp11()
  " default is yes now (Mar 2021)
  return exists('*lh#cpp#use_cpp11') ? lh#cpp#use_cpp11() : lh#option#get('cpp_use_cpp11', 1)
endfunction

"------------------------------------------------------------------------
" ## Internal functions {{{1

" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
