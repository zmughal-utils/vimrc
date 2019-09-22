"=============================================================================
" File:         autoload/lh/style/spacesbeforetrailingcomments.vim {{{1
" Author:       Luc Hermitte <EMAIL:luc {dot} hermitte {at} gmail {dot} com>
"		<URL:http://github.com/LucHermitte/lh-style>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-style/License.md>
" Version:      1.0.0.
let s:k_version = '100'
" Created:      05th Sep 2019
" Last Update:  06th Sep 2019
"------------------------------------------------------------------------
" Description:
"       Factorize clang-format style related to spaces before trailing comments
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
function! lh#style#spacesbeforetrailingcomments#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = get(s:, 'verbose', 0)
function! lh#style#spacesbeforetrailingcomments#verbose(...)
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

function! lh#style#spacesbeforetrailingcomments#debug(expr) abort
  return eval(a:expr)
endfunction


"------------------------------------------------------------------------
" ## Internal functions {{{1
" Function: lh#style#spacesbeforetrailingcomments#__new(name, local_global, ft) {{{2
function! lh#style#spacesbeforetrailingcomments#__new(name, local_global, ft) abort
  let style = lh#style#define_group('spaces-before-trailing-comments', a:name, a:local_global, a:ft)
  let s:crt_style = style
  return style
endfunction

"------------------------------------------------------------------------
" ## Exported functions {{{1

" Function: lh#style#spacesbeforetrailingcomments#use(styles, value, ...) {{{3
" Possible values for the style:
" - \n         -> :UseStyle -ft=c spacesbeforetrailingcomments=\n
" - {a number} -> :UseStyle -ft=c spacesbeforetrailingcomments=4
function! lh#style#spacesbeforetrailingcomments#use(styles, value, ...) abort
  let input_options = get(a:, 1, {})
  let [options, local_global, prio, ft] = lh#style#_prepare_options_for_add_style(input_options)

  let style = lh#style#spacesbeforetrailingcomments#__new(a:value, local_global, ft)
  let value = a:styles['spacesbeforetrailingcomments']
  if a:styles['spacesbeforetrailingcomments'] == '\n'
    call style.add('//', "\n//", prio+100)
    return
  endif
  call lh#assert#value(value).match('\v\d+')
  let value = eval(a:value)
  if value > 0
    " TODO ignore strings and comment contexts...
    call style.add('//', repeat(' ', value).'//', prio+100)
  endif
endfunction

"------------------------------------------------------------------------
" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
