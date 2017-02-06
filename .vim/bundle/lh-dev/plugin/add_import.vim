"=============================================================================
" File:         plugin/add_import.vim                             {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} gmail {dot} com>
"		<URL:http://github.com/LucHermitte/lh-dev>
" Version:      1.2.2.
let s:k_version = '122'
" Created:      22nd Apr 2015
" Last Update:  22nd Apr 2015
"------------------------------------------------------------------------
" Description:
"       This plugin defines a mapping to insert missing includes/imports
"       (given we know which symbol shall be defined...)
"
"------------------------------------------------------------------------
" History:
"       1.2.2: Moved from lh-cpp/ftplugin/c/c_AddInclude.vim
" TODO:
"       Handle the case where several files are found
"       Move to autoload plugin
"       Recognize commented includes/imports
"       Check for files already included in foo.h, from foo.cpp
" }}}1
"=============================================================================

" Avoid global reinclusion {{{1
if &cp || (exists("g:loaded_add_import")
      \ && (g:loaded_add_import >= s:k_version)
      \ && !exists('g:force_reload_add_import'))
  finish
endif
let g:loaded_add_import = s:k_version
let s:cpo_save=&cpo
set cpo&vim
" Avoid global reinclusion }}}1
"------------------------------------------------------------------------
" Mappings {{{1

nnoremap <silent> <Plug>InsertImport :call lh#dev#import#_insert_import()<cr>
if !hasmapto('<Plug>InsertImport', 'n')
  nmap <silent> <unique> <c-x>i <Plug>InsertImport
endif

vnoremap <silent> <Plug>InsertImport <c-\><c-n>:call lh#dev#import#_insert_import(lh#visual#selection())<cr>
if !hasmapto('<Plug>InsertImport', 'v')
  vmap <silent> <unique> <c-x>i <Plug>InsertImport
endif

" Mappings }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
