"=============================================================================
" File:         autoload/lh/dev/tags.vim                          {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://github.com/LucHermitte/lh-dev>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-dev/tree/master/License.md>
" Version:	2.0.0
let s:k_version = 200
" Created:      09th Sep 2013
" Last Update:  05th Dec 2016
"------------------------------------------------------------------------
" Description:
"       API functions to obtain symbol declarations
"       Various functions that parse ctags tags.
"
"------------------------------------------------------------------------
" TODO: use the rigth scope resolution operator (depending on the langage)
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
" ## Misc Functions     {{{1
" # Version {{{2
function! lh#dev#tags#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = get(s:, 'verbose', 0)
function! lh#dev#tags#verbose(...)
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

function! lh#dev#tags#debug(expr) abort
  return eval(a:expr)
endfunction

" ## Exported functions {{{1

"------------------------------------------------------------------------
" Function: lh#dev#tags#keep_full_names(tags_list) {{{3
function! lh#dev#tags#keep_full_names(tags_list)
  let result_as_dict = {}
  for tag in a:tags_list
    let full_name = []
    for qualif in ['namespace', 'class', 'enum']
      if has_key(tag, qualif) && stridx(tag.name, tag[qualif]) < 0
        let full_name += [ tag[qualif] ]
      endif
    endfor
    " TODO: if tag.name contains redundant part of the namespace => fix it
    let full_name += [ tag.name ]
    " TODO: use the right scope resolution operator
    let name = join(full_name, '::')

    if !has_key(result_as_dict, name)
      let tag.name = name
      let result_as_dict[name] = tag
    endif
  endfor
  " and then copy the dict to a list
  return values(result_as_dict)
endfunction

"------------------------------------------------------------------------
" Function: lh#dev#tags#fetch(feature) {{{3
function! lh#dev#tags#fetch(feature) abort
  let id = eval(s:TagsSelectPolicy())

  let cleanup = lh#on#exit()
        \.restore('&isk')
  try
    set isk-=:
    let info = taglist('.*\<'.id.'$')
  finally
    call cleanup.finalize()
  endtry
  if len(info) == 0
    throw a:feature.": no tags for `".id."'"
  endif
  " Filter for function definitions and #defines, ...
  let accepted_kinds = lh#ft#option#get('tag_kinds_for_inclusion', &ft, '[dfmptcsg]')
  call filter(info, "v:val.kind =~ ".string(accepted_kinds))
  " Filter for include files only
  let accepted_files = lh#ft#option#get('file_regex_for_inclusion', &ft, '\.h')
  call filter(info, "v:val.filename =~? ".string(accepted_files))
  " Is there any symbol left ?
  if len(info) == 0
    throw a:feature.": no acceptable tag for `".id."'"
  endif

  " Strip the leading path that won't ever appear in included filename
  let includes = lh#cpp#tags#get_included_paths()
  for val in info
    let val.filename = lh#cpp#tags#strip_included_paths(val.filename, includes)
  endfor
  " call map(info, "v:val.filename = lh#cpp#tags#strip_included_paths(v:val.filename, includes)")

  " And remove redundant info
  let info = lh#tags#uniq_sort(info)
  return [id, info]
endfunction

" ## Internal functions {{{1

function! s:TagsSelectPolicy()
  let select_policy = lh#option#get('tags_select', "expand('<cword>')", 'bg')
  return select_policy
endfunction

" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
