"=============================================================================
" File:		autoload/lh/dev/cpp/types.vim                            {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"               <URL:http://github.com/LucHermitte>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-dev/tree/master/License.md>
" Version:	2.0.0
let s:k_version = '2.0.0'
" Created:	10th Feb 2009
" Last Update:	09th Mar 2018
"------------------------------------------------------------------------
" Description:
" 	Analysis functions for C++ types.
"
"------------------------------------------------------------------------
" History:
" 	v2.0.0: ~ deprecate lh#dev#option#get()
" 	        - #_of_var cannot work on parameters
" 	        + Fix lh#dev#cpp#types#const_correct_type() for vim 7.4.152
" 	v1.5.0: - #_of_var
" 	v1.3.9: - better magic/nomagic neutrality
" 	        - snake_case enforced
" 	        #is_base_type
" 	         - long long fixed
" 	         - tests written
" 	         - support for option (bg):(cpp_)base_type_pattern
" 	        #is_*ptr
" 	         - CppCoreGuidelines
" 	        #is_view
" 	v1.3.7: lh#dev#cpp#types#IsPointer supports "_ptr<.*>"
" 	        lh#dev#cpp#types#ConstCorrectType supports smart-pointers and
" 	        pointers
" 	        + lh#dev#cpp#types#is_smart_ptr
" 	        + lh#dev#cpp#types#remove_ptr
" 	        + lh#dev#cpp#types#is_not_owning_ptr
" 	        + draft detection of some CppCoreGuideLines pointer types
" 	v1.3.2: New types added to is_pointer
" 	v1.1.3: New function specialization: lh#dev#types#deduce()
" 	v1.0.2: New function lh#dev#cpp#types#IsPointer(type) for lh-cpp
" 	        doxygenation.
" 	v0.2.2: Moved to lh-dev v0.0.3
" 	v0.0.0: Creation in lh-cpp
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------

" ## Misc Functions     {{{1
" # Version {{{2
function! lh#dev#cpp#types#version()
  return s:k_version
endfunction

" # Debug   {{{2
if !exists('s:verbose')
  let s:verbose = 0
endif
function! lh#dev#cpp#types#verbose(...)
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

function! lh#dev#cpp#types#debug(expr)
  return eval(a:expr)
endfunction


"------------------------------------------------------------------------
" ## Exported functions {{{1

" # const related functions {{{2
" Function:	s:ExtractPattern(str, pat)                        : str	{{{3
" Note:		Internal, used by is_base_type
function! s:ExtractPattern(expr, pattern) abort
  return substitute(a:expr, '\v^\s*%('. a:pattern .')\s*', '', 'g')
endfunction

" Function:	lh#dev#cpp#types#is_base_type(typeName)           : bool	{{{3
" Note:		Do not test for aberrations like long float
" @todo Check for enumerates in ctags (or other) databases
let s:k_sign  = '<unsigned>|<signed>'
let s:k_size  = '<short>|<(long\s+)=long>|<>'
let s:k_types = '<void>|<char>|<wchar_t>|<int>|<float>|<double>|<size_t>|<ptrdiff_t>'
" let s:k_scope = '(<\I\i*\s*::\s*)+'
let s:k_scope = '.*::\s*\ze<\I\i*>'
" C++11 types
let s:k_types.= '|<u=int%(_least|_fast)=%(8|16|32|64)_t>'
let s:k_types.= '|<u=int%(max|ptr)_t>'
let s:k_types.= '|<bool>'
let s:k_types.= '|<nullptr_t>'
" C++ lib types
let s:k_types.= '|<size_type>'

function! lh#dev#cpp#types#is_base_type(type, pointerAsWell) abort
  call s:Verbose('Check lh#dev#cpp#types#is_base_type(%1)', a:type)

  let expr = s:ExtractPattern( a:type, s:k_scope )
  let expr = s:ExtractPattern( expr,   s:k_sign )
  let expr = s:ExtractPattern( expr,   s:k_size )
  let expr = s:ExtractPattern( expr,   s:k_types )
  let user_base_types = lh#ft#option#get('base_type_pattern', 'cpp')
  call s:Verbose('(cpp_)base_type_pattern: %1', user_base_types)
  if lh#option#is_set(user_base_types)
    let expr = s:ExtractPattern( expr, user_base_types)
  endif
  if a:pointerAsWell==1
    if match( substitute(expr,'\s*','','g'), '\v(\*|\&)+$' ) != -1
      return 1
    endif
  endif
  call s:Verbose('Expr: %1 => %2base_type', expr, (expr=='' ? '' : 'not a '))
  " return strlen(expr) == 0
  return expr == ''
