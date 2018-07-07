"=============================================================================
" File:         autoload/lh/style/__editorconfig.vim                  {{{1
" Author:       Luc Hermitte <EMAIL:luc {dot} hermitte {at} gmail {dot} com>
"		<URL:http://github.com/LucHermitte/lh-style>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-style/License.md>
" Version:      1.0.0.
let s:k_version = '100'
" Created:      04th Aug 2017
" Last Update:  17th Oct 2017
"------------------------------------------------------------------------
" Description:
"       Define hook for editor config
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
function! lh#style#__editorconfig#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = get(s:, 'verbose', 0)
function! lh#style#__editorconfig#verbose(...)
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

function! lh#style#__editorconfig#debug(expr) abort
  return eval(a:expr)
endfunction


"------------------------------------------------------------------------
" ## Exported functions {{{1
" Function: lh#style#__editorconfig#hook(config) {{{3
" TODO: shall we check whether lhvl project hook as already been triggered?
function! lh#style#__editorconfig#hook(config) abort
  call s:Verbose("lh-style/style: editor config hook -> %1", a:config)


  " EditorConfig seems to provide no way to know whether a configuration
  " setting is local to the current file, nor if it applies to a specific set of
  " filetypes, nor if it's a global setting
  " => We need to make it as local as possible with "-buffer" option. This also
  " means, the heuristic used to choose a style shall be changed!
  call lh#style#use(a:config, {'buffer': 1})
endfunction

"------------------------------------------------------------------------
" ## Internal functions {{{1

"------------------------------------------------------------------------
" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
