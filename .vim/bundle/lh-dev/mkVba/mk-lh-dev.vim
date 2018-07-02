"=============================================================================
" File:         mkVba/mk-lh-dev.vim                               {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"               <URL:http://github.com/LucHermitte/lh-dev>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-dev/blob/master/License.md>
" Version:      2.0.0
let s:version = '2.0.0'
" Created:      02nd Mar 2012
"------------------------------------------------------------------------
" Description:
"       vimball archive builder for lh-dev
"
"------------------------------------------------------------------------
" Installation:
"       Drop this file into {rtp}/mkVba
"       Requires Vim7+
" }}}1
"=============================================================================

let s:project = 'lh-dev'
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
autoload/lh/dev.vim
autoload/lh/dev/attribute.vim
autoload/lh/dev/c/attribute.vim
autoload/lh/dev/c/function.vim
autoload/lh/dev/class.vim
autoload/lh/dev/cpp.vim
autoload/lh/dev/cpp/function.vim
autoload/lh/dev/cpp/types.vim
autoload/lh/dev/cs/attribute.vim
autoload/lh/dev/editorconfig.vim
autoload/lh/dev/function.vim
autoload/lh/dev/instruction.vim
autoload/lh/dev/java/attribute.vim
autoload/lh/dev/naming.vim
autoload/lh/dev/option.vim
autoload/lh/dev/snippet.vim
autoload/lh/dev/style.vim
autoload/lh/dev/style/__braces.vim
autoload/lh/dev/style/breakbeforebraces.vim
autoload/lh/dev/style/curly_bracket_next_line.vim
autoload/lh/dev/style/empty_braces.vim
autoload/lh/dev/style/indent_brace_style.vim
autoload/lh/dev/style/spaces_around_brackets.vim
autoload/lh/dev/style/spacesbeforeparens.vim
autoload/lh/dev/style/spacesinemptyparentheses.vim
autoload/lh/dev/style/spacesinparentheses.vim
autoload/lh/dev/tags.vim
autoload/lh/dev/vim/function.vim
doc/lh-dev.txt
addon-info.txt
lh-dev.README
plugin/dev.vim
plugin/boundaries.vim
tests/lh/dev-comments.vim
tests/lh/dev-naming.vim
tests/lh/dev-params.vim
tests/lh/dev-style.vim
VimFlavor