endfunction
function! lh#dev#cpp#types#IsBaseType(type, pointerAsWell) abort
  " Deprecated function
  return lh#dev#cpp#types#is_base_type(a:type, a:pointerAsWell)
endfunction

" Function:	lh#dev#cpp#types#const_correct_type(type)         : string	{{{3
" Purpose:	Returns the correct expression of the type regarding the
" 		const-correctness issue ; cf Herb Sutter's
" 		_Exceptional_C++_ - Item 43.
" Option:       (b|g):{cpp_}place_const_after_type : boolean, default: true
" Note:         Badly named: it builds types for [in] value parameters
function! lh#dev#cpp#types#const_correct_type(type) abort
  if lh#dev#cpp#types#is_base_type(a:type,0) == 1
    return a:type
  endif
  if lh#ft#option#get('place_const_after_type', 'cpp', 1)
    let fmt = '%s const%s'
  else
    let fmt = 'const %s %s'
  endif
  if a:type =~ '\v\*\s*$'
    " raw pointers
    return printf(fmt, matchstr(a:type, '\v.{-}\ze\s*\*\s*$'), '*')
  elseif lh#dev#cpp#types#is_pointer(a:type) || lh#dev#cpp#types#is_view(a:type)
    " Other pointer types: smart pointers are taken by copy
    " No need to add const?
    return a:type
  else
    return printf(fmt, a:type, '&')
  endif
endfunction
function! lh#dev#cpp#types#ConstCorrectType(type) abort
  return lh#dev#cpp#types#const_correct_type(a:type)
endfunction

" Function: lh#dev#cpp#types#is_const(type)                   : bool {{{3
function! lh#dev#cpp#types#is_const(type) abort
  return a:type =~ '\v<const>'
endfunction

" Function: lh#dev#cpp#types#remove_cv(type)                  : string {{{3
" FIXME: 'T const * const' -> 'T const*'
function! lh#dev#cpp#types#remove_cv(type) abort
  let parts = split(a:type, '\v\s+|\zs\ze[*&]')
  let b = 0
  let e = len(parts)-1
  if e==-1
    return ''
  endif
  if e == 1 && parts[0] =~ '\v<(const|volatile)>'
    return substitute(a:type, '\v^\s*<(const|volatile)>\s*', '', '')
  endif
  return substitute(a:type, '\v\s*<(const|volatile)>\s*$', '', '')


  " This way of proceding alters the spaces between tokens
  if e == 1 && parts[0] =~ '\v<(const|volatile)>'
    let b += 1
  elseif parts[e] =~ '\v<(const|volatile)>'
    let e -= 1
  endif
  return join(parts[b : e], ' ')
endfunction

" # References related functions {{{2
" Function: lh#dev#cpp#types#remove_reference(type)           : string {{{3
function! lh#dev#cpp#types#remove_reference(type) abort
  return substitute(a:type, '\s*&\s*', '', '')
endfunction

" # Pointer related functions {{{2
" Function: lh#dev#cpp#types#is_pointer(type)                 : bool {{{3
function! lh#dev#cpp#types#is_pointer(type) abort
  " Special case: owner<T*>
  if a:type =~ '\v^<owner>\<.*\*\s*\>\s*$'
    return 1
  endif
  return a:type =~ '\v([*]|(pointer|_ptr|Ptr|<nullptr_t>|<not_null>|<span>)(\<.*\>)=)\s*$'
endfunction

function! lh#dev#cpp#types#IsPointer(type) abort
  return lh#dev#cpp#types#is_pointer(a:type)
endfunction

" Function: lh#dev#cpp#types#is_view(type)                    : bool {{{3
" string_view, span, ...
function! lh#dev#cpp#types#is_view(type) abort
  return a:type =~ '\v_view>|<span>'
endfunction

" Function: lh#dev#cpp#types#is_smart_ptr(type)               : bool {{{3
function! lh#dev#cpp#types#is_smart_ptr(type) abort
  let regex = lh#ft#option#get('smart_ptr_pattern', 'cpp')
  if lh#option#is_set(regex) && a:type =~ regex
    return 1
  elseif a:type =~ '\v^<owner>\<.*\*\s*\>\s*$'
    " Special case: owner<T*>
    return 1
  endif
  return a:type =~ '\v(_ptr|<not_null>|<span>)(\<.*\>)=\s*$'
endfunction

" Function: lh#dev#cpp#types#is_not_owning_ptr(type)          : bool {{{3
function! lh#dev#cpp#types#is_not_owning_ptr(type) abort
  if     a:type =~ '\v\*\s*$'
    return lh#ft#option#get('is_following_CppCoreGuideline', 'cpp', 0)
    " Meaning, own<T*> is defined, and no own<> <=> no need to copy
  elseif a:type =~ '\v(auto|unique|scoped|shared)_ptr'
    return 0
  elseif a:type =~ '\v<owner>'
    return 0
  else
    return 1
  endif
