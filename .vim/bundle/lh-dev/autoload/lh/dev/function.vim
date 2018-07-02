"=============================================================================
" File:         autoload/lh/dev/function.vim                      {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} gmail {dot} com>
"               <URL:http://github.com/LucHermitte>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-dev/blob/master/License.md>
" Version:      2.0.0
let s:k_version = '2.0.0'
" Created:      28th May 2010
" Last Update:  20th Feb 2018
"------------------------------------------------------------------------
" Description:
"       Various helper functions that return ctags information on functions
"
" History:
" 	v2.0.0: Deprecate lh#dev#option#get()
" 	v0.0.3: default lh#dev#function#_build_param_decl() uses the parameter
" 	        type if known
" 	v0.0.2: signature manipulations made overidable
" 	v0.0.1: code moved from lh-cpp
" TODO:
" 	- option to use another code tool analysis that is not ft-dependant
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
" ## Misc Functions     {{{1
" # Version {{{2
function! lh#dev#function#version()
  return s:k_version
endfunction

" # Debug {{{2
let s:verbose = 0
function! lh#dev#function#verbose(...)
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

function! lh#dev#function#debug(expr)
  return eval(a:expr)
endfunction

"------------------------------------------------------------------------
" ## Exported functions {{{1

" lh#dev#function#get_(function_tag, key) {{{2
" This function returns cached tag-data (from function, variables, ...),
" If the data is not cached yet, the relevant hook is called to fill it
function! lh#dev#function#get_(fn_tag, key)
  if !has_key(a:fn_tag, a:key)
    let a:fn_tag[a:key] = lh#dev#option#call('function#_'.a:key, &ft, a:fn_tag)
  endif
  return a:fn_tag[a:key]
endfunction

" Function: lh#dev#function#parameters_to_signature(lParams) {{{2
function! lh#dev#function#parameters_to_signature(lParams)
  let res = lh#dev#option#call('function#_parameters_to_signature', &ft, a:lParams)
  return res
endfunction

"------------------------------------------------------------------------
" ## Internal functions {{{1
function! lh#dev#function#_prototype(fn_tag) abort " {{{2
  return a:fn_tag.signature
endfunction

" Function: lh#dev#function#_signature(fn_tag) {{{2
function! lh#dev#function#_signature(fn_tag) abort
  let s:fn_tag = a:fn_tag
  throw "ASSERT: This function is not expected to be called"
  " return a:fn_tag.signature
endfunction

" Function: lh#dev#function#_parameters(fn_tag, [mustCleanSpace]) {{{2
function! lh#dev#function#_parameters(fn_tag, ...) abort
  let mustCleanSpace = a:0 > 0 ? a:1 : 0
  " ctags signature ensure a comments free signature => a comments free list of
  " parameters
  let signature = lh#dev#function#get_(a:fn_tag, 'signature')

  let params = lh#dev#option#call('function#_signature_to_parameters', &ft, signature, mustCleanSpace)
  return params
endfunction

" Function: lh#dev#function#_signature_to_parameters(signature, " [mustCleanSpace]) {{{2
function! lh#dev#function#_signature_to_parameters(signature, ...) abort
  let mustCleanSpace = a:0 > 0 ? a:1 : 0
  " Most languages are free of pointer to function types, or even templates
  " Finding each parameter == spliting the string on commas
  " 1- find the list of formal parameters
  let sParameters = matchstr(a:signature, '(\s*\zs.*\ze\s*)')

  " 2- split it
  let lParameters = lh#dev#option#call('function#_split_list_of_parameters',&ft,sParameters)

  " 3- analyse the parameters ;
  "    at least each shall have a name
  "    depending on the language, a type, a direction, etc may be provided
  let res = []
  for p in lParameters
    let ap = lh#dev#option#call('function#_analyse_parameter', &ft, p, mustCleanSpace)
    let res += [ap]
  endfor
  return res
endfunction

" Function: lh#dev#function#_split_list_of_parameters(sParameters) {{{2
function! lh#dev#function#_split_list_of_parameters(sParameters) abort
  let sep = lh#ft#option#get('parameters_separator', &ft, ',')
  let lParameters = split(a:sParameters, '\s*'.sep.'\s*')
  return lParameters
endfunction

" Function: lh#dev#function#_analyse_parameter( param, mustCleanSpace ) {{{2
function! lh#dev#function#_analyse_parameter( param, mustCleanSpace ) abort
  " default case: implicitly typed languages like viml
  return { 'name': a:param }
endfunction

" Function: lh#dev#function#_type(variable_tag) {{{2
function! lh#dev#function#_type(variable_tag) abort
  " many languages don't have explicit types
  return ''
endfunction

" Function: lh#dev#function#_parameters_to_signature(lParams) {{{2
function! lh#dev#function#_parameters_to_signature(lParams) abort
  let params = []
  for p in a:lParams
    let s = lh#dev#option#call('function#_build_param_decl', &ft, p)
    let params += [s]
  endfor
  let sep = lh#ft#option#get('parameters_separator', &ft, ',')
  let res = join(params, sep)
  return res
endfunction

" Function: lh#dev#function#_build_param_decl(param) {{{2
function! lh#dev#function#_build_param_decl(param) abort
  let res = has_key(a:param, 'type') ? a:param.type . ' ' : ''
  let res .= a:param.formal
  return res
endfunction

" Function: lh#dev#function#_build_real_params_list(lParams) {{{2
function! lh#dev#function#_build_real_params_list(lParams) abort
  let params = []
  for p in a:lParams
    let s = lh#dev#option#call('function#_build_param_call', &ft, p)
    let params += [s]
  endfor
  let sep = lh#ft#option#get('parameters_separator', &ft, ',')
  let res = join(params, sep)
  return res
endfunction

" Function: lh#dev#function#_build_param_call(param) {{{2
function! lh#dev#function#_build_param_call(param) abort
  return a:param.name
endfunction

" Function: lh#dev#function#_local_variables(function_boundaries) {{{2
" Extracts local variables, use ctags data by default.
function! lh#dev#function#_local_variables(function_boundaries) abort
  try
    let lTags = lh#dev#start_tag_session()
    if ! lh#ft#option#get('ctags_understands_local_variables_in_one_pass', &ft, 1)
      let lTags = copy(lh#dev#__BuildCrtBufferCtags(a:function_boundaries))
    endif

    let var_kind = lh#ft#option#get('variable_kind', &ft, '[vl]')

    let cond = 'v:val.kind =~ '.string(var_kind)
    if lh#ft#option#get('ctags_understands_local_variables_in_one_pass', &ft, 1)
      let cond .=
            \   ' && v:val.line>='. a:function_boundaries[0]
            \ . ' && v:val.line<='. a:function_boundaries[1]
    else
      call s:AddOffset(lTags, a:function_boundaries[0] - 1)
    endif
    call s:Verbose(cond)
    let lVariables = filter(copy(lTags), cond)
  finally
    call lh#dev#end_tag_session()
  endtry
  return lVariables
endfunction

" # s:AddOffset(lTags, function_start) {{{2
function! s:AddOffset(lTags, function_start) abort
  for tt in a:lTags
    let tt.line += a:function_start
  endfor
endfunction

" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
