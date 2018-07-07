"=============================================================================
" File:		tests/lh/naming.vim                           {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://hermitte.free.fr/vim/>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-style/License.md>
" Version:	1.0.0
" Created:	05th Oct 2009
" Last Update:	17th Oct 2017
"------------------------------------------------------------------------
" Description:
"       Unit Test for lh#naming functions
" }}}1
"=============================================================================

UTSuite [lh-style] Testing lh#naming naming functions

runtime autoload/lh/naming.vim

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
function! s:Setup()
  silent! unlet b:FT_naming_function
  silent! unlet b:FT_naming_get_subst
endfunction

"------------------------------------------------------------------------
function! s:Test_2_name()
  AssertEqual('name', lh#naming#variable('name', ''))
  AssertEqual('name', lh#naming#variable('_name'))
  AssertEqual('name', lh#naming#variable('name_'))
  AssertEqual('name', lh#naming#variable('getName'))
  AssertEqual('name', lh#naming#variable('setName'))
  AssertEqual('name', lh#naming#variable('g_name'))
  AssertEqual('name', lh#naming#variable('m_name'))
endfunction

function! s:Test_2_getter()
  AssertEqual('getName', lh#naming#getter('name', ''))
  " let b:FT_naming_get_subst = 'get_&'
  let b:FT_naming_function = 'snake_case'
  AssertEqual('get_name', lh#naming#getter('name', 'FT'))

  let b:FT_naming_function = 'UpperCamelCase'
  AssertEqual('GetName', lh#naming#getter('name', 'FT'))

  let b:FT_naming_get_subst = '&'
  AssertEqual('Name', lh#naming#getter('name', 'FT'))
endfunction

function! s:Test_2_setter()
  AssertEqual('setName', lh#naming#setter('name', ''))
  " let b:FT_naming_set_subst = 'set_&'
  let b:FT_naming_function = 'snake_case'

  AssertEqual('set_name', lh#naming#setter('name', 'FT'))
endfunction

function! s:Test_2_local()
  AssertEqual('name', lh#naming#local('name', ''))
  let b:FT_naming_local_subst = 'l_&'
  AssertEqual('l_name', lh#naming#local('name', 'FT'))
endfunction

function! s:Test_2_global()
  AssertEqual('g_name', lh#naming#global('name', ''))
  let b:FT_naming_global_subst = '&'
  AssertEqual('name', lh#naming#global('name', 'FT'))
  AssertEqual!(g:vim_naming_global_re, '\v%([algsbwt]:)=(.*)')
  AssertEqual!(g:vim_naming_global_subst, 'g:\1')

  AssertEqual!(lh#naming#variable('name', 'vim'), 'name')
  AssertEqual!(lh#naming#debug("s:Option('global_subst', 'vim', 'g_')"), 'g:\1')

  AssertEqual('g:name', lh#naming#global('name', 'vim'))
endfunction

function! s:Test_2_param()
  AssertEqual('name', lh#naming#param('name', ''))
  let b:FT_naming_param_subst = '&_'
  AssertEqual('name_', lh#naming#param('name', 'FT'))
  AssertEqual('a:name', lh#naming#param('name', 'vim'))
endfunction

function! s:Test_2_static()
  AssertEqual('s_name', lh#naming#static('name', ''))
  let b:FT_naming_static_subst = '::&'
  AssertEqual('::name', lh#naming#static('name', 'FT'))
  AssertEqual('s:name', lh#naming#static('name', 'vim'))
endfunction

function! s:Test_2_constant()
  AssertEqual('NAME', lh#naming#constant('name', ''))
  let b:FT_naming_constant_subst = 'k_&'
  AssertEqual('k_name', lh#naming#constant('name', 'FT'))
endfunction

function! s:Test_2_member()
  AssertEqual('m_name', lh#naming#member('name', ''))
  let b:FT_naming_member_subst = 'm\u&'
  AssertEqual('mName', lh#naming#member('name', 'FT'))
  let b:FT_naming_member_subst = 'this->&'
  AssertEqual('this->name', lh#naming#member('name', 'FT'))
endfunction


"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
