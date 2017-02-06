"=============================================================================
" $Id$
" File:         autoload/lh/dev/instruction.vim                   {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
" Version:      001
" Created:      23rd Aug 2011
" Last Update:  $Date$
"------------------------------------------------------------------------
" Description:
"       «description»
" 
"------------------------------------------------------------------------
" Installation:
"       Drop this file into {rtp}/autoload/lh/dev
"       Requires Vim7+
"       «install details»
" History:      «history»
" TODO:         «missing features»
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
" ## Misc Functions     {{{1
" # Version {{{2
let s:k_version = 1
function! lh#dev#instruction#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = 0
function! lh#dev#instruction#verbose(...)
  if a:0 > 0 | let s:verbose = a:1 | endif
  return s:verbose
endfunction

function! s:Verbose(expr)
  if s:verbose
    echomsg a:expr
  endif
endfunction

function! lh#dev#instruction#debug(expr)
  return eval(a:expr)
endfunction


"------------------------------------------------------------------------
" ## Exported functions {{{1
" Function: lh#dev#instruction#single(instr) {{{3
function! lh#dev#instruction#single(instr)
  let res = lh#dev#option#call('instruction#_single', &ft, a:instr)
  return res
endfunction

" Function: lh#dev#instruction#assign(target, source) {{{3
function! lh#dev#instruction#assign(target, source)
  let res = lh#dev#option#call('instruction#_assign', &ft, a:target, a:source)
  return res
endfunction
"------------------------------------------------------------------------
" ## Internal functions {{{1

" Function: lh#dev#instruction#_single(instr) {{{3
" default = C familly languages
function! lh#dev#instruction#_single(instr)
  return a:instr.';'
endfunction

" Function: lh#dev#instruction#_assign(target, source) {{{3
function! lh#dev#instruction#_assign(target, source)
  return lh#dev#instruction#single(a:target . ' = ' . a:source)
endfunction
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