endfunction

" Function: lh#dev#cpp#types#remove_ptr(type)                 : string {{{3
" @pre: type is a pointer type
function! lh#dev#cpp#types#remove_ptr(type) abort
  if     a:type =~ '\v\*\s*$'
    return substitute(a:type, '\v\s*\*\s*$', '', '')
  elseif a:type =~ '\v<(owner|not_null)\<.*\>\s*$' " <- CppCoreGuidelines
    return matchstr(a:type, '\v<(owner|not_null)\<\zs.*\ze\s*\*\s*\>\s*$')
  elseif a:type =~ '\v\<.*\>\s*$'
    return matchstr(a:type, '\v\<\s*\zs.{-}\ze\s*\>\s*$')
  endif
  " TODO: have an option to help get the right trait, or a substitte expression
  throw "lh#dev#cpp#remove_ptr: don't know how to remove pointer qualification from type"
endfunction

" ## Overridden functions {{{1

" # Type Deduction {{{2
" Function: lh#dev#cpp#types#_deduce(expr) {{{3
function! lh#dev#cpp#types#_deduce(expr)
  " 1- C++ 11 or more ?
  runtime autoload/lh/cpp.vim
  if exists('*lh#cpp#use_cpp11') && lh#cpp#use_cpp11()
    return 'auto'
  endif
  " 2- fallback to C/type
  return lh#dev#c#types#_deduce(a:expr)
endfunction

" Function: lh#dev#cpp#types#_of_var(name, ...) {{{3
function! lh#dev#cpp#types#_of_var(name, ...) abort
  try
    let p = getpos('.')
    let cleanup = lh#on#exit()
          \.register('call setpos(".",'.string(p).')')
    if a:name =~ '^\s*$'
      return call('s:NoDecl', [a:name]+a:000)
    endif
    if searchdecl(a:name) == 0
      " First: let Vim find the variable definitions
      let def_line = getline('.')
      call s:Verbose('Definition of %1 found line %2: %3', a:name, line('.'), def_line)
    else
      " Then: search in the tags DB (it may be an attribute from the current
      " class)
      let cleanup = cleanup
            \.register('call lh#dev#end_tag_session()')
      let tags = lh#dev#start_tag_session()
      let pat = '.*\<'.a:name.'\>.*'
      " FIXME: get the scopename of the current function as well=> ClassName::foobar()
      " TODO: And move the function into lh-dev!!!
      let classname = lh#cpp#AnalysisLib_Class#CurrentScope(line('.'), 'class')
      let defs = filter(copy(tags), 'v:val.name =~ classname."::".pat || (v:val.name =~ pat && s:GetClassName(v:val) =~ classname)')
      call s:Verbose('Attributes of %1 matching %2: %3', classname, pat, defs)
      let t_vars  = lh#list#copy_if(defs, [], 'v:1_.kind =~ "[lvx]"')
      if empty(t_vars)
        return call('s:NoDecl', [a:name]+a:000)
      elseif len(t_vars) == 1
        let def_line = t_vars[0].cmd
      else
        throw "Too many matching variables"
      endif
    endif
    " TODO: In order to correctly extract the declaration, try to exploit `/\%#`
    " Trim trailing chars
    let def_line = substitute(def_line, '\s*;\s*$\|\s*=.*', '', '')
    " In case of functions, keep only the parameters
    let def_line = substitute(def_line, '^.*(\|).*$', '', 'g')
    " Trim leading whitespaces
    let def_line = substitute(def_line, '^\s*', '', '')
    let def = split(def_line, ',') " split function lists
    call filter(def, 'v:val =~ "\\<".a:name."\\s*$"')
    let var = lh#dev#option#call('function#_analyse_parameter', &ft, def[0])
    return var.type
  finally
    call cleanup.finalize()
  endtry
endfunction

" ## Internal functions {{{1

" Function: s:NoDecl(name, [default]) {{{3
function! s:NoDecl(name, ...) abort
  if a:0 == 0
    throw "Cannot find variable <".a:name."> declaration. Impossible to deduce its type."
  else
    return a:1
  endif
endfunction

" Function: s:GetClassName(dict) {{{3
function! s:GetClassName(dict) abort
  return get(a:dict, "class", get(a:dict, "struct", ""))
endfunction

" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" Vim: let b:UTfiles = 'tests/lh/dev-cpptypes.vim'
" vim600: set fdm=marker:
