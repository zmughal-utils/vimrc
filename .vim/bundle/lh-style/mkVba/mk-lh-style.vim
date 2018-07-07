"=============================================================================
" File:         mkVba/mk-lh-style.vim                               {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"               <URL:http://github.com/LucHermitte/lh-style
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-style/blob/master/License.md>
" Version:      1.0.0
let s:version = '1.0.0'
" Created:      02nd Mar 2012
"------------------------------------------------------------------------
" Description:
"       vimball archive builder for lh-style
"
"------------------------------------------------------------------------
" Installation:
"       Drop this file into {rtp}/mkVba
"       Requires Vim7+
" }}}1
"=============================================================================

let s:project = 'lh-style'
cd <sfile>:p:h
try
  let save_rtp = &rtp
  let &rtp = expand('<sfile>:p:h:h').','.&rtp
  exe '33,$MkVimball! '.s:project.'-'.s:version
  set modifiable
  set buftype=
finally
  let &rtp = save_rtp
endtry
finish
autoload/lh/naming.vim
autoload/lh/style.vim
autoload/lh/style/__braces.vim
autoload/lh/style/__editorconfig.vim
autoload/lh/style/breakbeforebraces.vim
autoload/lh/style/curly_bracket_next_line.vim
autoload/lh/style/empty_braces.vim
autoload/lh/style/indent_brace_style.vim
autoload/lh/style/spaces_around_brackets.vim
autoload/lh/style/spacesbeforeparens.vim
autoload/lh/style/spacesinemptyparentheses.vim
autoload/lh/style/spacesinparentheses.vim
doc/lh-style.txt
addon-info.txt
plugin/style.vim
tests/lh/naming.vim
tests/lh/style.vim
VimFlavor
