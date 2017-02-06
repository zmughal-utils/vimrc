"=============================================================================
" $Id$
" File:         autoload/lh/dev/vim/function.vim                  {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
" Version:      0.0.2
" Created:      15th Dec 2010
" Last Update:  $Date$
"------------------------------------------------------------------------
" Description:
"       «description»
" 
"------------------------------------------------------------------------
" Installation:
"       Drop this file into {rtp}/autoload/lh/dev/vim
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
let s:k_version = 002
function! lh#dev#vim#function#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = 0
function! lh#dev#vim#function#verbose(...)
  if a:0 > 0 | let s:verbose = a:1 | endif
  return s:verbose
endfunction

function! s:Verbose(expr)
  if s:verbose
    echomsg a:expr
  endif
endfunction

function! lh#dev#vim#function#debug(expr)
  return eval(a:expr)
endfunction


"------------------------------------------------------------------------
" ## Exported functions {{{1

"------------------------------------------------------------------------
" ## Internal functions overriden {{{1
" Function: lh#dev#vim#function#_signature(fn_tag) {{{2
function! lh#dev#vim#function#_signature(fn_tag)
  if ! has_key(a:fn_tag, 'line')
    throw 'ASSERT: The tag is expected to have a "line" key'
  endif
  let l = a:fn_tag.line
  let sig = ''
  while l <= line('$')
    let s = getline(l)
    let i = stridx(s, ')')
    " - we are ignoring function qualifiers like "range" for now
    " - trimming any leading line continuation characters "\"
    let sig .= matchstr(s[0:i], '^\s*\\\=\s*\zs.*')
    if i != -1 | break | endif
    let l += 1
  endwhile
  " Trimming the leading "function foobar" text
  let a:fn_tag.signature = sig[stridx(sig, '(') : -1]

  return a:fn_tag.signature
endfunction

" Function: lh#dev#vim#function#_local_variables(function_boundaries) {{{2
" ctags is unable to fetch local variable from vim scripts
let s:k_var_kinds = 'ablgwt'
let s:k_lvar_kinds = 'l'
function! lh#dev#vim#function#_local_variables(function_boundaries)
  let lVariables = []
  let lines = getline(a:function_boundaries[0], a:function_boundaries[1])
  let known_vars = {}
  let i = 0
  while i != len(lines)
    let line = lines[i]
    if line =~ '\<let\s\+'
      let varname = matchstr(line, '\<\(let\|for\)\s\+\zs\(['.s:k_var_kinds.']:\)\=\k\+')
      if !empty(varname) && varname =~ '^l:\|^.$\|^.[^:]'
	let kind = (varname =~ '^.:') ? varname[0] : 'l'
	if !has_key(known_vars, varname)
	  let var = {
		\ 'name': varname,
		\ 'line': i+a:function_boundaries[0],
		\ 'kind': kind
		\ }
	  let lVariables += [var]
	  let known_vars[varname] = 1
	endif
      endif
    endif
    let i += 1
  endwhile
  return lVariables
endfunction

" Function: lh#dev#vim#function#_build_param_decl(param) {{{2
function! lh#dev#vim#function#_build_param_decl(param)
  return substitute(a:param.formal, 'a:', '', '')
endfunction

" Function: lh#dev#vim#function#_analyse_parameter(param) {{{2
function! lh#dev#vim#function#_analyse_parameter(param)
  " default case: implicitly typed languages like viml
  return { 'name': lh#dev#naming#param(a:param) }
endfunction
" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
