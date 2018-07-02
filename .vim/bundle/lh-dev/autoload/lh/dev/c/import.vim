"=============================================================================
" File:         autoload/lh/dev/c/import.vim                      {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} gmail {dot} com>
"		<URL:http://github.com/LucHermitte/lh-dev>
" Version:      1.2.0.
let s:k_version = '120'
" Created:      21st Apr 2015
" Last Update:  20th Feb 2018
"------------------------------------------------------------------------
" Description:
"       Specialization for lh#dev#import functions
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
" ## Misc Functions     {{{1
" # Version {{{2
function! lh#dev#c#import#version()
  return s:k_version
endfunction

" # Debug   {{{2
if !exists('s:verbose')
  let s:verbose = 0
endif
function! lh#dev#c#import#verbose(...)
  if a:0 > 0 | let s:verbose = a:1 | endif
  return s:verbose
endfunction

function! s:Verbose(expr)
  if s:verbose
    echomsg a:expr
  endif
endfunction

function! lh#dev#c#import#debug(expr)
  return eval(a:expr)
endfunction


"------------------------------------------------------------------------
" ## Overridden functions {{{1

" Function: lh#dev#c#import#_do_clean_filename(filename) {{{2
function! lh#dev#c#import#_do_clean_filename(filename) abort
  let filename0 = substitute(a:filename, '[<"]\(\f\+\)[>"]', '\1', '')
  return filename0
endfunction

" Function: lh#dev#c#import#_do_build_import_string(filename, options) {{{2
" - _('"filename"')                   -> "filename"
" - _('<filename>')                   -> <filename>
" - _('filename', {...})              -> "filename"
" - _('filename', {"delim":"angle"})  -> <filename>
function! lh#dev#c#import#_do_build_import_string(filename, options) abort
  if a:filename[0] == '<'
    let useAngleBrackets = 1
  elseif a:filename[0] == '"'
    let useAngleBrackets = 0
  elseif has_key(a:options, 'fullfilename') && a:options.fullfilename =~ '\<usr\>\|\<local\>'
    let useAngleBrackets = 1
  else
    let useAngleBrackets = get(a:options, 'delim', 'quote') == "angle"
  endif
  let filename0 = lh#dev#c#import#_do_clean_filename(a:filename)
  if useAngleBrackets
    let filename = '<'.filename0.'>'
  else
    let filename = '"'.filename0.'"'
  endif

  return '#include ' . filename
endfunction

"------------------------------------------------------------------------
" ## Internal functions {{{1

" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
