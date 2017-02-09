"=============================================================================
" File:		mk-SiR.vim
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://github.com/LucHermitte/SearchInRuntime>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/SearchInRuntime/License.md>
" Version:	3.1.0
let s:version = '3.1.0'
" Created:	06th Nov 2007
" Last Update:	03rd Jan 2017
"------------------------------------------------------------------------
cd <sfile>:p:h
try
  let save_rtp = &rtp
  let &rtp = expand('<sfile>:p:h:h').','.&rtp
  exe '23,$MkVimball! searchInRuntime-'.s:version
  set modifiable
  set buftype=
finally
  let &rtp = save_rtp
endtry
finish
License.md
README.md
VimFlavor
addon-info.json
autoload/lh/sir.vim
doc/searchInRuntime.txt
plugin/searchInRuntime.vim
