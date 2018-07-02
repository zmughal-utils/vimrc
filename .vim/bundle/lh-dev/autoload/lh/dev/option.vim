"=============================================================================
" File:         autoload/lh/dev/option.vim                        {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"               <URL:http://github.com/LucHermitte/lh-dev>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-dev/tree/master/License.md>
" Version:      2.0.0
let s:k_version = 200
" Created:      05th Oct 2009
" Last Update:  20th Feb 2018
"------------------------------------------------------------------------
" Description:  «description»
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
if ! has('patch-7.2.061')
  " Not sure that `call('lh#ft#option#get', [])` would work otherwise
  runtime autoload/lh/ft/option.vim
endif

"------------------------------------------------------------------------
" ## Misc Functions     {{{1
" # Version {{{2
function! lh#dev#option#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = get(s:, 'verbose', 0)
function! lh#dev#option#verbose(...)
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

function! lh#dev#option#debug(expr) abort
  return eval(a:expr)
endfunction

"------------------------------------------------------------------------
" ## Exported functions {{{1

" Function: lh#dev#option#get(name, filetype[, default [, scope]])  {{{2
" @return which ever exists first among: b:{ft}_{name}, or g:{ft}_{name}, or
" b:{name}, or g:{name}. {default} is returned if none exists.
" @note filetype inheritance is supported.
" The order of the scopes for the variables checked can be specified through
" the optional argument {scope}
" @deprecated, used lh#ft#option#get
function! lh#dev#option#get(name, ft,...) abort
  call lh#notify#deprecated('lh#dev#option#get', 'lh#ft#option#get')
  return call('lh#ft#option#get', [a:name, a:ft] + a:000)
endfunction

" Function: lh#dev#option#get_postfixed(name, filetype, default [, scope])  {{{2
" @return which ever exists first among: b:{ft}_{name}, or g:{ft}_{name}, or
" b:{name}, or g:{name}. {default} is returned if none exists.
" @note filetype inheritance is supported.
" The order of the scopes for the variables checked can be specified through
" the optional argument {scope}
" @deprecated, used lh#ft#option#get_postfixed
function! lh#dev#option#get_postfixed(name, ft,...) abort
  call lh#notify#deprecated('lh#dev#option#get_postfixed', 'lh#ft#option#get_postfixed')
  return call('lh#ft#option#get_postfixed', [a:name, a:ft] + a:000)
endfunction

" Function: lh#dev#option#call(name, filetype, [, parameters])  {{{2
" @return lh#dev#{ft}#{name}({parameters}) if it exists, or
" lh#dev#{name}({parameters}) otherwise
" If {name} is a |List|, then the function name used is: {name}[0]#{ft}#{name}[1]
function! lh#dev#option#call(name, ft, ...) abort
  let fname = call('lh#dev#option#_find_funcname', [a:name, a:ft] + a:000)
  call s:Verbose('Calling: %1(%2)', fname, a:000)
  if s:verbose >= 2
    debug return call (function(fname), a:000)
  else
    return call (function(fname), a:000)
  endif
endfunction

" Function: lh#dev#option#pre_load_overrides(name, ft) {{{2
" @warning {name} hasn't the same syntax as #call() and #fast_call()
" @warning This function is expected to be executed from
" autoload/lh/dev/{name}.vim (or equivalent if the prefix is forced to
" something else)
function! lh#dev#option#pre_load_overrides(name, ft) abort
  if type(a:name) == type([])
    let prefix = a:name[0]
    let name   = a:name[1]
  elseif type(a:name) == type('string')
    let prefix = 'lh/dev'
    let name   = a:name
  else
    throw "Unexpected type (".type(a:name).") for name parameter"
  endif

  let fts = lh#ft#option#inherited_filetypes(a:ft)
  let files = map(copy(fts), 'prefix."/".v:val."/".name.".vim"')
  " let files += [prefix.'/'.name.'.vim'] " Don't load the default again!
  for file in files
    " TODO: here, check for timestamps in order to avoid reloading files that
    " haven't changed
    exe 'runtime autoload/'.file
  endfor
endfunction

" Function: lh#dev#option#fast_call(name, ft, ...) {{{2
" @pre lh#option#dev#pre_load_overrides() must have been called before.
function! lh#dev#option#fast_call(name, ft, ...) abort
  if type(a:name) == type([])
    let prefix = a:name[0]
    let name   = a:name[1]
  elseif type(a:name) == type('string')
    let prefix = 'lh#dev'
    let name   = a:name
  else
    throw "Unexpected type (".type(a:name).") for name parameter"
  endif

  let fts = lh#ft#option#inherited_filetypes(a:ft)
  let fnames = map(copy(fts), 'prefix."#".v:val."#".name')
  let fnames += [prefix.'#'.name]

  let idx = lh#list#find_if_fast(fnames, 'exists("*".v:val)')
  if idx < 0
    throw 'No override of '.prefix.'(#{ft})#'.name.' is known'
  endif
  let fname = fnames[idx]
  call s:Verbose('Calling: '.fname.'('.join(map(copy(a:000), 'string(v:val)'), ', ').')')
  if s:verbose >= 2
    debug return call (function(fname), a:000)
  else
    return call (function(fname), a:000)
  endif
endfunction

"------------------------------------------------------------------------
" ## Internal functions {{{1

" # Load {{{2
" Function: lh#dev#option#_find_funcname(name, ft, ...) {{{3
" Function extracted to ease debugging.
function! lh#dev#option#_find_funcname(name, ft, ...) abort
  if type(a:name) == type([])
    let prefix = a:name[0]
    let fprefix = substitute(prefix, '#', '/', 'g')
    let name   = a:name[1]
    let fpostfix = []
  elseif type(a:name) == type('string')
    let prefix = 'lh#dev'
    let fprefix = 'lh/dev'
    let name   = a:name
    let fpostfix = split(name, '#')[:-2]
  else
    throw "Unexpected type (".type(a:name).") for name parameter"
  endif

  let fts = lh#ft#option#inherited_filetypes(a:ft)

  call map(fts, '[v:val]')
  let fts += [[]]

  let fnames =  map(copy(fts), 'join([prefix]+v:val+[name], "#")')

  let files = map(copy(fts), 'join([fprefix]+v:val+fpostfix, "/").".vim"')

  call s:Verbose('function names: %1', fnames)
  call s:Verbose('searched in %1', files)

  for i in range(len(fnames))
    let fname = fnames[i]
    if !exists('*'.fname)
      exe 'runtime autoload/'.files[i]
    endif
    if exists('*'.fname) | break | endif
  endfor

  return fname
endfunction

" # List of inherited properties between languages {{{2
" Function: lh#dev#option#inherited_filetypes(fts) {{{3
" @deprecated, use lh#ft#option#inherited_filetypes() instead
function! lh#dev#option#inherited_filetypes(fts) abort
  call lh#notify#deprecated('lh#dev#option#inherited_filetypes', 'lh#ft#option#inherited_filetypes')
  return lh#ft#option#inherited_filetypes(a:fts)
endfunction

" }}}1
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
