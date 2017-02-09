"=============================================================================
" File:         autoload/lh/sir.vim                               {{{1
" Author:       Luc Hermitte <EMAIL:luc {dot} hermitte {at} gmail {dot} com>
"               <URL:http://github.com/LucHermitte/SearchInRuntime>
" Version:      3.1.0.
let s:k_version = '310'
" Created:      03rd Jan 2017
" Last Update:  09th Feb 2017
"------------------------------------------------------------------------
" Description:
"       Support functions for plugin/searchInRuntime.vim
"
"------------------------------------------------------------------------
" History:      «history»
" TODO:         «missing features»
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
" ## Misc Functions     {{{1
" # Version {{{2
function! lh#sir#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = get(s:, 'verbose', 0)
function! lh#sir#verbose(...)
  if a:0 > 0 | let s:verbose = a:1 | endif
  return s:verbose
endfunction

function! s:Log(expr, ...)
  call call('lh#log#this',[a:expr]+a:000)
endfunction

function! s:Verbose(expr, ...)
  if s:verbose
    call call('s:Log',[a:expr]+a:000)
  endif
endfunction

function! lh#sir#debug(expr) abort
  return eval(a:expr)
endfunction

"------------------------------------------------------------------------
" ## Support functions {{{1
" Main functions {{{2
" Function: s:ToCommaSeparatedPath({path})     {{{3
function! s:ToCommaSeparatedPath(path)
  let path = substitute(a:path, ';', ',', 'g')
  if !(has('win16') || has('win32') || has('win64') || has('win95'))
    let path = substitute(a:path, ':', ',', 'g')
  endif
  return path
endfunction

" Function: lh#sir#SearchIn({do_all}, {cmd}, {rpath}, [{glob}...]) {{{3
function! lh#sir#SearchIn(do_all, cmd, rpath, ...)
  " Loop on runtimepath : build the list of files
  if has('win32')
    let ss=&shellslash
    set shellslash
    " because of glob + escape ('\\')
  endif
  let rp = a:rpath
  let f = ''
  let firstTime = 1
  let params0 = '' | let params = ''
  while strlen(rp) != 0
    let r  = matchstr(rp, '^[^,]*' )."/"
    let rp = substitute(rp, '.\{-}\(,\|$\)', '', '')
    if &verbose >= 3 | echo "Directory searched: [" . r. "]\n" | endif

    " Loop on arguments
    let params0 = '' | let params = ''
    let i = 1
    while i <= a:0
      if lh#path#is_absolute_path(a:{i})
        if firstTime
          if &verbose >= 3 | echo "Absolute path : [" . glob(a:{i}). "]\n" | endif
          let f .=  glob(a:{i}) . "\n"
        endif
      elseif a:{i} == "|0"      " Other parameters
        let i +=  1
        while i <= a:0
          let params0 .=  ' ' . a:{i}
          let i +=  1
        endwhile
      elseif a:{i} == "|"       " Other parameters
        let i +=  1
        while i <= a:0
          let params .=  ' ' . a:{i}
          let i +=  1
        endwhile
      else
        let f .=  glob(r.a:{i}). "\n"
        "echo a:{i} . " -- " . glob(r.a:{i})."\n"
        "echo a:{i} . " -- " . f."\n"
      endif
      let i +=  1
    endwhile
    let firstTime = 0
  endwhile
  if has('win32')
    let &shellslash=ss
  endif
  " correct the params
  let params0 = escape(params0, "\\\t")
  let params = escape(params, "\\\t")
  " Execute the command on the matching files
  let foundOne = 0
  while strlen(f) != 0
    let ff = matchstr(f, "^[^\n]*")
    let f  = substitute(f, '.\{-}\('."\n".'\|$\)', '', '')
    if filereadable(ff)
      if     &verbose >= 3
        echo "Action on: [" . ff . "] (".params0.'/'.params.")\n"
      elseif &verbose >= 2
        echo "Action on: [" . ff . "]\n"
      endif
      " echo a:cmd.params0." ".escape(ff, "\\ \t").params
      exe a:cmd.params0." ".escape(ff, "\\ \t").params
      if !a:do_all | return | endif
      let foundOne = 1
    endif
  endwhile
  if &verbose > 0 && !foundOne " {{{
    let msg = "not found : « "
    let i = 1
    while i <= a:0
      let msg .=  a:{i} . " "
      let i +=  1
    endwhile
    echo msg."»"
  endif " }}}
