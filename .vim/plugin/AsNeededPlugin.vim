" AsNeededPlugin: provides the public interface to AsNeeded
" Author:	Charles E. Campbell
" Date:		Sep 21, 2011 - Aug 16, 2021
" Copyright:    Copyright (C) 2004-2021 Charles E. Campbell {{{1
"               Permission is hereby granted to use and distribute this code,
"               with or without modifications, provided that this copyright
"               notice is copied with it. Like anything else that's free,
"               AsNeeded.vim is provided *as is* and comes with no warranty
"               of any kind, either expressed or implied. By using this
"               plugin, you agree that in no event will the copyright
"               holder be liable for any damages resulting from the use
"               of this software.
"
" Usage: {{{1
"
" Undefined functions will be caught and loaded automatically, although
" whatever invoked them will then need to be re-run
"
" Undefined maps and commands need to be processed first:
" 	:AsNeeded map         :AN map
" 	:AsNeeded command     :AN command
" will search for the map/command for *.vim files in the AsNeeded directory.
"
" To both find and execute a command or map, use
"   :ANX map
"   :ANX command
"
" To speed up the process, generate a ANtags file
"   :MakeANtags
"
" Isaiah 42:1 : Behold, my servant, whom I uphold; my chosen, in whom {{{1
" my soul delights: I have put my Spirit on him; he will bring forth
" justice to the Gentiles.
"
" GetLatestVimScripts: 915 1 :AutoInstall: AsNeeded.vim
"redraw!|call DechoSep()|call inputsave()|call input("Press <cr> to continue")|call inputrestore()
" ---------------------------------------------------------------------
" Load Once: {{{1
if exists("g:loaded_AsNeeded") || &cp || v:version < 700
 finish
endif
if v:version < 700
 echohl WarningMsg
 echo "***warning*** this version of AsNeeded needs vim 7.0"
 echohl Normal
 finish
endif
let s:keepcpo = &cpo
set cpo&vim

" ---------------------------------------------------------------------
" Debugging Support:
"if !exists("g:loaded_Decho") | runtime plugin/Decho.vim | endif

" ---------------------------------------------------------------------
"  Public Interface:	{{{1
au FuncUndefined *       					call AsNeeded#AsNeeded(1,expand("<afile>"))
com! -nargs=+ -complete=command AsNeeded	call AsNeeded#AsNeeded(2,<q-args>)
com! -nargs=+ -complete=command AN			call AsNeeded#AsNeeded(2,<q-args>)
com! -nargs=+ -complete=command ANX			call AsNeeded#AsNeeded(3,<q-args>)
com! -nargs=0                   MakeANtags	call AsNeeded#MakeANtags()
com! -nargs=0                   MkAsNeeded	call AsNeeded#MakeANtags()

" ---------------------------------------------------------------------
"  AutoMkAsNeeded: {{{2
if exists("g:AsNeededAutoMake") && &shell != "bash"
  " typically g:AsNeededAutoMake is "ls -lt"
  " Find .vim/AsNeeded/ANtags file
  let ANtags= globpath(&rtp,"AsNeeded/ANtags")
"  call Decho("AutoMkAsNeeded:  ANtags<".ANtags.">")
  if ANtags != "" && filereadable(ANtags)
   let s:andir  = fnamemodify(ANtags,':p:h')
"   call Decho("andir<".s:andir.">")
"   call Decho("g:AsNeededAutoMake<".g:AsNeededAutoMake." ".s:andir.">")
   try
    " list files in AsNeeded directory in earliest-latest time order
	" COMBAK: following line is causing <esc>>4;2m sequences to appear when vim :q is used
	let s:anfiles= split(system(g:AsNeededAutoMake." ".shellescape(s:andir)))
   catch /^Vim\%((\a\+)\)\=:E/
    let s:anfiles= []
   endtry
"   call Decho("anfiles=".string(s:anfiles))
   " call MakeANtags() if any *.vim files appear in the anfiles list before ANtags
   for s:entry in s:anfiles
"	call Decho("s:entry<".s:entry.">")
   	if s:entry =~ '\.vim\>'
	 echomsg "auto-called MakeANtags()"
	 call AsNeeded#MakeANtags()
	 break
	elseif s:entry =~ 'ANtags'
	 break
	endif
   endfor
  else
   " ANtags file not readable/doesn't exist -- so make it
   call AsNeeded#MakeANtags()
  endif
  if exists("s:andir")  |unlet s:andir  |endif
  if exists("s:anfiles")|unlet s:anfiles|endif
  if exists("s:entry")  |unlet s:entry  |endif
endif

" ---------------------------------------------------------------------
"  Restore Cpo: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo
" ---------------------------------------------------------------------
"  Modelines: {{{1
" vim: ts=4 fdm=marker
