"=============================================================================
" File:         tests/lh/dev-params.vim                           {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://github.com/LucHermitte/lh-dev>
" Version:      1.5.1
" Created:      31st May 2010
" Last Update:  23rd May 2016
"------------------------------------------------------------------------
" Description:
"       Unit Tests for lh#dev#c#function# functions
"
"------------------------------------------------------------------------
" Installation:
"       Drop this file into {rtp}/tests/lh
"       Requires Vim7+
" History:      ?history?
" TODO:         ?missing features?
" }}}1
"=============================================================================

UTSuite [lh-dev] Testing lh#dev#function parameters analysing functions
runtime autoload/lh/dev/option.vim
runtime autoload/lh/dev/function.vim
runtime autoload/lh/dev/c/function.vim

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
function! s:Test_Param_data()
  let pa = lh#dev#c#function#_analyse_parameter('int foo')
  AssertEqual(pa.name, 'foo')
  AssertEqual(pa.type, 'int')

  let pa = lh#dev#c#function#_analyse_parameter('int foo = 42')
  AssertEqual(pa.name, 'foo')
  AssertEqual(pa.type, 'int')
  AssertEqual(pa.default, '42')

  let pa = lh#dev#c#function#_analyse_parameter('int foo = f()')
  AssertEqual(pa.name, 'foo')
  AssertEqual(pa.type, 'int')
  AssertEqual(pa.default, 'f()')

  let pa = lh#dev#c#function#_analyse_parameter('int * foo', 1)
  AssertEqual(pa.name, 'foo')
  AssertEqual(pa.type, 'int*')

  let pa = lh#dev#c#function#_analyse_parameter('int ** foo', 1)
  AssertEqual(pa.name, 'foo')
  AssertEqual(pa.type, 'int**')

  let pa = lh#dev#c#function#_analyse_parameter('int *& foo', 1)
  AssertEqual(pa.name, 'foo')
  AssertEqual(pa.type, 'int*&')

  let pa = lh#dev#c#function#_analyse_parameter('int * foo = 0', 1)
  AssertEqual(pa.name, 'foo')
  AssertEqual(pa.type, 'int*')
  AssertEqual(pa.default, '0')

  let pa = lh#dev#c#function#_analyse_parameter('int* foo', 1)
  AssertEqual(pa.name, 'foo')
  AssertEqual(pa.type, 'int*')

  let pa = lh#dev#c#function#_analyse_parameter('int** foo', 1)
  AssertEqual(pa.name, 'foo')
  AssertEqual(pa.type, 'int**')

  let pa = lh#dev#c#function#_analyse_parameter('int*& foo', 1)
  AssertEqual(pa.name, 'foo')
  AssertEqual(pa.type, 'int*&')

  let pa = lh#dev#c#function#_analyse_parameter('int* foo = 0', 1)
  AssertEqual(pa.name, 'foo')
  AssertEqual(pa.type, 'int*')
  AssertEqual(pa.default, '0')

  let pa = lh#dev#c#function#_analyse_parameter('int*foo', 1)
  AssertEqual(pa.name, 'foo')
  AssertEqual(pa.type, 'int*')

  let pa = lh#dev#c#function#_analyse_parameter('int**foo', 1)
  AssertEqual(pa.name, 'foo')
  AssertEqual(pa.type, 'int**')

  let pa = lh#dev#c#function#_analyse_parameter('int*&foo', 1)
  AssertEqual(pa.name, 'foo')
  AssertEqual(pa.type, 'int*&')

  let pa = lh#dev#c#function#_analyse_parameter('int*foo = 0', 1)
  AssertEqual(pa.name, 'foo')
  AssertEqual(pa.type, 'int*')
  AssertEqual(pa.default, '0')

  let pa = lh#dev#c#function#_analyse_parameter('int *foo', 1)
  AssertEqual(pa.name, 'foo')
  AssertEqual(pa.type, 'int*')

  let pa = lh#dev#c#function#_analyse_parameter('int **foo', 1)
  AssertEqual(pa.name, 'foo')
  AssertEqual(pa.type, 'int**')

  let pa = lh#dev#c#function#_analyse_parameter('int *&foo', 1)
  AssertEqual(pa.name, 'foo')
  AssertEqual(pa.type, 'int*&')

  let pa = lh#dev#c#function#_analyse_parameter('int *foo = 0', 1)
  AssertEqual(pa.name, 'foo')
  AssertEqual(pa.type, 'int*')
  AssertEqual(pa.default, '0')

  let pa = lh#dev#c#function#_analyse_parameter('long int foo')
  AssertEqual(pa.name, 'foo')
  AssertEqual(pa.type, 'long int')

  let pa = lh#dev#c#function#_analyse_parameter('unsigned long long int foo')
  AssertEqual(pa.name, 'foo')
  AssertEqual(pa.type, 'unsigned long long int')

  let pa = lh#dev#c#function#_analyse_parameter('unsigned long foo[42]')
  AssertEqual(pa.name, 'foo')
  AssertEqual(pa.type, 'unsigned long[]')

  let pa = lh#dev#c#function#_analyse_parameter('unsigned long foo [42][45]')
  AssertEqual(pa.name, 'foo')
  AssertEqual(pa.type, 'unsigned long[][45]')

  let pa = lh#dev#c#function#_analyse_parameter('unsigned long (*foo) [42]')
  AssertEqual(pa.name, 'foo')
  AssertEqual(pa.type, 'unsigned long(*)[42]')

  let pa = lh#dev#c#function#_analyse_parameter('std::vector<long int> foo')
  AssertEqual(pa.name, 'foo')
  AssertEqual(pa.type, 'std::vector<long int>')

  let pa = lh#dev#c#function#_analyse_parameter('std::vector<long int> const& foo')
  AssertEqual(pa.name, 'foo')
  AssertEqual(pa.type, 'std::vector<long int> const&')

  let pa = lh#dev#c#function#_analyse_parameter('int (*foo)(int, double)[42]')
  AssertEqual(pa.name, 'foo')
  AssertEqual(pa.type, 'int (*)(int, double)[]')

  " todo: add pointer to functions, lambdas
endfunction
"------------------------------------------------------------------------
function! s:Test_split_params()
  let p = lh#dev#c#function#_split_list_of_parameters('toto t=42, titi r, tutu z=f()')
  AssertEqual(p[0], 'toto t=42')
  AssertEqual(p[1], 'titi r')
  AssertEqual(p[2], 'tutu z=f()')

  let p = lh#dev#c#function#_split_list_of_parameters('toto t=42, std::string const& s, char * p, int[] i, titi r, tutu z=f()')
  AssertEqual(p[0], 'toto t=42')
  AssertEqual(p[1], 'std::string const& s')
  AssertEqual(p[2], 'char * p')
  AssertEqual(p[3], 'int[] i')
  AssertEqual(p[4], 'titi r')
  AssertEqual(p[5], 'tutu z=f()')

  let p = lh#dev#c#function#_split_list_of_parameters('toto t=42, std::string const&, char * p, int[] i, std::vector<short>, titi r, tutu z=f()')
  AssertEqual(p[0], 'toto t=42')
  AssertEqual(p[1], 'std::string const&')
  AssertEqual(p[2], 'char * p')
  AssertEqual(p[3], 'int[] i')
  AssertEqual(p[4], 'std::vector<short>')
  AssertEqual(p[5], 'titi r')
  AssertEqual(p[6], 'tutu z=f()')

  let p = lh#dev#c#function#_split_list_of_parameters('toto t=42, std::string const&, Tpl<T1, T2, int>, titi r, tutu z=f(g(12),5)')
  AssertEqual(p[0], 'toto t=42')
  AssertEqual(p[1], 'std::string const&')
  " spaces are trimmed
  AssertEqual(p[2], 'Tpl<T1,T2,int>')
  AssertEqual(p[3], 'titi r')
  AssertEqual(p[4], 'tutu z=f(g(12),5)')

endfunction
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