endfunction

" Function: lh#sir#SearchInRuntime({bang}, {cmd}, [{glob-pat}]) {{{3
function! lh#sir#SearchInRuntime(bang, cmd, ...)
  let do_all = a:bang == "!"
  let i = 1
  let a = ''
  while i <= a:0
    let a .= ",'".escape(a:{i}, "\\ \t")."'"
    let i +=  1
  endwhile
  exe 'call lh#sir#SearchIn(do_all, a:cmd, &runtimepath' .a.')'
endfunction

" Function: :lh#sir#SearchInPATH({bang}, {cmd}, [{glob-pat}]) {{{3
function! lh#sir#SearchInPATH(bang, cmd, ...)
  " momentarally deactive &wildignore
  let do_all = a:bang == "!"
  let i = 1
  let a = ''
  while i <= a:0
    let a .= ",'".escape(a:{i}, "\\ \t")."'"
    let i +=  1
  endwhile
  let p = substitute($PATH, ';', ',', 'g')
  let p = s:ToCommaSeparatedPath(p)
  let s_wildgnore = &wildignore
  set wildignore&vim
  try
    exe "call lh#sir#SearchIn(do_all, a:cmd,'". p ."'".a.")"
  finally
    let &wildignore = s_wildgnore
  endtry
endfunction

" Function: :lh#sir#SearchInVar({bang}, {cmd}, [{glob-pat}]) {{{3
function! lh#sir#SearchInVar(bang, env, cmd, ...)
  let do_all = a:bang == "!"
  let i = 1
  let a = ''
  while i <= a:0
    let a .= ",'".escape(a:{i}, "\\ \t")."'"
    let i +=  1
  endwhile
  exe "let p = substitute(".a:env.", ';', ',', 'g')"
  let p = s:ToCommaSeparatedPath(p)
  exe "call lh#sir#SearchIn(do_all, a:cmd,'". p ."'".a.")"
endfunction

" Open one file among several{{{2

" Function: s:SelectOne({ask_even_if_already_opened}, {path}, {glob-patterns}) {{{3
" All globbing pattern all matched against the {path}, if several files
" are found, a confirm dialog box will ask to select one file only.
" NB: on some systems, we may be interrested in setting:
"   :set guioptions+=c
function! s:SelectOne(ask_even_if_already_opened, path, gpatterns)
  " Get all the matching files
  let matches = []
  let i = 0
  while i < len(a:gpatterns)
    let pattern = a:gpatterns[i]
    " replace environment variables like ${HOME} we see in shell scripts
    let pattern = lh#env#expand_all(pattern)
    if lh#path#is_absolute_path(pattern)
          \ || lh#path#is_url(pattern)
      let matches += [ pattern ]
    else
    let m = lh#path#glob_as_list(a:path, pattern)
    call extend (matches, m)
    endif
    let i +=  1
  endwhile

  " Get rid of doublons
  call map (matches, 'lh#path#simplify(v:val)')
  call sort(matches)
  "     uniq...
  let i = 1
  while i < len(matches)
    if matches[i-1] == matches[i]
      call remove(matches, i)
    else
      let i +=  1
    endif
  endwhile

  if len(matches) > 1
    if !a:ask_even_if_already_opened
      " Try to see if a matching buffer is aready opened
      " If so, jump to it.
      " @todo: if several match, then ask from the restricted list of matching
      " buffers....
      let i = 0
      while i != len(matches)
        if lh#buffer#find(matches[i]) != -1 | return '' | endif
        let i +=  1
      endwhile
      " No matching opened buffer found.
    endif
    let file = lh#path#select_one(matches, 'Select file to open:')
  elseif len(matches) == 0
    let file = ''
  else
    let file = matches[0]
  endif
  return file
endfunction

