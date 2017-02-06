"=============================================================================
" File:		tests/lh/dev-naming.vim                           {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://hermitte.free.fr/vim/>
" Version:	0.0.1
" Created:	05th Oct 2009
" Last Update:	$Date$
"------------------------------------------------------------------------
" Description:	«description»
"
"------------------------------------------------------------------------
" Installation:	«install details»
" History:	«history»
" TODO:		«missing features»
" }}}1
"=============================================================================

UTSuite [lh-dev] Testing lh#dev#naming naming functions

runtime autoload/lh/dev/option.vim
runtime autoload/lh/dev/naming.vim

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
function! s:Setup()
  silent! unlet b:FT_naming_function
  silent! unlet b:FT_naming_get_subst
endfunction

"------------------------------------------------------------------------
function! s:Test_2_name()
  AssertEqual('name', lh#dev#naming#variable('name', ''))
  AssertEqual('name', lh#dev#naming#variable('_name'))
  AssertEqual('name', lh#dev#naming#variable('name_'))
  AssertEqual('name', lh#dev#naming#variable('getName'))
  AssertEqual('name', lh#dev#naming#variable('setName'))
  AssertEqual('name', lh#dev#naming#variable('g_name'))
  AssertEqual('name', lh#dev#naming#variable('m_name'))
endfunction

function! s:Test_2_getter()
  AssertEqual('getName', lh#dev#naming#getter('name', ''))
  " let b:FT_naming_get_subst = 'get_&'
  let b:FT_naming_function = 'snake_case'
  AssertEqual('get_name', lh#dev#naming#getter('name', 'FT'))

  let b:FT_naming_function = 'UpperCamelCase'
  AssertEqual('GetName', lh#dev#naming#getter('name', 'FT'))

  let b:FT_naming_get_subst = '&'
  AssertEqual('Name', lh#dev#naming#getter('name', 'FT'))
endfunction

function! s:Test_2_setter()
  AssertEqual('setName', lh#dev#naming#setter('name', ''))
  " let b:FT_naming_set_subst = 'set_&'
  let b:FT_naming_function = 'snake_case'

  AssertEqual('set_name', lh#dev#naming#setter('name', 'FT'))
endfunction

function! s:Test_2_local()
  AssertEqual('name', lh#dev#naming#local('name', ''))
  let b:FT_naming_local_subst = 'l_&'
  AssertEqual('l_name', lh#dev#naming#local('name', 'FT'))
endfunction

function! s:Test_2_global()
  AssertEqual('g_name', lh#dev#naming#global('name', ''))
  let b:FT_naming_global_subst = '&'
  AssertEqual('name', lh#dev#naming#global('name', 'FT'))
  AssertEqual!(g:vim_naming_global_re, '\v%([algsbwt]:)=(.*)')
  AssertEqual!(g:vim_naming_global_subst, 'g:\1')

  AssertEqual!(lh#dev#naming#variable('name', 'vim'), 'name')
  AssertEqual!(lh#dev#naming#debug("s:Option('global_subst', 'vim', 'g_')"), 'g:\1')

  AssertEqual('g:name', lh#dev#naming#global('name', 'vim'))
endfunction

function! s:Test_2_param()
  AssertEqual('name', lh#dev#naming#param('name', ''))
  let b:FT_naming_param_subst = '&_'
  AssertEqual('name_', lh#dev#naming#param('name', 'FT'))
  AssertEqual('a:name', lh#dev#naming#param('name', 'vim'))
endfunction

function! s:Test_2_static()
  AssertEqual('s_name', lh#dev#naming#static('name', ''))
  let b:FT_naming_static_subst = '::&'
  AssertEqual('::name', lh#dev#naming#static('name', 'FT'))
  AssertEqual('s:name', lh#dev#naming#static('name', 'vim'))
endfunction

function! s:Test_2_constant()
  AssertEqual('NAME', lh#dev#naming#constant('name', ''))
  let b:FT_naming_constant_subst = 'k_&'
  AssertEqual('k_name', lh#dev#naming#constant('name', 'FT'))
endfunction

function! s:Test_2_member()
  AssertEqual('m_name', lh#dev#naming#member('name', ''))
  let b:FT_naming_member_subst = 'm\u&'
  AssertEqual('mName', lh#dev#naming#member('name', 'FT'))
  let b:FT_naming_member_subst = 'this->&'
  AssertEqual('this->name', lh#dev#naming#member('name', 'FT'))
endfunction


"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
