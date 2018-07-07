"=============================================================================
" File:         autoload/lh/style/spacesinemptyparentheses.vim {{{1
" Author:       Luc Hermitte <EMAIL:luc {dot} hermitte {at} gmail {dot} com>
"		<URL:http://github.com/LucHermitte/lh-style>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-style/License.md>
" Version:      1.0.0.
let s:k_version = '100'
" Created:      02nd Oct 2017
" Last Update:  09th Nov 2017
"------------------------------------------------------------------------
" Description:
"       lh-style style-plugin for clang-format "SpacesInEmptyParentheses"
"       stylistic option.
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
function! lh#style#spacesinemptyparentheses#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = get(s:, 'verbose', 0)
function! lh#style#spacesinemptyparentheses#verbose(...)
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

function! lh#style#spacesinemptyparentheses#debug(expr) abort
  return eval(a:expr)
endfunction

"------------------------------------------------------------------------
" ## Internal functions {{{1
" Function: lh#style#spacesinemptyparentheses#__new(name, local_global, ft) {{{2
function! lh#style#spacesinemptyparentheses#__new(name, local_global, ft) abort
  let style = lh#style#define_group('spaces.brackets.cf.in_empty', a:name, a:local_global, a:ft)
  let s:crt_style = style
  return style
endfunction

" Function: lh#style#spacesinemptyparentheses#_known_list() {{{2
function! lh#style#spacesinemptyparentheses#_known_list() abort
  return ['none', 'yes', 'no', 'true', 'false', 1, 0]
endfunction

"------------------------------------------------------------------------
" ## API      functions {{{1
" Function: lh#style#spacesinemptyparentheses#use(styles, value, ...) {{{2
let s:k_pattern = '(\s*\%('.lh#marker#txt('.\{-}').'\|!cursorhere!\|!mark!\)\zs\ze\s*)'
function! lh#style#spacesinemptyparentheses#use(styles, value, ...) abort
  let input_options = get(a:, 1, {})
  let [options, local_global, prio, ft] = lh#style#_prepare_options_for_add_style(input_options)

  let style = lh#style#spacesinemptyparentheses#__new(a:value, local_global, ft)
  if     a:value =~? 'yes\|true\|1'
    call style.add(s:k_pattern, ' ' , prio)
  else " no
    call style.add(s:k_pattern, '' , prio)
  endif
  return 1
endfunction

"------------------------------------------------------------------------
" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
