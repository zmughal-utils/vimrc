"=============================================================================
" File:         autoload/lh/style/spaces_around_brackets.vim  {{{1
" Author:       Luc Hermitte <EMAIL:luc {dot} hermitte {at} gmail {dot} com>
"		<URL:http://github.com/LucHermitte/lh-style>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-style/License.md>
" Version:      1.0.0.
let s:k_version = '100'
" Created:      11th Aug 2017
" Last Update:  09th Nov 2017
"------------------------------------------------------------------------
" Description:
"       lh-style style-plugin for EditorConfig non-official
"       "spaces_around_brackets" stylistic option.
"
" Note:
" * As I understand this option:
"   - it makes no distinction between control statements and function calls and
"   definitions.
"   - it knows nothing about terminal characters like semicolon, nor trailing
"   whitespace
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
function! lh#style#spaces_around_brackets#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = get(s:, 'verbose', 0)
function! lh#style#spaces_around_brackets#verbose(...)
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

function! lh#style#spaces_around_brackets#debug(expr) abort
  return eval(a:expr)
endfunction

"------------------------------------------------------------------------
" ## Internal functions {{{1
" Function: lh#style#spaces_around_brackets#__new(name, local_global, ft) {{{2
function! lh#style#spaces_around_brackets#__new(name, local_global, ft) abort
  let style = lh#style#define_group('spaces.brackets.ec', a:name, a:local_global, a:ft)
  let s:crt_style = style
  return style
endfunction

" Function: lh#style#spaces_around_brackets#_known_list() {{{2
function! lh#style#spaces_around_brackets#_known_list() abort
  return ['none', 'inside', 'outside', 'both']
endfunction

"------------------------------------------------------------------------
" ## API      functions {{{1
" Function: lh#style#spaces_around_brackets#none(local_global, ft) {{{2
" Permits to clear everything on this topic and to define things manually
" instead.
function! lh#style#spaces_around_brackets#none(local_global, ft) abort
  let style = lh#style#spaces_around_brackets#__new('none', a:local_global, a:ft)
  return style
endfunction

" Function: lh#style#spaces_around_brackets#use(styles, value, ...) {{{2
function! lh#style#spaces_around_brackets#use(styles, value, ...) abort
  let input_options = get(a:, 1, {})
  let [options, local_global, prio, ft] = lh#style#_prepare_options_for_add_style(input_options)

  let style = lh#style#spaces_around_brackets#__new(a:value, local_global, ft)
  if     a:value =~? 'inside'
    call style.add('(\s*' , '( ' , prio)
    call style.add('\s*)' , ' )' , prio)
  elseif a:value =~? 'outside'
    call style.add('\s*(' , ' (' , prio)
    call style.add(')\s*' , ') ' , prio)
  elseif a:value =~? 'both'
    call style.add('\s*(\s*' , ' ( ' , prio)
    call style.add('\s*)\s*' , ' ) ' , prio)
  else " "none"
    call style.add('(' , '(' , prio)
    call style.add(')' , ')' , prio)
  endif
  return 1
endfunction

"------------------------------------------------------------------------
"------------------------------------------------------------------------
" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
