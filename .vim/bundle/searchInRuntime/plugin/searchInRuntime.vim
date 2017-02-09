" ======================================================================
" File:		plugin/searchInRuntime.vim
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
" 		<URL:http://github.com/LucHermitte/SearchInRuntime>
" Last Update:  17th Jan 2017
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/SearchInRuntime/tree/master/Licence.md>
" Version:	3.1.0
"
" Purpose:	Search a file in the runtime path, $PATH, or any other
"               variable, and execute an Ex command on it.
" ======================================================================
" History: {{{
"	Version 3.1.0
"	(*) Move functions to autoload plugin
"	Version 3.0.4
"	(*) Resist to filenames with spaces -> using |fnameescape()|
"	Version 3.0.3
"	(*) <c-w>f and <c-w>v also work on visual selection
"	Version 3.0.2
"	(*) :split-open functions accept "file:line" as parameter (bugfix)
"	(*) :split-open functions accepts "file:line:col" as parameter (bugfix)
"	Version 3.0.1
"	(*) :split-open functions accepts "file:line" as parameter
"	Version 3.0.0
"	(*) GPLv3
"	Version 2.1.10
"	(*) More explicit "No file found" error message
"	Version 2.1.9
"	(*) <c-w>f will support shell pathnames like "${HOME}/.vim"
"	Version 2.1.7
"	(*) It wasn't able to expand paths on windows because of fnamemodify()
"	that returns '.' instead of an empty string.
"	Version 2.1.6
"	(*) extracts paths from options specifications like "-I/usr/include" or
"	"--option=path"
"	(*) Requires lh#List#Match()
"	Version 2.1.5
"	(*) Use the new lh#path#simplify(), and lh#path#strip_common() functions
"	Version 2.1.4
"	(*) Generic code moved to autoload plugins.
"	(*) New command: :Whereis
"	Version 2.1.3
"	(*) Bug fix: regression introduced on gf and CTRL-W_f since bang can be
"	    used on :G*Split (v2.1.2).
"	(*) Completely different mapping for CTRL-W_v, it may break default
"	    keybinding
"	    => todo option
"	(*) UTF-8 bug fix for :GSplit
"	(*) :GSplit gets rid of doublons
"	Version 2.1.2
"	(*) New behavior for :GSplit and :GVSplit:
"	    If a matching file is already opened in a window, jump to the
"	    window, even if several files match the globing pattern.
"	(*) Bang for :GSplit and :GVSplit
"	    -> ask which file to jump to even if one is already opened.
"	Version 2.1.1
"	(*) Completion rules fixed for :GSplit and :GVSplit
"	(*) Bug fix: absolute paths (with :G*Split and CTRL-W_f) incorrectly
"	    handled
"	(*) Bug fix: paths with spaces (e.g. c:/Program files/...) were split
"	(*) Bug fix: s:StripCommon() did not stop at directories boundaries
"	(*) Options to choose the commands for :GSplit and :GVSplit
"	    -> g:sir_goto_hsplit and g:sir_goto_vsplit.
"	(*) gf and CTRL-W_f support UNC paths, URLs, ...
"	Version 2.1.0
"	(*) Select one file from a list of files matching
"	    -> gf, <c-w>f
"	       :GSplit, :GVSplit
"	(*) Bug fix when several parameters were given to |0
"	    -> «SearchInRuntime grepadd *.vim |0 -w aug» is ok now
"	    todo: check if this introduces regressions or not
"
"	Version 2.0.4
"	(*) Bug fixed. The patch from v1.6d was incomplete.
"	    :SearchInVar accepts ':' as path separator in directories lists.
"	Version 2.0.3
"	(*) New command: :Runtime that wraps :runtime, but adds a support for
"	    auto completion.
"	Version 2.0.2
"	(*) New commands: :Sp and :Vsp that (vertically) split open files from
"	    the &path. auto completion supported.
"	Version 2.0.1
"	(*) Autocompletion for commands, paths and variables
"	    (Many thanks to Bertram Scharpf and Hari Krishna Dara on Vim mailing
"	    list for their valuable information)
"
"	Version 1.6d:
"	(*) Bug fixed with non win32 versions of Vim:
"	    :SearchInPATH accepts ':' as a path separator in $PATH.
"	Version 1.6c:
"	(*) Bug fixed with non win32 versions of Vim: no more
"            %Undefined variable ss
"            %Invalid expression ss
"	Version 1.6b:
"	(*) Minor changes in the comments
"	Version 1.6:
"	(*) :SearchInENV has become :SearchInVar.
"	Version 1.5:
"	(*) The commands passed to the different :SearchIn* commands can
"	    accept any number of arguments before the names of the files found.
"	    To use them, add at the end of the :SearchIn* command: a pipe+0
"	    (' |0 ') and then the list of the other parameters.
"	Version 1.4:
"	(*) Fix a minor problem under Windows when VIM is launched from the
"	    explorer.
"	Version 1.3:
"	(*) The commands passed to the different :SearchIn* commands can
"	    accept any number of arguments after the names of the files found.
"	    To use them, add at the end of the :SearchIn* command: a pipe
"	    (' | ') and then the list of the other parameters.
"	Version 1.2b:
"	(*) Address obfuscated for spammers
"	Version 1.2:
"	(*) Add continuation lines support ; cf 'cpoptions'
"	Version 1.1:
"	(*) Support the '&verbose' option :
"	     >= 0 -> display 'no file found'.
"	     >= 2 -> display the list of files found.
"	     >= 3 -> display the list of directories searched.
"	(*) SearchInPATH : like SearchInRuntime, but with $PATH
"	(*) SearchInENV : work on any list of directories defined in an
"	    environment variable.
"	(*) Define the classical debug command : Echo
"	(*) Contrary to 'runtime', the search can accept absolute paths ;
"	    for instance,
"	    	runtime! /usr/local/share/vim/*.vim
"	    is not valid while
"	    	SearchInRuntime source /usr/local/share/vim/*.vim
"	    is accepted.
"
"	Version 1.0 : initial version
" }}}
"
" Todo: {{{
" 	(*) Should be able to interpret absolute paths stored in environment
" 	    variables ; e.g: SearchInRuntime Echo $VIM/*vimrc*
" 	(*) Absolute paths should not shortcut the order of the file globing
" 	    patterns ; see: SearchInENV! $PATH Echo *.sh /usr/local/vim/*
" }}}
"
" Examples: {{{
" 	(*) :SearchInVar $INCLUDE sp vector
" 	    Will (if $INCLUDE is correctly set) open in a |split| window (:sp)
" 	    the C++ header file vector.
"
"    	(*) :let g:include = $INCLUDE
"    	    :SearchInVar g:include Echo *
"	    Will echo the name of all the files present in the directories
"	    specified in $INCLUDE.
"
"	(*) :SearchInRuntime! Echo plugin/*foo*.vim | final arguments
"	    For every file name plugin/*foo*.vim in the 'runtimepath', this
"	    will execute:
"		:Echo {path-to-the-file} final arguments
"
"	(*) :SearchInRuntime! grep plugin/*foo*.vim |0 text
"	    For every file name plugin/*foo*.vim in the 'runtimepath', this
"	    will execute:
"		:grep text {path-to-the-file}
"
"	(*) :SearchInRuntime! source here/foo*.vim
"	    is equivalent to:
"		:runtime! here/foo*.vim
"
"	(*) :silent exe 'SearchInRuntime 0r there/that.'.&ft
"	    Will:
"	    - search the 'runtimepath' list for the first file named
"	    "that.{filetype}" present in the directory "there",
"	    - and insert it in the current buffer.
"	    If no file is found, nothing is done.
"
" }}}
" ========================================================================
" Anti-reinclusion guards                                  {{{1
let s:cpo_save = &cpo
set cpo&vim
if exists("g:loaded_searchInRuntime")
      \ && !exists('g:force_reload_searchInRuntime')
  let &cpo = s:cpo_save
  finish
