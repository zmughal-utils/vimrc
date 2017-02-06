"=============================================================================
" File:		tests/lh/dev-option.vim                           {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"               <URL:http://github.com/LucHermitte/lh-dev>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-dev/tree/master/License.md>
" Version:      2.0.0
let s:k_version = 200
" Created:	05th Oct 2009
" Last Update:	16th Oct 2016
"------------------------------------------------------------------------
" Description:
"       Test lh#dev#options#*() functions
"       Run the test with :UTRun %
" }}}1
"=============================================================================

UTSuite [lh-dev-lib] Testing lh#dev#option functions

let s:cpo_save=&cpo
set cpo&vim

" ## Dependencies {{{1
runtime autoload/lh/dev/option.vim
runtime autoload/lh/ft/option.vim
runtime autoload/lh/project.vim
runtime autoload/lh/let.vim
runtime autoload/lh/option.vim
runtime autoload/lh/os.vim

let cleanup = lh#on#exit()
      \.restore('g:force_reload_lh_project')
      " \.restore('g:lh#project.permissions.whitelist')
try
  let g:lh#project.permissions.whitelist = []
  runtime plugin/lh-project.vim
finally
  call cleanup.finalize()
endtry

let s:prj_varname = 'b:'.get(g:, 'lh#project#varname', 'crt_project')

"------------------------------------------------------------------------
" ## Fixture {{{1
function! s:Setup() " {{{2
  let s:prj_list = lh#project#_save_prj_list()
  let s:prj_list.projects = {}
  " call lh#project#_restore_prj_list([])
  " Assert empty(s:prj_list)
  let s:cleanup = lh#on#exit()
        \.restore('b:'.s:prj_varname)
        \.restore('s:prj_varname')
        \.restore('g:lh#project.auto_discover_root')
        " \.register({-> lh#project#_restore_prj_list(s:prj_list)})
  let g:lh#project = { 'auto_discover_root': 'no' }
  if exists('b:'.s:prj_varname)
    exe 'unlet b:'.s:prj_varname
  endif
endfunction

function! s:Teardown() " {{{2
  call s:cleanup.finalize()
  call lh#project#_restore_prj_list(s:prj_list)
endfunction

"------------------------------------------------------------------------
" ## Tests {{{1
"------------------------------------------------------------------------
function! s:Test_global()
  let cleanup = lh#on#exit()
        \.restore('g:foo')
        \.restore('b:foo')
        \.restore('g:FT_foo')
        \.restore('b:FT_foo')
  try
    Unlet g:foo
    Unlet b:foo
    Unlet g:FT_foo
    Unlet b:FT_foo
    let g:foo = 42
    AssertEquals(lh#option#get('foo', 12) , 42)
    AssertEquals(lh#ft#option#get('foo', 'FT', 12) , 42)
    AssertEquals(lh#ft#option#get('bar', 'FT', 12) , 12)
    AssertEquals(lh#dev#option#get('foo', 'FT', 12) , 42)
    AssertEquals(lh#dev#option#get('bar', 'FT', 12) , 12)

    let b:foo = 43
    AssertEquals(lh#dev#option#get('foo', 'FT', 12) , 43)

    let g:FT_foo = 44
    AssertEquals(lh#dev#option#get('foo', 'FT', 12) , 44)

    let b:FT_foo = 45
    AssertEquals(lh#dev#option#get('foo', 'FT', 12) , 45)
  finally
    call cleanup.finalize()
  endtry
endfunction

function! s:Test_local()
  let cleanup = lh#on#exit()
        \.restore('b:foo')
        \.restore('g:FT_foo')
        \.restore('b:FT_foo')
  try
    let b:foo = 43
    AssertEquals(lh#dev#option#get('foo', 'FT', 12) , 43)

    let g:FT_foo = 44
    AssertEquals(lh#dev#option#get('foo', 'FT', 12) , 44)

    let b:FT_foo = 45
    AssertEquals(lh#dev#option#get('foo', 'FT', 12) , 45)
  finally
    call cleanup.finalize()
  endtry
endfunction

function! s:Test_FT_global()

  let cleanup = lh#on#exit()
        \.restore('g:FT_foo')
        \.restore('b:FT_foo')
  try
    let g:FT_foo = 44
    AssertEquals(lh#dev#option#get('foo', 'FT', 12) , 44)

    let b:FT_foo = 45
    AssertEquals(lh#dev#option#get('foo', 'FT', 12) , 45)
  finally
    call cleanup.finalize()
  endtry
endfunction

" Function: s:Test_inheritedFT() {{{3
function! s:Test_inheritedFT()
  AssertEquals(lh#dev#option#inherited_filetypes('zz') , ['zz'])
  AssertEquals(lh#dev#option#inherited_filetypes('c') , ['c'])
  AssertEquals(lh#dev#option#inherited_filetypes('cpp') , ['cpp', 'c'])

  let cleanup = lh#on#exit()
        \.restore('g:foo1_inherits')
        \.restore('g:foo2_inherits')
        \.restore('b:foo3_inherits')
  try
    let g:foo1_inherits = 'foo'
    let g:foo2_inherits = 'foo1'
    let b:foo3_inherits = 'foo1,foo'
    AssertTxt (lh#dev#option#inherited_filetypes('foo') == ['foo'],
          \ 'foo inherits from '.string(lh#dev#option#inherited_filetypes('foo')))
    AssertTxt (lh#dev#option#inherited_filetypes('foo1') == ['foo1', 'foo'],
          \ 'foo1 inherits from '.string(lh#dev#option#inherited_filetypes('foo1')))
    AssertTxt (lh#dev#option#inherited_filetypes('foo2') == ['foo2', 'foo1', 'foo'],
          \ 'foo2 inherits from '.string(lh#dev#option#inherited_filetypes('foo2')))
    AssertTxt (lh#dev#option#inherited_filetypes('foo3') == ['foo3', 'foo1', 'foo', 'foo'],
          \ 'foo3 inherits from '.string(lh#dev#option#inherited_filetypes('foo3')))
  finally
    call cleanup.finalize()
  endtry
endfunction

" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
