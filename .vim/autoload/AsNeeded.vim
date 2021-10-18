" AsNeeded: allows functions/maps to reside in .../.vim/AsNeeded/ directory
"           and will enable their loaded as needed
" Author:	Charles E. Campbell
" Date:		Jul 02, 2015 - Aug 16, 2021
" Version:	17n	ASTRO-ONLY
" Copyright:    Copyright (C) 2004-2011 Charles E. Campbell {{{1
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
let g:loaded_AsNeeded = "v17n"
let s:keepcpo         = &cpo
set cpo&vim

" ---------------------------------------------------------------------
" Debugging Support:
"   *** Don't have g:AsNeededAutoMake set when debugging ***
"let g:AsNeededAutoMake= 0                 " Decho
"if !exists("g:loaded_Decho")              " Decho
" runtime plugin/Decho.vim                 " Decho
"endif                                     " Decho
"if !exists("g:loaded_cecutil")            " Decho
" runtime AsNeeded/cecutil.vim             " Decho
"endif                                     " Decho
"DechoRemOn

" ---------------------------------------------------------------------
"  Variables As Options: {{{1
if has("gui_running") && has("menu") && &go =~# 'm'
 if !exists("g:DrChipTopLvlMenu")
  let g:DrChipTopLvlMenu= "DrChip."
 endif
endif
if !exists("g:AsNeededSuccess")
 let g:AsNeededSuccess= 1
endif

" =====================================================================
"  Functions: {{{1

" ---------------------------------------------------------------------
"  AsNeeded#AsNeeded: looks for maps in AsNeeded/*.vim using the runtimepath. {{{2
"            Returns 0=success      type=1: called via a FuncUndefined event
"                   -1=failure          =2: called by command :AsNeeded or :AN
"                                       =3: called by command :ANX
fun! AsNeeded#AsNeeded(type,cmdmap)
"  call Dfunc("AsNeeded#AsNeeded(type=".a:type.",cmdmap<".a:cmdmap.">) (".g:loaded_AsNeeded.")")
  sil! let keepcmd= histget(":",-1)
"  call Decho("(AsNeeded) keepcmd<".keepcmd.">")

  " ------------------------------
  "  special exceptions: {{{3
"  call Decho("(AsNeeded) handle special exceptions")
  if a:type == 1 && a:cmdmap =~ '#'
   " don't consider function names with '#' embedded - ie. let Bram's
   " autoload try without interference
"   call Dret("AsNeeded#AsNeeded 0 : a:cmdmap<".a:cmdmap."> has # -- let autoload work")
   return 0
  endif
  if a:type == 1 && (a:cmdmap =~ 'Tlist_' || a:cmdmap =~ 'Taglist_')
   " taglist does its own FuncUndefined style loading, so let it
"   call Dret("AsNeeded#AsNeeded 0 : a:cmdmap<".a:cmdmap."> let taglist do it")
   return 0
  endif

  " ------------------------------
  " save&set registers and options {{{3
  " ------------------------------
"  call Decho("(AsNeeded) save&set registers and options")
  call s:SaveSettings()

  " -------------------------------------------
  " initialize search for requested command/map {{{3
  " -------------------------------------------
"  call Decho("(AsNeeded) init srch for cmd/map")
  let keeplastbufnr= bufnr("$")
"  call Decho("(AsNeeded) keeplastbufnr=".keeplastbufnr)
  sil 1new! AsNeededBuffer
  let asneededbufnr= bufnr("%")
"  call Decho("(AsNeeded) created AsNeededBufer (buf#".asneededbufnr.")")
"  call Decho("(AsNeeded) asneededbufnr=".asneededbufnr)
  setlocal buftype=nofile noswapfile noro nobl

  " -----------------------
  "  check for / use ANtags {{{3
  " -----------------------
"  call Decho("(AsNeeded) chk for / use in ANtags")
  let ANtags= globpath(&rtp,"AsNeeded/ANtags")
"  call Decho("(AsNeeded) ANtags<".ANtags.">")

  if ANtags != ""
   " -----------------------------
   " ANtags file present -- use it
   " -----------------------------
"   call Decho("(AsNeeded) <ANtags> file present, using it")
   set ma
   %d _
   exe "silent 0r ".ANtags
   if bufnr('AsNeeded/ANtags') >= 1
"	call Decho("(AsNeeded) wiping buf#".bufnr('AsNeeded/ANtags')."<".bufname('AsNeeded/ANtags').">")
    exe "sil! ".bufnr('AsNeeded/ANtags')."bw!"
   endif

   " ---------------------------------------------
   " determine the home directory for AsNeeded {{{3
   " ---------------------------------------------
   let home= s:FindHome()."/AsNeeded/"

   if     a:type == 1
   	" called via a FuncUndefined event
    let srch= search("^f\t".a:cmdmap)
"	call Decho('(AsNeeded) type#1: using <ANtags>: srchstring<^f\t'.a:cmdmap."> srch=".srch)

   elseif a:type >= 2
   	" called by command :AsNeeded, :AN, or :ANX
"	call Decho("a:type=".a:type.": set up search (:AsNeeded, :AN, or :ANX)")
    let srchstring= substitute(a:cmdmap,'!\= .*$','','e')
"	call Decho("(AsNeeded) 1: srchstring<".srchstring.">")
    if exists("g:mapleader") && match(srchstring,'^'.g:mapleader) == 0
	 let srchstring= escape(srchstring,'\').substitute(srchstring,'^.\(.*\)$','\\|<[lL][eE][aA][dD][eE][rR]>\1','')
"	 call Decho("(AsNeeded) 2: srchstring<".srchstring.">")
	elseif !exists("g:mapleader") && match(srchstring,'^\\') == 0
	 let srchstring= escape(srchstring,'\').substitute(srchstring,'^.\(.*\)$','\\|<[lL][eE][aA][dD][eE][rR]>\1','')
"	 call Decho("(AsNeeded) 3: srchstring<".srchstring.">")
	endif
	let result= search('^[mc]\t\<'.srchstring.'\>')
	if result == 0
     let srch= search('^[mc]\t'.srchstring)
	else
	 let srch= result
	endif
"	call Decho("(AsNeeded) type#".a:type.", using <ANtags>: srchstring<".srchstring."> srch=".srch)
   endif

   if srch != 0
   	let curline   = getline(".")
   	let vimfile   = substitute(curline,'^\%(.\+\t\)\{2}\(.*\)$','\1','')
	if curline !~ '^f'
   	 let mapstring = curline
	endif

"	call Decho("(AsNeeded) curline<".curline.">")
"	call Decho("(AsNeeded) vimfile<".vimfile.">")
"	call Decho("(AsNeeded) mapstring<".(exists("mapstring")? mapstring : "-doesn't exist-").">")
   endif

  else
   " -----------------------------
   " ANtags file not present
   " -----------------------------
"   call Decho("(AsNeeded) <ANtags> not found, using search")

   " --------------------
   " Set up search string {{{3
   " --------------------
   let srchstring= substitute(a:cmdmap,' .*$','','e')

   if     a:type == 1
   	" called via a FuncUndefined event -- search for a function
"	call Decho("(AsNeeded) a:type=1: search for a function")
    let srchstring= '\<fu\%[nction]!\=\s*\(<[sS][iI][dD]>\|[sS]:\)\='.srchstring.'\>'

   elseif a:type >= 2
   	" called by command: :AsNeeded :AN :ANX -- search for maps or commands
"	call Decho("(AsNeeded) a:type=".a:type.": search for maps or commands (:AsNeeded :AN :ANX)")
    if exists("g:mapleader") && match(srchstring,'^'.g:mapleader) == 0
     " allow srchstring to handle map...<Leader>modsrch
	 let  mlgt    = '[>'.escape(escape(g:mapleader,'\'),'\').']'
	 let  modsrch = substitute(srchstring,g:mapleader,mlgt,'')
    else
"	 call Decho("(AsNeeded) a:type=".a:type.": search for maps or commands (ANX)")
	 let  mlgt    = '[>\\\\]'
	 let  modsrch = substitute(srchstring,'^\\',mlgt,'')
    endif
"	call Decho("(AsNeeded) mlgt      <".mlgt.">")
"	call Decho("(AsNeeded) modsrch   <".modsrch.">")
    let srchstring= '\(map\|[nvoilc]m\%[ap]\|\([oilc]\=no\|[nv]n\)\%[remap]\|com\%[mand]\)!\=\s.*'.modsrch.'\s'
"	call Decho("(AsNeeded) 3:srchstring<".srchstring.">")
   endif

   " --------------------------------
   " search for requested command/map {{{3
   " --------------------------------
   let vimfiles=substitute(globpath(&rtp,"AsNeeded/*.vim"),'\n',',',"ge")
   while vimfiles != ""
    let vimfile = substitute(vimfiles,',.*$','','e')
    let vimfiles= (vimfiles =~ ",")? substitute(vimfiles,'^[^,]*,\(.*\)$','\1','e') : ""
"	call Decho("(AsNeeded) .considering file<".vimfile.">")
    %d _
    exe "silent 0r ".vimfile
    if bufnr("$") > asneededbufnr
"	 call Decho("(AsNeeded) bwipe read-in buf#".bufnr("$")." (> asneededbufnr=".asneededbufnr.")")
     exe "sil! ".bufnr("$")."bwipe!"
    endif
    let srchresult= search(srchstring)
"	call Decho("(AsNeeded) srchresult=".srchresult)
    if srchresult != 0
     let mapstring = getline(srchresult)
"	 call Decho("(AsNeeded) Found mapstring<".mapstring."> maparg<".maparg(mapstring,'n')."> line#".line(".")." col=".col(".")." <".getline(".").">")
     break
    endif
    let vimfile= ""
   endwhile
  endif

  " Wipe out the AsNeededBuffer
  if bufnr("%") == asneededbufnr
   wincmd j
  endif
"  call Decho("(AsNeeded) bufwiping AsNeededBuffer (buf#".bufnr("%").")")
  exe "sil! ".asneededbufnr."bwipe!"
  let asneededbufnr= -1

  " ---------------------------
  " source in the selected file {{{3
  " ---------------------------
  if exists("vimfile") && vimfile != ""
   let vimfile= home.vimfile
"   call Decho("(AsNeeded) success: sourcing ".vimfile)
   call s:RestoreSettings()
   if !filereadable(vimfile)
    if exists("g:AsNeededAutoMake")
	 " automatically (re)make ANtags
	 call AsNeeded#MakeANtags()
	endif
	redraw!
	echohl Error | echomsg "***failed*** file<".vimfile."> is missing; can't invoke ".a:cmdmap | echohl None
"	call Dret("AsNeeded#AsNeeded -1")
    return -1
   endif
"   call Decho('(AsNeeded) exe "so "'.vimfile)
   exe "so ".vimfile
   call s:SaveSettings()
   if g:AsNeededSuccess
    let vimf = substitute(vimfile,$HOME,'\~','')
	if exists("srchstring")
	 let msg= "***success*** AsNeeded found <".substitute(srchstring,'\\\\','\','g')."> in <".vimf.">; now loaded"
	else
     let msg= "***success*** AsNeeded found command in <".vimf.">; now loaded"
	endif
"	call Decho("(AsNeeded) msg<".msg.">")
   endif

   " successfully sourced file containing srchstring
   if a:type == 3 && exists("mapstring")
    let maprhs= maparg(a:cmdmap,'n')
"	call Decho("(AsNeeded) type==".a:type.": maprhs<".maprhs."> mapstring<".mapstring.">")
    call s:RestoreSettings()

   	if maprhs == ""
	 " attempt to execute a:cmdmap as a command (with no arguments)
	 " (previously, attempted to execute a:cmdmap)
"	 call Decho("(AsNeeded) attempt to execute command: keepcmd<".keepcmd.">)")
"	 call Decho("(AsNeeded) exe ".keepcmd)
	 try
	  exe keepcmd
	 catch /^Vim/
	 endtry
"	 call Decho("(AsNeeded) did exe ".keepcmd)
	else
	 " attempt to execute a:cmdmap as a normal command (ie. a map)
"	 call Decho("(AsNeeded) attempt to execute <".a:cmdmap."> as a map")
"	 call Decho("(AsNeeded) norm ".a:cmdmap)
   	 exe "norm ".a:cmdmap
	endif
   endif

   if asneededbufnr > keeplastbufnr
"	call Decho("(AsNeeded) case [asneededbufnr=".asneededbufnr."] > [keeplastbufnr=".keeplastbufnr."]:")
"	call Decho("(AsNeeded) has ".winnr("$")."windows: bufwinnr(".asneededbufnr.")=".bufwinnr(asneededbufnr))
"	call Decho("(AsNeeded) bwipe asneeded buf#".asneededbufnr)
    exe "sil! ".asneededbufnr."bwipe!"
"	call Decho("(AsNeeded) has ".winnr("$")." windows")
   endif

   " message is deferred to now so it'll show up
   if exists("msg")
   	echo msg
"	call Decho("(AsNeeded) now echoing msg<".msg.">")
   endif

   call s:RestoreSettings()
"   call Dret("AsNeeded#AsNeeded 0")
   return 0
  endif

  " ----------------------------------------------------------------
  " failed to find srchstring in *.vim files in AsNeeded directories {{{3
  " ----------------------------------------------------------------
"  call Decho("***warning*** AsNeeded unable to find <".a:cmdmap."> in the (runtimepath)/AsNeeded directory")
  echohl WarningMsg
    echomsg "***warning*** AsNeeded unable to find <".a:cmdmap."> in the (runtimepath)/AsNeeded directory"
  echohl NONE
  if asneededbufnr > keeplastbufnr
"   call Decho("winnr($)=".winnr("$")." bufwinnr(".asneededbufnr.")=".bufwinnr(asneededbufnr))
"   call Decho("bwipe asneeded buf#".asneededbufnr.": now has ".winnr("$")." windows)
   exe "sil! ".asneededbufnr."bwipe!"
  endif

  call s:RestoreSettings()
"  call Dret("AsNeeded#AsNeeded -1")
  return -1
endfun

" ---------------------------------------------------------------------
" AsNeeded#MakeANtags: makes the (optional) ANtags file {{{2
"             Also builds the DrChip:AsNeeded menu
fun! AsNeeded#MakeANtags()
"  DechoRemOn
"  call Dfunc("AsNeeded#MakeANtags()")

  " ------------------------------
  " save&set registers and options {{{3
  " ------------------------------
  let keepa   = @a
  let keepei  = &ei
  let keeprep = &report
  set lz ei=all report=10000

  " --------------------------------------------------------
  " initialize search for all commands, maps, and functions: {{{3
  " --------------------------------------------------------
  let keeplastbufnr= bufnr("$")
"  call Decho("keeplastbufnr=".keeplastbufnr)
  silent 1new! AsNeededBuffer
  let asneededbufnr= bufnr("%")
"  call Decho("asneededbufnr=".asneededbufnr)
  setlocal noswapfile

  let fncsrch  = '\<fu\%[nction]!\=\s\+\%([sS]:\|<[sS][iI][dD]>\)\@<!\(\u\w*\)\s*('
  let mapsrch  = '\<\%(map\|[nvoilc]m\%[ap]\|[oic]\=no\%[remap]\|[nl]n\%[oremap]\)!\=\s\+\%(<\%([sS][iI][lL][eE][nN][tT]\|[uU][nN][iI][qQ][uU][eE]\|[bB][uU][fF][fF][eE][rR]\|[sS][cC][rR][iI][pP][tT]\)>\s\+\)*\(\S\+\)\s'
  let cmdsrch  = '\<com\%[mand]!\=\%(\s\+-\S\+\)*\s\+\(\u\w*\)\>'
  let fmcsrch  = fncsrch.'\|'.mapsrch.'\|'.cmdsrch
  let mapreject= '\<\%(map\|[nvoilc]m\%[ap]\|[oic]\=no\%[remap]\|[nl]n\%[oremap]\)!\=\s\+\%(<\%([sS][iI][lL][eE][nN][tT]\|[uU][nN][iI][qQ][uU][eE]\|[bB][uU][fF][fF][eE][rR]\|[sS][cC][rR][iI][pP][tT]\)>\s\+\)*<[pP][lL][uU][gG]>\(\u\w*\)\s'

  " remove any old <ANtags> from AsNeeded/ directory
  let antags= globpath(&rtp,"AsNeeded/ANtags")
"  call Decho("filereadable(".antags.')='.filereadable(antags))
  if filereadable(antags)
"   call Decho("removing old <ANtags>")
   call delete(antags)
  endif

  " remove any old <ANcmds.vim> from plugin/ directory
  let ancmds= globpath(&rtp,"plugin/ANcmds.vim")
"  call Decho("filereadable(".ancmds.')='.filereadable(ancmds))
  if filereadable(ancmds)
"   call Decho("removing old <ANcmds.vim>")
"   call Decho("globpath<".ancmds.">")
   call delete(ancmds)
  endif

  " ---------------------------------------------
  " determine the home directory for AsNeeded {{{3
  " ---------------------------------------------
  let home= s:FindHome()

  " ---------------------------------------------
  " search for all commands, maps, and functions: {{{3
  " ---------------------------------------------
  let vimfiles = substitute(globpath(&rtp,"AsNeeded/*.vim"),'\n',',',"ge")
  let ANtags   = home."/AsNeeded/ANtags"
  let first    = 1
"  call Decho("ANtags<".ANtags.">")

  while vimfiles != ""
   let vimfile = substitute(vimfiles,',.*$','','e')
   let vimfiles= (vimfiles =~ ",")? substitute(vimfiles,'^[^,]*,\(.*\)$','\1','e') : ""
"   call Decho("considering file<".vimfile.">")
   %d _
   exe "silent 0r ".vimfile
   if bufnr("$") > asneededbufnr
"    call Decho(".bwipe read-in buf#".bufnr("$"))
    exe "sil! ".bufnr("$")."bwipe!"
   endif
"   call Decho("clean out all non-map, non-command, non-function lines")
"   call Dredir("%p")

   " clean out all non-map, non-command, non-function lines
   sil! g/^\s*"/d
   sil! g/\c<script>/d
   exe 'sil! %g@'.mapreject.'@d'
   sil! g/^\s*echo\(err\|msg\)\=\>/d
   sil! %s/^\s*exe\%[cute]\s\+['"]\(.*\)['"]/\1/e
   " remove anything that doesn't look like a map, command, or function
   exe "sil! v/".fmcsrch."/d"
"   call Decho("Before conversion to ANtags-style:")
"   call Dredir("%p")

   " convert remaining lines into ANtag-style search patterns
   exe 'sil! %s@^\s*sil\%[ent]!\=\s\+@@'
   exe 'sil! %s@^[ \t:]*'.fncsrch.'.*$@f\t\1\t'.escape(vimfile,'@ \').'@e'
   exe 'sil! %s@^.*'.mapsrch.'.*$@m\t\1\t'.escape(vimfile,'@ \').'@e'
   exe 'sil! %s@^[ \t:]*'.cmdsrch.'.*$@c\t\1\t'.escape(vimfile,'@ \').'@e'

   " elide home directory and /AsNeeded - these are constant
   sil! %s@^\([^\t]\+\t[^\t]\+\t\)\(.*\)$@\=submatch(1).substitute(submatch(2),'\\','/','g')@
   exe "sil! %s@".home."/AsNeeded/@@e"

   " clean up anything that snuck into <ANtags> that shouldn't be there.
   silent v/^[mfc]\t/d
   silent g/^m\t"\./d
   silent g/^m\t<[sS][iI][dD]>/d
   silent g/^m\t.*'\./d

   " record in <ANtags>
   if  line("$") <= 1 && col("$") <= 2
   	echoerr "***warning*** no tags found in file <".vimfile.">!"
"	call Decho("***warning*** no tags found in file <".vimfile.">!")
"	call Decho("line($)=".line("$")." col($)=".col("$"))
   else
    if first
"     call Decho(".write ".line("$")." tags to ANtags<".ANtags.">")
     exe "sil! w! ".ANtags
 	let first= 0
    else
"     call Decho(".append ".line("$")." tags to ANtags<".ANtags.">")
     exe "silent w >>".ANtags
    endif
"	call Decho("After conversion to ANtags-style:")
"    call Dredir("%p")
   endif

   let vimfile= ""
  endwhile
  q!

  " -----------------------------------------
  "  Use Thomas's idea to create a ANcmds.vim {{{3
  " -----------------------------------------
  if isdirectory(home."/plugin")
"   call Decho("creating ".home."/plugin/ANcmds.vim")
   let ANcmds = home."/plugin/ANcmds.vim"
   sil! 1split
   exe "sil! e ".ANcmds
   sil! keepj %d _
   exe "sil! r ".ANtags
   sil! keepj 1d
   sil! keepj v/^c/d
   if getline(1) != ""
	sil! keepj %s/^c\t\(\S\+\)\t.*$/com! -bang -range -nargs=* -complete=command \1 delcommand \1 | ANX \1<bang> <args>/e
    w!
    sil! keepj so %
   endif
   q!
  endif

  " -----------------------------
  " create a DrChip.AsNeeded menu {{{3
  " -----------------------------
  if isdirectory(home."/AsNeeded") && has("gui_running") && has("menu") && &go =~# 'm'
"   call Decho("creating ".home."/AsNeeded/ANmenu")
   sil! 1split
"   call Decho("exe sil! e ".home."/AsNeeded/ANmenu")
   exe "sil! e ".home."/AsNeeded/ANmenu"
   sil %d _
   exe "sil! r ".ANtags
   sil! v/^c/d
   if getline(1) != ""
	exe '%s/^c\t\(\(\S\)\S*\)\t.*$/menu '.g:DrChipTopLvlMenu.'AsNeeded.\2.\1\t:AN \1<cr>/e'
	%sort
   endif
   sil! wq!
  endif

  " ------------------------------
  " restore registers and settings {{{3
  " ------------------------------
  set nolz
  let @a      = keepa
  let &ei     = keepei
  let &report = keeprep

"  call Dret("AsNeeded#MakeANtags")
endfun

" ---------------------------------------------------------------------
" s:FindHome: determine the home directory for AsNeeded {{{2
fun! s:FindHome()
"  call Dfunc("s:FindHome()")

  for home in split(&rtp,',') + ['']
   if isdirectory(home) | break | endif
  endfor
  if home == ""
   let home= substitute(&rtp,',.*$','','')
  endif
  let home= substitute(home,'\\','/','g')

"  call Dret("s:FindHome <".home.">")
  return home
endfun

" ---------------------------------------------------------------------
" s:SaveSettings: {{{2
fun! s:SaveSettings()
"  DechoRemOn
"  call Dfunc("s:SaveSettings()")
  if exists("+acd")
   let s:keepacd = &acd
  endif
  let s:keeprep   = &report
  let s:keepa     = @a
  let s:keepei    = &ei
  let s:keepim    = &im
  let s:keeplz    = &lz
  let s:keeppm    = &pm
  let s:keepmagic = &magic
  set lz ei=all report=10000 pm= magic noim
  if exists("+acd")
   set noacd
  endif
"  call Dret("s:SaveSettings")
endfun

" ---------------------------------------------------------------------
" s:RestoreSettings: {{{2
fun! s:RestoreSettings()
"  call Dfunc("s:RestoreSettings() (AsNeeded.vim)")
  if exists("+acd")
   let &acd   = s:keepacd
  endif
  let @a      = s:keepa
  let &ei     = s:keepei
  let &im     = s:keepim
  let &lz     = s:keeplz
  let &report = s:keeprep
  let &pm     = s:keeppm
  let &magic  = s:keepmagic
"  call Dret("s:RestoreSettings : AsNeeded.vim")
endfun

" ---------------------------------------------------------------------
"  Restore Cpo: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo

" ---------------------------------------------------------------------
"  Modelines: {{{1
" vim: ts=4 fdm=marker