" Function: lh#sir#OpenWith({bang}, {cmd}, {path}, {glob-patterns}) {{{3
" Select only one file that matches {path} +  {glob-patterns}. Then
" apply the opening command {cmd} on the resulting file.
" If the {glob-pattern} has the form "-[a-zA-Z0-9]{path}", or "--\w\+={path}",
" the file will be searched without the leading part. (The rationale behind
" this feature comes from compiler options like -I/usr/include)
" NB: If the result file is already opened in a window, this window
" becomes the active window. Otherwise, {cmd} is applied. Typical values
" for {cmd} are "sp", "e", ...
let s:k_pattern = '^-\([a-zA-Z0-9]\|-\w\+=\)'
function! lh#sir#OpenWith(bang, cmd, path, ...)
  let [file, line, col] = s:DoOpenWith(a:bang, a:cmd, a:path, a:000)
  if strlen(file) == 0 && lh#list#match(a:000, s:k_pattern) != -1
    let a000 = deepcopy(a:000)
    call map(a000, 'substitute(v:val, s:k_pattern, "", "g")')
    echomsg string(a000)
    let [file, line] = s:DoOpenWith(a:bang, a:cmd, a:path, a000)
  endif
  if strlen(file) == 0
    echohl WarningMsg
    echomsg "No file found for ".string(a:000)." in ".a:path
    echohl None
    return 0
  endif
  if lh#buffer#find(file) == -1
    exe a:cmd . ' '.fnameescape(file)
  endif
  if line > 0
    call setpos('.', [0, line, col, 0])
  endif
endfunction

" Function: s:DoOpenWith({bang}, {cmd}, {path}, {glob-patterns}) {{{4
" Internal function used by lh#sir#OpenWith()
function! s:DoOpenWith(bang, cmd, path, a000)
  let ask_even_if_already_opened = a:bang == "!"
  let line = 0
  let suffixes = [''] + split(','.&suffixesadd, ',')
  let patterns = a:a000
  if len(patterns) == 1
    let [all, pattern, line, col ; tail] = matchlist(patterns[0], '^\(.\{-}\)\%(:\(\d\+\)\)\=\%(:\(\d\+\)\)\=$')
    let patterns = [pattern]
  else
    let line = 1
    let col  = 1
  endif
  if !empty(&includeexpr)
    let patterns += map(copy(patterns), substitute(&includeexpr, 'v:fname', 'v:val', 'g'))
  endif
  let patterns = lh#list#cross(patterns, suffixes, 'v:val . l:val2')
  call s:Verbose("Searching for %1 (suffixes: %2, includeexpr)", patterns, suffixes, &includeexpr)
  let pattern = lh#list#uniq(patterns)
  let file = s:SelectOne(ask_even_if_already_opened, a:path, patterns)
  return [file, line, col]
endfunction


" Auto-completion                                {{{2
" Note: the completion cannot expand with different leading data
" lh#sir#complete(ArgLead,CmdLine,CursorPos)                   {{{3
let s:commands = '^SearchIn\S\+\|^V\=[Ss]p\%[lit]\|^Ru\%[ntime]\|^W\%[hereis]'
let s:split_commands = '^V\=[Ss]p\%[lit]$'
if exists('s:cmd1h')
  " With Vim 7+, there is a support for customizable split commands
  let s:cmd1h_pat = substitute(s:cmd1h, '^\(.\)\(.\+\)$', '\1\\%[\2]', '')
  let s:cmd1v_pat = substitute(s:cmd1v, '^\(.\)\(.\+\)$', '\1\\%[\2]', '')

  let s:commands = s:commands . '\|^'.s:cmd1h_pat.'\|^'.s:cmd1v_pat
  let s:split_commands = s:split_commands . '\|^'.s:cmd1h_pat.'$\|^'.s:cmd1v_pat.'$'
endif

function! lh#sir#complete(ArgLead, CmdLine, CursorPos)
  let cmd = matchstr(a:CmdLine, s:commands)
  let cmdpat = '^'.cmd

  let tmp = substitute(a:CmdLine, '\s*\S\+', 'Z', 'g')
  let pos = strlen(tmp)
  let lCmdLine = strlen(a:CmdLine)
  let fromLast = strlen(a:ArgLead) + a:CursorPos - lCmdLine
  " The argument to expand, but cut where the cursor is
  let ArgLead = strpart(a:ArgLead, 0, fromLast )
  if 0
    call confirm( "a:AL = ". a:ArgLead."\nAl  = ".ArgLead
          \ . "\nx=" . fromLast
          \ . "\ncut = ".strpart(a:CmdLine, a:CursorPos)
          \ . "\nCL = ". a:CmdLine."\nCP = ".a:CursorPos
          \ . "\ntmp = ".tmp."\npos = ".pos
          \, '&Ok', 1)
  endif

  " let delta = ('SearchInVar'==cmd) ? 1 : 0
  if     'SearchInVar' == cmd
    let delta = 1
  elseif cmd =~ s:split_commands
    return s:FindMatchingFiles(&path, ArgLead)
  elseif cmd =~ '^Ru\%[ntime]$'
    return s:FindMatchingFiles(&runtimepath, ArgLead)
  elseif cmd =~ '^W\%[hereis]$'
    return s:FindMatchingFiles(&path, ArgLead)
  else
    let delta = 0
  endif

  if     1+delta == pos
    " First argument for :SearchInVar -> variable
    return s:FindMatchingVariable(ArgLead)
  elseif 2+delta == pos
    " First argument: a command
    return s:MatchingCommands(ArgLead)
  elseif 3+delta <= pos
    if     cmd =~ 'SearchInPATH!\='
      let path = $PATH
    elseif cmd =~ 'SearchInRuntime!\='
      let path = &rtp
    elseif cmd =~ 'SearchInVar!\='
      let path = matchstr(a:CmdLine, '\S\+\s\+\zs\S\+\ze.*')
      exe "let path = ".path
    endif
    return s:FindMatchingFiles(path, ArgLead)
  endif
  " finally: unknown
  echoerr cmd.': unexpected parameter ``'. a:ArgLead ."''"
  return ''

endfunction

" s:MatchingCommands(ArgLead)                              {{{3
" return the list of custom commands starting by {FirstLetters}
function! s:MatchingCommands(ArgLead)
  silent! exe "norm! :".a:ArgLead."\<c-a>\"\<home>let\ cmds=\"\<cr>"
  let cmds = substitute(cmds, '\s\+', '\n', 'g')
  return cmds
endfunction

" s:FindMatchingFiles(path,ArgLead)                        {{{3
function! s:FindMatchingFiles(pathsList, ArgLead)
  " Convert the paths list to be compatible with globpath()
  let pathsList = s:ToCommaSeparatedPath(a:pathsList)
  let ArgLead = a:ArgLead
  " If there is no '*' in the ArgLead, append it
  if -1 == stridx(ArgLead, '*')
    let ArgLead .=  '*'
  endif
  " Get the matching paths
  let paths = globpath(pathsList, ArgLead)

  " Build the result list of matching paths
  let result = ''
  while strlen(paths)
    let p     = matchstr(paths, "[^\n]*")
    let paths = matchstr(paths, "[^\n]*\n\\zs.*")
    let sl = isdirectory(p) ? '/' : '' " use shellslash
    let p     = fnamemodify(p, ':t') . sl
    if strlen(p) && (!strlen(result) || (result !~ '.*'.p.'.*'))
      " Append the matching path is not already in the result list
      let result .=  (strlen(result) ? "\n" : '') . p
    endif
  endwhile

  " Add the leading path as it has been stripped by fnamemodify
  let lead = fnamemodify(ArgLead, ':h') . '/'
  let lead = substitute(lead, '^.[/\\]', '', '') " fnamemodify may returns '.' on windows ...
  if strlen(lead) > 1
    let result = substitute(result, '\(^\|\n\)', '\1'.lead, 'g')
  endif

  " Return the list of paths matching a:ArgLead
  return result
endfunction

" s:FindMatchingVariable(ArgLead)                          {{{3
function! s:FindMatchingVariable(ArgLead)
  if     a:ArgLead[0] == '$'
    command! -complete=environment -nargs=* FindVariable :echo '<arg>'
    let ArgLead = strpart(a:ArgLead, 1)
  elseif a:ArgLead[0] == '&'
    command! -complete=option -nargs=* FindVariable :echo '<arg>'
    let ArgLead = strpart(a:ArgLead, 1)
  else
    command! -complete=expression -nargs=* FindVariable :echo '<arg>'
    let ArgLead = a:ArgLead
  endif

  silent! exe "norm! :FindVariable ".ArgLead."\<c-a>\"\<home>let\ cmds=\"\<cr>"
  if a:ArgLead[0] =~ '[$&]'
    let cmds = substitute(cmds, '\<\S', escape(a:ArgLead[0], '&').'&', 'g')
  endif
  let cmds = substitute(cmds, '\s\+', '\n', 'g')
  let g:cmds = cmds
  return cmds
  " delc FindVariable
endfunction


"------------------------------------------------------------------------
" ## Internal functions {{{1

"------------------------------------------------------------------------
" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
