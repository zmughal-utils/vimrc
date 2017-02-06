"=============================================================================
" File:         plugin/boundaries.vim                             {{{1
" Author:       Luc Hermitte <EMAIL:luc {dot} hermitte {at} gmail {dot} com>
"		<URL:http://github.com/LucHermitte/lh-dev>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-dev/tree/master/License.md>
" Version:      1.5.0.2.
let s:k_version = '1502'
" Created:      25th May 2016
" Last Update:  25th May 2016
"------------------------------------------------------------------------
" Description:
"       Select function boundaries
" }}}1
"=============================================================================

" Avoid global reinclusion {{{1
if &cp || (exists("g:loaded_boundaries")
      \ && (g:loaded_boundaries >= s:k_version)
      \ && !exists('g:force_reload_boundaries'))
  finish
endif
let g:loaded_boundaries = s:k_version
let s:cpo_save=&cpo
set cpo&vim
" Avoid global reinclusion }}}1
"------------------------------------------------------------------------
" Commands and Mappings {{{1
onoremap <silent> if :<c-u>call lh#dev#_select_current_function()<cr>
xnoremap <silent> if :<c-u>call lh#dev#_select_current_function()<cr><esc>gv
" Commands and Mappings }}}1
"------------------------------------------------------------------------
" Functions {{{1
" Note: most functions are best placed into
" autoload/«your-initials»/«boundaries».vim
" Keep here only the functions are are required when the plugin is loaded,
" like functions that help building a vim-menu for this plugin.
" Functions }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
