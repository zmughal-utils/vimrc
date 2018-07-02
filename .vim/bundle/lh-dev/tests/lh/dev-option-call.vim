"=============================================================================
" File:         tests/lh/dev-option-call.vim                      {{{1
" Author:       Luc Hermitte <EMAIL:luc {dot} hermitte {at} gmail {dot} com>
"		<URL:http://github.com/LucHermitte/lh-dev>
" License:      GPLv3 w/ exception
"               <URL:http://github.com/LucHermitte/lh-dev/blob/master/License.md>
" Version:      2.0.0.
let s:k_version = '200'
" Created:      20th Feb 2018
" Last Update:  20th Feb 2018
"------------------------------------------------------------------------
" Description:
"       Unit tests for lh-dev lh#option#call* functions
" }}}1
"=============================================================================

UTSuite [lh-dev] Testing lh#dev#option#call functions

runtime autoload/lh/dev.vim
runtime autoload/lh/dev/option.vim

let s:cpo_save=&cpo
set cpo&vim

"------------------------------------------------------------------------
function! s:Test_func_funcname()
  " ## First syntax, in lh-dev
  " There is no such thing as lh#dev#cpp#foo(), nor lh#dev#c#foo()
  AssertEqual(lh#dev#option#_find_funcname('foo', 'cpp'), 'lh#dev#foo')
  " Function that exists only for C
  AssertEqual(lh#dev#option#_find_funcname('import#_do_clean_filename', 'cpp'), 'lh#dev#c#import#_do_clean_filename')
  " Function that have been specialized in C++
  AssertEqual(lh#dev#option#_find_funcname('function#_build_param_call', 'cpp'), 'lh#dev#cpp#function#_build_param_call')
  " Function that have been specialized only in C++
  AssertEqual(lh#dev#option#_find_funcname('types#is_view', 'cpp'), 'lh#dev#cpp#types#is_view')

  " ## Second syntax, for any plugin...
  " There is no such thing as lh#dev#cpp#foo(), nor lh#dev#c#foo()
  AssertEqual(lh#dev#option#_find_funcname(['lh#dev', 'foo'], 'cpp', 'lh#dev'), 'lh#dev#foo')
  " Function that exists only for C
  AssertEqual(lh#dev#option#_find_funcname(['lh#dev', 'import#_do_clean_filename'], 'cpp'), 'lh#dev#c#import#_do_clean_filename')
  " Function that have been specialized in C++
  AssertEqual(lh#dev#option#_find_funcname(['lh#dev', 'function#_build_param_call'], 'cpp'), 'lh#dev#cpp#function#_build_param_call')
  " Function that have been specialized only in C++
  AssertEqual(lh#dev#option#_find_funcname(['lh#dev', 'types#is_view'], 'cpp'), 'lh#dev#cpp#types#is_view')
endfunction

"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
