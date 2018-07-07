"=============================================================================
" File:         autoload/lh/style/indent_brace_style.vim      {{{1
" Author:       Luc Hermitte <EMAIL:luc {dot} hermitte {at} gmail {dot} com>
"		<URL:http://github.com/LucHermitte/lh-style>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-style/License.md>
" Version:      1.0.0
let s:k_version = '1.0.0'
" Created:      04th Aug 2017
" Last Update:  17th Oct 2017
"------------------------------------------------------------------------
" Description:
"       lh-style style-plugin for EditorConfig non-official
"       "indent_brace_style" stylistic option.
"
"------------------------------------------------------------------------
" History:      «history»
" TODO:
" - Merge everything w/ clang-format's BreakBeforeBrace style
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
" ## Misc Functions     {{{1
" # Version {{{2
function! lh#style#indent_brace_style#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = get(s:, 'verbose', 0)
function! lh#style#indent_brace_style#verbose(...)
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

function! lh#style#indent_brace_style#debug(expr) abort
  return eval(a:expr)
endfunction


"------------------------------------------------------------------------
" ## Styles             {{{1
" # Common definitions {{{2
" # Style definitions {{{2
" Function: lh#style#indent_brace_style#_linux_kernel(local, ft, prio, ...) {{{3
" clang-format BreakBeforeBrace=Linux is just about braces. This indent style
" also implies expandtab and ts8
function! lh#style#indent_brace_style#_linux_kernel(local, ft, prio, ...) abort
  let style = call('lh#style#__braces#linux', [a:local, a:ft, a:prio] + a:000)
  " TODO: when used with global and ft!='*', register expandtab/ts to be set to
  " be set locally
  if a:local
    setlocal expandtab
    setlocal ts=8
  elseif a:ft == '*'
    set expandtab
    set ts=8
  else
    " TODO: when used with global and ft!='*', register expandtab/ts to be set to
    call lh#common#warning_msg("expandtab and tabstop won't be set properly with these parameters: all buffers and ft=".a:ft)
  endif
  return style
endfunction

" Function: lh#style#indent_brace_style#_bsd_knf(local, ft, prio, ...) {{{3
" https://en.wikipedia.org/wiki/Indent_style#Variant:_BSD_KNF
" Also implies:
" - extra empty line at function start if there is no local variable: unimplemented
" - ts=8/expandtab // sw=4 for alignment (alignment: unimplemented)
" - space before parenthesis for ctrl statements, not functions
function! lh#style#indent_brace_style#_bsd_knf(local, ft, prio, ...) abort
  let style = call('lh#style#__braces#bsd_knf', [a:local, a:ft, a:prio] + a:000)
  " TODO: when used with global and ft!='*', register expandtab/ts to be set
  " locally
  if a:local
    setlocal expandtab
    setlocal ts=8
    setlocal sw=4
  elseif a:ft == '*'
    set expandtab
    set ts=8
    set sw=4
  else
    " TODO: when used with global and ft!='*', register expandtab/ts to be set to
    call lh#common#warning_msg("expandtab and tabstop won't be set properly with these parameters: all buffers and ft=".a:ft)
  endif
  return style
endfunction

" ## API      functions {{{1
let s:k_function = {
      \ 'none'        : 'lh#style#__braces#none'
      \,'k_r'         : 'lh#style#__braces#linux'
      \,'0tbs'        : 'lh#style#__braces#linux'
      \,'1tbs'        : 'lh#style#__braces#linux'
      \,'linux_kernel': 'lh#style#indent_brace_style#_linux_kernel'
      \,'bsd_knf'     : 'lh#style#indent_brace_style#_bsd_knf'
      \,'ratliff'     : 'lh#style#__braces#ratliff'
      \,'stroustrup'  : 'lh#style#__braces#stroustrup'
      \,'allman'      : 'lh#style#__braces#allman'
      \,'whitesmiths' : 'lh#style#__braces#allman'
      \,'gnu'         : 'lh#style#__braces#gnu'
      \,'horstmann'   : 'lh#style#__braces#horstmann'
      \,'pico'        : 'lh#style#__braces#pico'
      \,'lisp'        : 'lh#style#__braces#lisp'
      \,'java'        : 'lh#style#__braces#java'
      \ }

" Function: lh#style#indent_brace_style#use(styles, indent, ...) {{{3
function! lh#style#indent_brace_style#use(styles, indent, ...) abort
  let input_options = get(a:, 1, {})
  let [options, local_global, prio, ft] = lh#style#_prepare_options_for_add_style(input_options)
  if prio == 1
    let prio9 = 9
    let prio = 10
  endif
  let indent = tolower(a:indent)
  if has_key(s:k_function, indent)
    let style = call(s:k_function[indent], [local_global, ft, prio, prio9])
    call s:Verbose("`indent_brace_style` style set to `%1`", a:indent)
    return 1
  else
    call s:Verbose("WARNING: Impossible to set `indent_brace_style` style to `%1`", a:indent)
    call lh#common#warning_msg("WARNING: Impossible to set `indent_brace_style` style to `".a:indent.'`')
    return 0
  endif
endfunction

"------------------------------------------------------------------------
" ## Internal functions {{{1

" Function: lh#style#indent_brace_style#_known_list() {{{2
function! lh#style#indent_brace_style#_known_list() abort
  return keys(s:k_function)
endfunction

"------------------------------------------------------------------------
" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
