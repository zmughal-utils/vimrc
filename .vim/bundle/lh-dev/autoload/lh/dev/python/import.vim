"=============================================================================
" File:         autoload/lh/dev/python/import.vim                 {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} gmail {dot} com>
"		<URL:http://github.com/LucHermitte/lh-dev>
" Version:      1.2.0.
let s:k_version = '120'
" Created:      21st Apr 2015
" Last Update:  21st Apr 2015
"------------------------------------------------------------------------
" Description:
"       Specialization for lh#dev#import functions
" }}}1
"=============================================================================

if exists('g:lh#dev#python#import#_is_running')
  finish
endif

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
" ## Misc Functions     {{{1
" # Version {{{2
function! lh#dev#python#import#version()
  return s:k_version
endfunction

" # Debug   {{{2
if !exists('s:verbose')
  let s:verbose = 0
endif
function! lh#dev#python#import#verbose(...)
  if a:0 > 0 | let s:verbose = a:1 | endif
  return s:verbose
endfunction

function! s:Verbose(expr)
  if s:verbose
    echomsg a:expr
  endif
endfunction

function! lh#dev#python#import#debug(expr)
  return eval(a:expr)
endfunction


"------------------------------------------------------------------------
" ## Overridden functions {{{1

" Function: lh#dev#python#import#_do_build_import_string(filename, options) {{{3
function! lh#dev#python#import#_do_build_import_string(filename, options) abort
  let g:options = a:options
  let symbol = get(a:options, 'symbol', lh#option#unset())
  if lh#option#is_set(symbol)
    " All those case should not happen when no "symbol" is given
    let line   = getline(get(a:options, 'line', -1))
    if line =~ '^\s*import\s\+'.a:filename.'\>'
      return lh#option#unset()
    elseif line =~ '^\s*from\s\+'.a:filename.'\s\+import\>'
      return {'append': ', '.symbol}
    else
      return 'from '.a:filename.' import '.symbol
    endif
  else
    return 'import '.a:filename
  endif
endfunction

" Function: lh#dev#python#import#_do_search_where_to_insert(options) {{{3
function! lh#dev#python#import#_do_search_where_to_insert(options) abort
  let cleanup = lh#on#exit()
        \.restore('g:lh#dev#python#import#_is_running')
  let g:lh#dev#python#import#_is_running = 1
  try
    " Search if there is already a compatible pattern where to add the symbol
    let symbol = get(a:options, 'symbol', '')
    if !empty(symbol)
      let filename = get(a:options, 'filename', {}) " assert: filename shall be defined
      let line = search('^\s*from\s\+'.filename.'\>\s\+import')
      if line > 0
        return line
      endif
    endif
    " Otherwise fallback to default implementation
    return lh#dev#import#_do_search_where_to_insert(a:options)
  finally
    call cleanup.finalize()
  endtry
endfunction

" ## Internal functions {{{1

" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
