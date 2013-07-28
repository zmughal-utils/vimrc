" ------------------------------------------------------------------------------
" Filename:      AutoFold.vim                                                {{{
" VimScript:     925
"
" Maintainer:    Dave Vehrs <davev(at)ezrs.com>
" Last Modified: 27 Feb 2006 12:04:50 PM by lowkey,,,
"
" Copyright:     (C) 2004-2005 Dave Vehrs
"
"                This program is free software; you can redistribute it and/or
"                modify it under the terms of the GNU General Public License as
"                published by the Free Software Foundation; either version 2 of
"                the License, or (at your option) any later version.
"
"                This program is distributed in the hope that it will be useful,
"                but WITHOUT ANY WARRANTY; without even the implied warranty of
"                MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
"                GNU General Public License for more details.
"
"                You should have received a copy of the GNU General Public
"                License along with this program; if not, write to the Free
"                Software Foundation, Inc., 59 Temple Place, Suite 330,
"                Boston, MA 02111-1307 USA _OR_ download at copy at
"                http://www.gnu.org/licenses/licenses.html#TOCGPL
"
" Description:   A script to automate folding based on markers and syntax with
"                language specific support for Perl, Python, Shell, and
"                Vim scripts.
"
" Install:       Save this file in your .vim/plugins/ directory or load it
"                manually with :source AutoFold.vim.
"
"                Additional notes at end of file.                            }}}
" ------------------------------------------------------------------------------
" Exit if already loaded.                                                    {{{

if (exists("loaded_autofold") || &cp) | finish | endif
let g:loaded_autofold=1

"                                                                            }}}
" ------------------------------------------------------------------------------
" Configuration:                                                             {{{

filetype on
set foldcolumn=0
set foldexpr=SF_SetFolds()
set foldmethod=expr
set foldminlines=1
set foldopen=block,hor,insert,mark,percent,quickfix,search,tag,undo
set foldtext=SFT_SetFoldText()

" Set fold text style
" ("solid" sets the fold to be a solid line of -, anything else leaves it open
" for textwidth + 14, then default fold character(-))
if !exists("g:AF_foldstyle")
	let g:AF_foldstyle = 'open'
endif

" Set fold width
" ("full" sets to window width, anything else sets it to text width)
if !exists("g:AF_foldwidth")
	let g:AF_foldwidth = 'text'
endif

"                                                                            }}}
" ------------------------------------------------------------------------------
" Autocommands:                                                              {{{

augroup AutoFold
  autocmd!
  autocmd BufWritePre,FileWritePre   * ks|call s:UpdateFoldMarkers()|'s
augroup end

"                                                                            }}}
" ------------------------------------------------------------------------------
" Command Mapping:                                                           {{{

" Insert fold markers around marked area (visual mode)
vmap <silent> zf <ESC>:call <SID>InsertFoldMarkers()<CR>
vmap <silent> zF <ESC>:call <SID>InsertFoldMarkers()<CR>
" Insert fold marker on this and next line (normal mode)
nmap <silent> zf <ESC>V:call <SID>InsertFoldMarkers()<CR>
nmap <silent> zF <ESC>V:call <SID>InsertFoldMarkers()<CR>

" Remove fold markers around marked area (visual mode)
vmap <silent> zd <ESC>:call <SID>RemoveFoldMarkers()<CR>
" Remove fold marker on this and next line (normal mode)
nmap <silent> zd V:call <SID>RemoveFoldMarkers()<CR>

"                                                                            }}}
" ------------------------------------------------------------------------------
" Folding Functions:                                                        {{{1

function! SF_SetFolds()
  let l:test = s:SF_common_folds(v:lnum)
  if l:test == "NF"
    if exists("*s:SF_{&filetype}_folds")
      let l:test = s:SF_{&filetype}_folds(v:lnum)
    endif
  endif
  if l:test != "NF"
    return l:test
  else
    return "="
  endif
endfunction

" Folding rules for all files (markers).
function! s:SF_common_folds(lnum)
  let l:line = getline(a:lnum)
	let l:comment_char = s:GetCommentChar(&filetype)
  if l:line =~ '^\s*$'
    return "="
  endif
  " For markers with Foldlevels
  if l:line =~ '^\s*' . l:comment_char . '\s*{{{\d\+.*$'
    let l:flvl = substitute(l:line, '^.*{{{', '', 'g')
    return ">" . l:flvl
  endif
  if l:line =~ '\s\+{{{\d\+\(\s*\|-->\s*\)$'
    let l:flvl = substitute(l:line, '^.*{{{', '', 'g')
    return ">" . l:flvl
  endif
  if l:line =~ '\s*}}}\d\+\s*$'
    let  l:flvl = substitute(l:line, '^.*}}}', '', 'g')
    return "<" . l:flvl
  endif
    " For markers without foldlevels
		if l:line =~ '^\s*' . l:comment_char . '.*{{{\s*.*$'
    return "a1"
	endif
  if l:line =~ '\s\+{{{\s*$'
    return "a1"
  endif
  if l:line =~ '\s*}}}\s*$'
    return "s1"
  endif
  return "NF"
endfunction

" Filetype specific folding functions (syntax)                              {{{2

" C Ideas
function! s:SF_c_folds(lnum)
  let l:line = getline(a:lnum)
  if l:line =~ '^{\s*$'
    return "a1"
  endif
  if l:line =~ '^\s*\/\*\+\s*[^*/]*$'
    return "a1"
  endif
  if l:line =~ '^\s*\#if\%[def]\s\+\(\S\+\s*\)*$'
    return "a1"
  endif
  if foldlevel(l:pnum) == 0
    return "0"
  endif
  if l:line =~ '^}\s*$'
    return "s1"
  endif
  if l:line =~ '^\s\+\(\*[^*/]\+\)*\*\/\s*$'
    return "s1"
  endif
  if l:line =~ '^\s*\#endif\s*\(\/\*.*\)*$'
    return "s1"
  endif
  if l:line =~ '^\s*\#.*'
    return "="
  endif
  let l:nline = getline(nextnonblank(a:lnum + 1))
  return "NF"
endfunction

" Perl folding rules (currently subroutines only).
function! s:SF_perl_folds(lnum)
  let l:line = getline(a:lnum)
  let l:pnum = a:lnum - 1
  if     l:line =~ '^\s*sub\s\+\S\+\_s\+\(:\s\+\S\+\_s\+\)*{\?\s*$'
    return "a1"
  endif
  if l:line =~ "^\s*\#.*"
    return "="
  endif
  if foldlevel(l:pnum) == 0
    return "0"
  endif
  if l:line =~ "^}\s*$"
    return "s1"
  endif
  let l:nline = getline(nextnonblank(a:lnum+1))
  if l:nline =~ '^\s*sub\s\+\S\+\s\+{\s*$'
    return "s1"
  endif
  return "NF"
endfunction

" Python folding rules.
function! s:SF_python_folds(lnum)
  " NOTE: Inspired by Jorrit Wiersma's foldexpr (VimScript#515)
  let l:line = getline(a:lnum)
  let l:indent = indent(a:lnum)
  if l:line =~ "^\s*\(\"\"\"\|'''\)"
    return "="
  endif
  if l:line =~ "\\$"
    return "="
  endif
  if l:line =~ "^\s*$"
    return "="
  endif
  if l:line =~ '^\s*\(try:\|\(class\|def\)\s\+\S*\s\+(.*\(,\|):\)\)\s*$'
   return "a1"
  endif
"  let l:pnum = prevnonblank(a:lnum - 1)
"  if  ( l:pnum == 0 || foldlevel(l:pnum) == 0 )
"    return "0"
"  endif
  let l:nnum = nextnonblank(a:lnum + 1)
  if  ( l:nnum == 0 || l:nnum  == a:lnum + 1 )
    return "="
  endif
  if getline(l:nnum) =~ "^\s*\(except\|else\|elif\)"
    return "="
  endif
"  echomsg "line     :" . l:line
"  echomsg "next line:" . getline(l:nnum)
  let l:nindent = indent(l:nnum)
  if l:nindent <= l:indent - &tabstop
"    echomsg "foldlevel: " . foldlevel(a:lnum)
"    echomsg "indent:    " . l:indent
"    echomsg "testvalue: " . ((l:indent/&shiftwidth)+1)
"    if (l:indent / (&shiftwidth-1)-2) <= foldlevel(a:lnum)
    return "<" . ((l:indent / &shiftwidth)+1)
"      return "s1"
"    endif
  endif
"  if l:nindent <= l:indent - &shiftwidth
"    return "s1"
"  endif
  return "NF"
endfunction

" Shell folding rules.
function! s:SF_sh_folds(lnum)
  let l:line = getline(a:lnum)
  let l:pnum = a:lnum - 1
  if  l:line =~ '^\s*function\s\+\S\+\s\+[(.*)]*\s*{\s*$'
    return "a1"
  endif
  if l:line =~ '^\s*\#.*'
    return "="
  endif
  if l:line =~ '^\s*}\s*$'
    return "s1"
  endif
  if foldlevel(l:pnum) <= 0
    return "="
  endif
  return "NF"
endfunction

" Vim script folding rules.
function! s:SF_vim_folds(lnum)
  let l:line = getline(a:lnum)
  let l:pnum = prevnonblank(a:lnum - 1)
  if l:line =~ '\c^\s*fu\%[nction]\%[!]\s\+[\(s:\|<sid>\)]*\S\+\s*(.*)\s*$'
    return "a1"
  endif
  if l:line =~ '\c^\s*au\%[group]\s\+\(end\)\@!\S\+\s*$'
    return "a1"
  endif
  if ( foldlevel(l:pnum) <= 0 || l:pnum = 0 )
    return "0"
  endif
  if l:line =~ '^\s*\#.*'
    return "="
  endif
  if l:line =~ '^\s*endf\%[unction]\s*$'
    return "s1"
  endif
  if l:line =~ '\c^\s*au\%[group]\send\s*$'
    return "s1"
  endif
  return "NF"
endfunction
"                                                                           }}}2

"                                                                           }}}1
" ------------------------------------------------------------------------------
" FoldText Formating Functions:                                             {{{1

function! SFT_SetFoldText()
  let l:lcnt = v:foldend - v:foldstart + 1
  let l:line = getline(v:foldstart)
  " Record indent.
  let l:indent = substitute(l:line,'\(^\s*\)\S.\+$','\1','') . '+ '
  " Clean up line.
  if l:line =~ '^\s*\/\*[*]*\s*$'
    let l:line = getline(v:foldstart + 1)
  endif
  if exists("*s:SFT_{&filetype}_clean")
    let l:line = s:SFT_{&filetype}_clean(l:line)
  endif
  let l:line = substitute(l:line, '^\s*\|/\*\|\*\|\*/\|\s*[{{{]\s*\d*\|\s*$', '', 'g')
  " Set line width.
	if g:AF_foldwidth == 'full'
    let l:width = &columns -  (13 + &fdc + strlen(l:indent))
	else
    let l:width = &textwidth -  (13 + strlen(l:indent))
	endif
  if strlen(l:line) > l:width
    let l:line = strpart(l:line,0,l:width - 2) . "..."
  else
		if g:AF_foldstyle == 'solid'
			 while strlen(l:line) <= (l:width - 2)
         let l:line = l:line . "-"
       endwhile
       let l:line = l:line . "->"
		else
			while strlen(l:line) <= l:width
        let l:line = l:line . " "
      endwhile
		endif
  endif
  " Set tail (line count, etc.).
  if     l:lcnt <= 9   | let l:tail = "[lines:   " . l:lcnt . "]"
  elseif l:lcnt <= 99  | let l:tail = "[lines:  ". l:lcnt . "]"
  elseif l:lcnt <= 999 | let l:tail = "[lines: ". l:lcnt . "]"
  else                 | let l:tail = "[lines:". l:lcnt . "]"| endif
  " Set return line
	if ( g:AF_foldstyle == 'solid' && g:AF_foldwidth != 'full' )
		return l:indent . l:line . l:tail . "<"
	else
		return l:indent . l:line .  l:tail .  "              <"
	endif
endfunction

" Filetype specific cleanup functions.                                      {{{2

" Cleanup for C files.
		function! s:SFT_c_clean(line)
			let l:line = substitute(a:line, '^\s*[/]*\*\+\s', 'Comment: ', 'g')
			"let l:line = substitute(l:line, '^\s*\/\*\s', 'Comment: ', 'g')
			if l:line =~ '^\s*\#if'
				let l:line = substitute(l:line, '^\s*\#', '', 'g')
				let l:line = substitute(l:line, '^ifdef\s\+', 'IFDEF: ', 'g')
				let l:line = substitute(l:line, '^if defined(', 'IF DEFINED: ', 'g')
				let l:line = substitute(l:line, '^if !defined(', 'IF NOT DEFINED: ', 'g')
				let l:line = substitute(l:line, '&& defined(', ', ', 'g')
				let l:line = substitute(l:line, ')\s*\(\/\*.*\*\/\s*\)*', '', 'g')
			endif
			return l:line
		endfunction

" Cleanup for Perl scripts.
function! s:SFT_perl_clean(line)
	let l:line = substitute(a:line, '^\#\s*\|\s{\s*$\|\s\+(*)*\s*{\s*$', '', 'g')
	let l:line = substitute(l:line, '^sub\s', 'Subroutine: ', 'g')
	return l:line
endfunction

" Cleanup for Python files.
function! s:SFT_python_clean(line)
  let l:line = substitute(a:line, '^\"\s*\|\s*\&\S*\*\s*$', '', 'g')
  let l:line = substitute(l:line, '^def\s', 'Function: ', 'g')
  let l:line = substitute(l:line, '^class\s', 'Class: ', 'g')
  return l:line
endfunction

" Cleanup for Shell scripts.
function! s:SFT_sh_clean(line)
  let l:line = substitute(a:line, '^\#\s*\|\s\+(*)*\s*{\s*$', '', 'g')
  let l:line = substitute(l:line, '^function\s', 'Function: ', 'g')
  return l:line
endfunction

" Cleanup for Vim scripts.
function! s:SFT_vim_clean(line)
  let l:line = substitute(a:line, '^\"\s*\|\s*\&\S*\*\s*$\|()\s*$', '', 'g')
  let l:line = substitute(l:line, '^\s*augroup', 'Autocommand Group:', 'g')
  let l:line = substitute(l:line, 'function\!*\s\+\c\(s:\|<sid>\)*',
    \ 'Function: ', 'g')
  return l:line
endfunction

"                                                                           }}}2

"                                                                           }}}1
" ------------------------------------------------------------------------------
" Other Functions:                                                           {{{

" Inspired by foldlist.vim plugin by Paul C. Wei (vimscript#500).  
function! s:FoldList()
  let l:win_size = 10
  let l:win_dir = 'botright'
  let l:bufname = '__Fold-List__'

  " let l:current_buffer = 
  
  let l:winnum = bufwinnr(l:bufname)
  if l:winnum != -1
    execute l:winnum . 'wincmd w'
  else
    let l:bufnum = bufnr(l:bufname)
    if bufnum = -1
      let l:win_cmd = l:bufname
    else
      let l:win_cmd = '+buffer'.bufnum
    endif
    execute 'silent! ' . l:win_dir . ' ' . l:win_size . ' split ' . l:win_cmd
    set buftype=nofile
    set noswapfile
    let l:winnum = bufwinnr(l:bufname)
  endif


endfunction

" Report back the single line leading comment character for queried language.
function! s:GetCommentChar(ftype)
	if a:ftype == "c" || a:ftype == "cpp"
		return "\/\/"
	elseif a:ftype == "csh" || a:ftype == "perl" || a:ftype == "python" ||
   \ a:ftype == "sh"
		return "\#"
	elseif a:ftype == "vim"
		return "\""
	endif
  " default return
	return "\#"
endfunction

" Insert fold markers. 
function! <SID>InsertFoldMarkers()
	let l:comment_char = s:GetCommentChar(&filetype)
  set lazyredraw
  normal mzggzi
  " Strip trailing spaces off all found lines
  execute 'silent ' . line("'<") . ',' .  line("'<") .
        \ 'substitute/\s*$/\1/'
  execute 'silent ' . line("'>") . ',' .  line("'>") .
        \ 'substitute/\s*$/\1/'
  " Insert fold close
  if line("'<") == line("'>")
    let l:endline = line("'>") + 1
  else
    let l:endline = line("'>")
  endif
  if match(getline(line("'>")),'^\s*$') > -1
    execute line("'>") . ',' . line("'>") . ' substitute/^\s*/' .
          \ l:comment_char . '                            }}}/'
  elseif match(getline(l:endline),'^\s*'.l:comment_char) > -1
    execute l:endline . ',' .  l:endline . ' substitute/^\(.*\)$/\1   }}}/'
  else
    execute l:endline . ',' . l:endline . ' substitute/^\(.*\)$/\1     ' .
          \ l:comment_char.'   }}}/'
  endif
  while strlen(getline(l:endline)) < &textwidth
    execute 'silent ' . l:endline . ',' .  l:endline .
          \ ' substitute/\(.*\)\(\s}\{3}\)/\1     \2/'
  endwhile
  while strlen(getline(l:endline)) > &textwidth &&
      \ match(getline(l:endline),'\s\s}\{3}\d*\s*$') > 1
    execute 'silent ' . l:endline . ',' .  l:endline .
          \ ' substitute/\(.*\)\s\(\s}\{3}\)/\1\2/'
  endwhile
  " Insert fold open
  if match(getline(line("'<")),'^\s*$') > -1
    execute line("'<") . ',' . line("'<") . ' substitute/^/' .
          \ l:comment_char . '                            {{{/'
  elseif match(getline(line("'<")),'^\s*'.l:comment_char) > -1
    execute line("'<") . ',' .  line("'<") . ' substitute/^\(.*\)$/\1     {{{/'
  else
    execute line("'<") . ',' . line("'<") . ' substitute/^\(.*\)$/\1     ' .
          \ l:comment_char . '     {{{/'
  endif
  while strlen(getline("'<")) < &textwidth
    execute 'silent ' . line("'<") . ',' .  line("'<") .
          \ ' substitute/\(.*\)\(\s{\{3}\)/\1     \2/'
  endwhile
  while strlen(getline("'<")) > &textwidth &&
      \ match(getline("'<"),'\s\s{\{3}\d*\s*$') > 1
    execute 'silent ' . line("'<") . ',' .  line("'<") .
          \ ' substitute/\(.*\)\s\(\s{\{3}\)/\1\2/'
  endwhile
  normal zi`zzc
  set nolazyredraw
  redraw!
endfunction

" Remove fold markers.
function! <SID>RemoveFoldMarkers()
	let l:comment_char = s:GetCommentChar(&filetype)
  set lazyredraw
  normal mzggzi
  " Remove fold open marker
  if (match(getline(line("'<")),'^\(\s*' . l:comment_char .
   \ '\s\+\|\s\+\){\{3}\d*\s*$' )) > -1
    execute line("'<") . ',' . line("'<") . ' delete'
  elseif match(getline(line("'<")), '^\(\s*' . l:comment_char .
       \ '\s*\|\s*\)\S.*{\{3}\d*\s*$' ) > -1
    execute line("'<") . ',' . line("'<") .
          \ ' substitute/\s\{1,}['.l:comment_char.']*\s\{1,}{\{3}\d*\s*$//'
  else
    echoerr "Fold Open marker not found in the first line of the highlighted text."
    normal zi`z
    set nolazyredraw
    redraw!
    return
  endif
  " Remove fold close marker
  if line("'<") == line("'>")
    let l:endline = line("'>") + 1
  else
    let l:endline = line("'>")
  endif
  if match(getline(l:endline), '^\(\s*' . l:comment_char .
   \ '\s\+\|\s\+\)}\{3}\d*\s*$' ) > -1
    execute l:endline . ',' . l:endline . ' delete'
  elseif match(getline(l:endline),'^\(\s*' . l:comment_char .
       \ '\s*\|\s*\)\S.*[\s*['.l:comment_char.'\s\+]*}\{3}\d*\s*$' ) > -1
    execute l:endline . ',' . l:endline .
          \ ' substitute/\s\{1,}['.l:comment_char.']*\s\{1,}}\{3}\d*\s*$//'
  else
    undo
    echoerr "Fold Close marker not found in the last line of the highlighted text."
  endif
  normal zi`z
  set nolazyredraw
  redraw!
endfunction

" Seach file for fold markers & line breaks then checks/fixes the format.
function! s:UpdateFoldMarkers()
  if &modified && &foldexpr == "SF_SetFolds()"
    " get current draw and more status
    let l:current_draw = &lazyredraw
    let l:current_more = &more
    " set lazydraw and nomore.
	  set lazyredraw
    set nomore
    " open folds, save current position and move to top of file.
    normal zi
    normal mzgg
    let l:current_line = line (".")
    " search for lines to check/fix
    while search('\s\(\({\|}\)\{3}\d*\|-\{20,}\)\s*$', 'W') > 0
      " Strip trailing spaces off all found lines
      if match(getline("."),'\s*$') > 1
        execute 'silent substitute/\s*$//'
      endif
      if match(getline("."),'\s\({\|}\)\{3}\d*\s*$') > 1
        " Check/fix folder marker lines
        while strlen(getline(".")) < &textwidth
          execute 'silent substitute/\(.*\)\(\s\({\|}\)\{3}\)/\1   \2/'
        endwhile
        while strlen(getline(".")) > &textwidth &&
            \ match(getline("."),'\s\{2}\({\|}\)\{3}\d*\s*$') > 1
          execute 'silent substitute/\(.*\)\s\(\s\({\|}\)\{3}\)/\1\2/'
        endwhile
      elseif match(getline("."),'-\{20,}\s*$') > 1
      " Check/fix line breaks (i.e -------- >20 characters long)
        while strlen(getline(".")) < &textwidth
          execute 'silent substitute/\(\s-*\)/\1---/'
        endwhile
        while strlen(getline(".")) > &textwidth
          execute 'silent substitute/\(\s-\{18,}\)-\s*$/\1/'
        endwhile
      endif
      if line(".") < line("$") | +1 | else | break | endif
    endwhile
    " Restore fold status and position.
    normal `z
    normal zi
    " Redraw screen and reset lazyredraw/more to previous values.
    redraw!
    let &more = l:current_more  
    let &lazyredraw = l:current_draw 
  endif
endfunction


"                                                                            }}}
" ------------------------------------------------------------------------------
" NOTES: Fold Hints                                                          {{{
" Commands:
"     zf        Insert fold markers.
"     zd        Remove fold markers.
"   Opening and closing folds:
"     zo        Open fold one level.
"     zO        Open all folds under cursor recursively.
"     zc        Close one fold level.
"     zC        Close all folds recursively
"     zx        Undo Manually opned and closed folds, and view cursor line.
"     zX        Undo Manually opned and closed fold.
"   Fold level:
"     zm        Fold more.  Decrease foldlevel by 1.
"     zM        Close all folds.  Set foldlevel to 0.
"     zr        Fold less (reduce). Increase foldlevel by 1.
"     zR        Open all folds. Set foldlevel to highest.
"   Moving over folds:
"     [z        Move to start of current fold.
"     ]z        Move to end of current fold.
"     zj        Move down to the first line of the next fold.
"     zk        Move up to the last line of the previous fold.
"   Other fold commands:
"     zi        Toggle foldenable.
"     zn        Fold none.  Resets foldenable and all folds open.
"     zN        Fold normal. Sets foldenable and folds display as before.
"                                                                            }}}
" ------------------------------------------------------------------------------
" NOTES: Known Issues and Todo                                               {{{
" 1.  SFT_SetFoldText() sets all <tab> indents to 1 space.  Spaces are preserved
"     to width.  Not sure why it happens or how to fix.  (Hack: set expandtab)
" 2.  Look into &commentstring, how can we use that?
"                                                                            }}}
" ------------------------------------------------------------------------------
" Version History:                                                           {{{
" 1.0    02-28-2004  Initial Release.
" 1.1    04-24-2004  Consolidated SFT_SetFoldText subfunctions to improve
"                    performance. Perl, Shell, and Vim folding pattern clean
"                    ups. Added initial C language support.
" 1.2    10-13-2004  Added Fold text style & width configuration items.  Thanks
"                    to Wolfgang H. for patches and ideas.
" 1.2.1  01-28-2005  Vim syntax fix. Configured FoldOpen options. Added function
"                    to check and fix the fold marker positioning with autocmd
"                    to run just before writing the file.  Improved Marker
"                    folding.
" 1.2.2 02-01-2005   Improved fold marker fixing and added fixing for --- line
"                    breaks.
" 1.3   02-05-2005   General cleanup. More improvements to UpdateFoldMarkers().
"                    Added "Fold Hints". Added functions to insert and remove
"                    fold markers.
" 1.3.1 02-20-2005   Improvements to RemoveFoldMarkers and UpdateFoldMarkers.  
"                    Thanks to Eric for the perl folding patch and the formating 
"                    ideas.
" 1.3.2 02-27-2006   Updates to UpdateFoldMarkers (finally discovered 'set
"                    nomore' so updating won't display to screen).
"                                                                            }}}
" ------------------------------------------------------------------------------
" vim:tw=80:ts=2:sw=2:
