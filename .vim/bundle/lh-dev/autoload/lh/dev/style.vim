"=============================================================================
" File:         autoload/lh/dev/style.vim                         {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"               <URL:http://github.com/LucHermitte/lh-dev/>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-dev/tree/master/License.md>
" Version:      2.0.0
let s:k_version = 2000
" Created:      12th Feb 2014
" Last Update:  17th Oct 2017
"------------------------------------------------------------------------
" Description:
"       Functions related to help implement coding styles (e.g. Allman or K&R
"       way of placing brackets, must there be spaces after ';' in for control
"       statements, ...)
"
"       Defines:
"       - support function for :AddStyle
"       - lh#dev#style#get() that returns the style chosen for the given
"         filetype
"
" Requires:
"       - lh-vim-lib v4.0.0
" Tests:
"       See tests/lh/dev-style.vim
" TODO:
"       Remove unloaded buffers
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim

"------------------------------------------------------------------------
" ## Misc Functions     {{{1
" # Version {{{2
function! lh#dev#style#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = get(s:, 'verbose', 0)
function! lh#dev#style#verbose(...)
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

function! lh#dev#style#debug(expr) abort
  return eval(a:expr)
endfunction

" # Misc    {{{2
" s:getSNR([func_name]) {{{3
function! s:getSNR(...)
  if !exists("s:SNR")
    let s:SNR=matchstr(expand('<sfile>'), '<SNR>\d\+_\zegetSNR$')
  endif
  return s:SNR . (a:0>0 ? (a:1) : '')
endfunction

"------------------------------------------------------------------------
" ## Exported functions {{{1

" # Main Style functions {{{2
" Function: lh#dev#style#clear() {{{3
function! lh#dev#style#clear()
  call lh#notify#deprecated('lh#dev#style#clear', 'lh#style#clear')
  call lh#style#clear()
endfunction

" Function: lh#dev#style#get(ft) {{{3
function! lh#dev#style#get_groups(ft) abort
  call lh#notify#deprecated('lh#dev#style#get_groups', 'lh#style#get_groups')
  return lh#style#get_groups(a:ft)
endfunction

function! lh#dev#style#get(ft) abort
  call lh#notify#deprecated('lh#dev#style#get', 'lh#style#get')
  return lh#style#get(a:ft)
endfunction

" Function: lh#dev#style#apply(text [, ft]) {{{3
function! lh#dev#style#apply(...) abort
  call lh#notify#deprecated('lh#dev#style#apply', 'lh#style#apply')
  return call('lh#style#apply', a:000)
endfunction

" Function: lh#dev#style#apply_these(styles, text) {{{3
function! lh#dev#style#apply_these(...) abort
  call lh#notify#deprecated('lh#dev#style#apply_these', 'lh#style#apply_these')
  return call('lh#style#apply_these', a:000)
endfunction

" Function: lh#dev#style#reinject_cached_ignored_matches(text [, cache]) {{{3
function! lh#dev#style#reinject_cached_ignored_matches(...) abort
  call lh#notify#deprecated('lh#dev#style#reinject_cached_ignored_matches', 'lh#style#reinject_cached_ignored_matches')
  return call('lh#style#reinject_cached_ignored_matches', a:000)
endfunction

" Function: lh#dev#style#ignore(pattern, local_global, ft) {{{3
function! lh#dev#style#ignore(...) abort
  call lh#notify#deprecated('lh#dev#style#ignore', 'lh#style#ignore')
  return call('lh#style#ignore', a:000)
endfunction

" Function: lh#dev#style#just_ignore_this(text [, cache_of_ignored_matches]) {{{3
" Permits other tools to inject texts to reinject latter after style has
" been applied. See mu-template for an example of use.
function! lh#dev#style#just_ignore_this(...) abort
  call lh#notify#deprecated('lh#dev#style#just_ignore_this', 'lh#style#just_ignore_this')
  return call('lh#style#just_ignore_this', a:000)
endfunction

" # lh-brackets Adapters for snippets {{{2
" Function: lh#dev#style#surround() {{{3
function! lh#dev#style#surround(...) range
  call lh#notify#deprecated('lh#dev#style#surround', 'lh#style#surround')
  return call('lh#style#surround', a:000)
endfunction

" # Use semantically named styles {{{2
" Function: lh#dev#style#use(styles [, options]) {{{3
function! lh#dev#style#use(styles, ...) abort
  call lh#notify#deprecated('lh#dev#style#use', 'lh#style#use')
  return call('lh#style#use', a:000)
endfunction

"------------------------------------------------------------------------
" ## Internal functions {{{1
" # :UseStyle API {{{2
" Function: lh#dev#style#define_group(kind, name, local_global, ft) {{{3
function! lh#dev#style#define_group(...) abort
  call lh#notify#deprecated('lh#dev#style#define_group', 'lh#style#define_group')
  return call('lh#style#define_group', a:000)
endfunction

"------------------------------------------------------------------------
" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