endif
let g:loaded_searchInRuntime = 310

" Anti-reinclusion guards                                  }}}1
" ========================================================================
" Commands                                                 {{{1

" Generic commands {{{2
command! -nargs=+ -complete=custom,lh#sir#complete -bang
      \       SearchInRuntime	call lh#sir#SearchInRuntime("<bang>",  <f-args>)
command! -nargs=+ -complete=custom,lh#sir#complete -bang
      \       SearchInVar	call lh#sir#SearchInVar    ("<bang>", <f-args>)
command! -nargs=+ -complete=custom,lh#sir#complete -bang
      \       SearchInPATH	call lh#sir#SearchInPATH   ("<bang>", <f-args>)

" Specialized commands {{{2
command! -nargs=+ -complete=custom,lh#sir#complete -bang
      \       Runtime		:runtime<bang> <args>
command! -nargs=+ -complete=custom,lh#sir#complete -bang
      \       Split		:SearchInVar<bang> &path sp <args>
command! -nargs=+ -complete=custom,lh#sir#complete -bang
      \       Vsplit		:SearchInVar<bang> &path vsp <args>
command! -nargs=1 -complete=custom,lh#sir#complete -bang
      \       Whereis		:echo globpath(&path,'*<args>*')

if !exists('!Echo')
  command! -nargs=+ Echo echo "<args>"
endif

" Open one file among several... {{{2
nnoremap <silent> gf
      \ :call lh#sir#OpenWith('nobang', 'e', &path, expand('<cfile>'))<cr>
nnoremap <silent> glf
      \ :echo globpath(&path, expand('<cfile>'))<cr>
nnoremap <silent> <c-w>f
      \ :call lh#sir#OpenWith('nobang', 'sp', &path, expand('<cfile>'))<cr>
nnoremap <silent> <c-w>v
      \ :call lh#sir#OpenWith('nobang', 'vsp', &path, expand('<cfile>'))<cr>
xnoremap <silent> <c-w>f
      \ :call lh#sir#OpenWith('nobang', 'sp', &path, expand(lh#visual#selection()))<cr>
xnoremap <silent> <c-w>v
      \ :call lh#sir#OpenWith('nobang', 'vsp', &path, expand(lh#visual#selection()))<cr>

let s:cmd0 = 'command! -bang -nargs=+ -complete=custom,lh#sir#complete '
let s:cmd1h = lh#option#get_non_empty('sir_goto_hsplit', 'GSplit', 'g')
let s:cmd1v = lh#option#get_non_empty('sir_goto_vsplit', 'VGSplit', 'g')

function! s:cmd2(cmd)
  return ' call lh#sir#OpenWith("<bang>","'.a:cmd.'", &path, <f-args>)'
endfunction

exe s:cmd0 . s:cmd1h . s:cmd2('sp')
exe s:cmd0 . s:cmd1v . s:cmd2('vsp')

" }}}1
let &cpo = s:cpo_save
" ========================================================================
" vim60: set foldmethod=marker:
