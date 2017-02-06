"=============================================================================
" File:         tests/lh/dev-reinterpret_escaped_chars.vim        {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} gmail {dot} com>
"		<URL:http://github.com/LucHermitte/lh-dev>
" Version:      1.3.3.
let s:k_version = '133'
" Created:      04th Nov 2015
" Last Update:
"------------------------------------------------------------------------
" Description:
"       Test lh#dev#reinterpret_escaped_char
" }}}1
"=============================================================================

UTSuite [lh-dev] Testing lh#dev#reinterpret_escaped_char

runtime autoload/lh/dev.vim

let s:cpo_save=&cpo
set cpo&vim

"------------------------------------------------------------------------
function! s:Test_1()
  AssertEq(lh#dev#reinterpret_escaped_char('\<left\>'), "\<left>")
endfunction

"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
