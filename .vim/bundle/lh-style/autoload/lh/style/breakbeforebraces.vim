"=============================================================================
" File:         autoload/lh/style/breakbeforebraces.vim       {{{1
" Author:       Luc Hermitte <EMAIL:luc {dot} hermitte {at} gmail {dot} com>
"		<URL:http://github.com/LucHermitte/lh-style>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-style/License.md>
" Version:      1.0.0.
let s:k_version = '100'
" Created:      12th Aug 2017
" Last Update:  17th Oct 2017
"------------------------------------------------------------------------
" Description:
"       lh-style style-plugin for clang-format "BreakBeforeBraces" stylistic
"       option.
"       https://clangformat.com/#BreakBeforeBraces
"       https://zed0.co.uk/clang-format-configurator/
"
"------------------------------------------------------------------------
" History:      «history»
" TODO:
" - BS styles:
"   - Mozilla
"   - Webkit
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
" ## Misc Functions     {{{1
" # Version {{{2
function! lh#style#breakbeforebraces#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = get(s:, 'verbose', 0)
function! lh#style#breakbeforebraces#verbose(...)
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

function! lh#style#breakbeforebraces#debug(expr) abort
  return eval(a:expr)
endfunction

"------------------------------------------------------------------------
" ## API      functions {{{1

" Function: lh#style#breakbeforebraces#use(styles, indent, ...) {{{3
" "factory" function
let s:style = lh#on#exit()
let s:k_function = {
      \ 'none'      : 'lh#style#__braces#none'
      \,'attach'    : 'lh#style#__braces#attach'
      \,'linux'     : 'lh#style#__braces#linux'
      \,'stroustrup': 'lh#style#__braces#stroustrup'
      \,'allman'    : 'lh#style#__braces#allman'
      \,'gnu'       : 'lh#style#__braces#gnu'
      \ }

function! lh#style#breakbeforebraces#use(styles, indent, ...) abort
  let input_options = get(a:, 1, {})
  let [options, local_global, prio, ft] = lh#style#_prepare_options_for_add_style(input_options)
  if prio == 1
    let prio9 = 9
    let prio = 10
  endif
  let indent = tolower(a:indent)
  if has_key(s:k_function, indent)
    let style = call(s:k_function[indent], [local_global, ft, prio, prio9])
    call s:Verbose("`breakbeforebraces` style set to `%1`", a:indent)
    return 1
  else
    call s:Verbose("WARNING: Impossible to set `breakbeforebraces` style to `%1`", a:indent)
    call lh#common#warning_msg("WARNING: Impossible to set `breakbeforebraces` style to `".a:indent.'`')
    return 0
  endif
endfunction
"------------------------------------------------------------------------
" ## Internal functions {{{1

" Function: lh#style#breakbeforebraces#_known_list() {{{2
function! lh#style#breakbeforebraces#_known_list() abort
  return keys(s:k_function)
endfunction

"------------------------------------------------------------------------
" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
