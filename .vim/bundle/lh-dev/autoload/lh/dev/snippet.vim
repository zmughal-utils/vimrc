"=============================================================================
" File:         autoload/lh/dev/snippet.vim                           {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} gmail {dot} com>
"		<URL:http://github.com/LucHermitte/lh-dev>
" Version:      2.0.0
let s:k_version = '200'
" Created:      21st Apr 2015
" Last Update:  17th Oct 2016
"------------------------------------------------------------------------
" Description:
"       Functions that go further than printf('%1') which is not available in
"       VimL.
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
" ## Misc Functions     {{{1
" # Version {{{2
function! lh#dev#snippet#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = get(s:, 'verbose', 0)
function! lh#dev#snippet#verbose(...)
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

function! lh#dev#snippet#debug(expr) abort
  return eval(a:expr)
endfunction

" ## Exported functions {{{1

" Function: lh#dev#snippet#eval(format, options) {{{3
" Replaces all occurrences of "${something}" which a:options["something"], for
" every ${\k\{-}} found.
function! lh#dev#snippet#eval(format, options) abort
  let res = substitute(a:format, '${\(\k\{-}\)}', '\=a:options[submatch(1)]', 'g')
  return res
endfunction

" Function: lh#dev#snippet#expand(snippet_opt, options) {{{3
" Fetches the lh#dev#option named {snippet_opt} and apply lh#dev#snippet#eval() on
" it.
function! lh#dev#snippet#expand(snippet_opt, options) abort
  let snippet = lh#ft#option#get(a:snippet_opt, &ft)
  if lh#option#is_unset(snippet)
    throw "No option <".a:snippet_opt."> known to expand"
  endif
  let res = lh#dev#snippet#eval(snippet, a:options)
  return res
endfunction

"------------------------------------------------------------------------
" ## Internal functions {{{1

" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
