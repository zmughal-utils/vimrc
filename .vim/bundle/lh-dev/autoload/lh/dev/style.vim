"=============================================================================
" File:         autoload/lh/dev/style.vim                         {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"               <URL:http://github.com/LucHermitte/lh-dev/>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-dev/tree/master/License.md>
" Version:      2.0.0
let s:k_version = 2000
" Created:      12th Feb 2014
" Last Update:  24th Jul 2017
"------------------------------------------------------------------------
" Description:
"       Functions related to help implement coding styles (e.g. Allman or K&R
"       way of placing brackets, must there be spaces after ';' in for control
"       statements, ...)
"
"       Defines:
"       - support function for :AddStyle
"       - lh#dev#style#get() that returns the style chosen for the given
"         filetype
"
" Requires:
"       - lh-vim-lib v3.3.7
" Tests:
"       See tests/lh/dev-style.vim
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim

"------------------------------------------------------------------------
" ## Misc Functions     {{{1
" # Version {{{2
function! lh#dev#style#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = get(s:, 'verbose', 0)
function! lh#dev#style#verbose(...)
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

function! lh#dev#style#debug(expr) abort
  return eval(a:expr)
endfunction

"------------------------------------------------------------------------
" ## Exported functions {{{1

" # Main Style functions {{{2
" Function: lh#dev#style#clear() {{{3
function! lh#dev#style#clear()
  let s:style = {}
endfunction

" Function: lh#dev#style#get(ft) {{{3
" priority:
" 1- same ft && buffer local
" 2- same ft && global
" 3- inferior ft (C++ inherits C stuff) && buffer local
" 4- inferior ft (C++ inherits C stuff) && global
" ...
" n-1- for all ft && buffer local
" n- for all ft && global
"
" TODO: priority n-1 seems much better than priority 2: I may have to change
" that
function! lh#dev#style#get(ft) abort
  let res = {}

  let fts = lh#ft#option#inherited_filetypes(a:ft) + ['*']
  let bufnr = bufnr('%')

  for [pattern, hows] in items(s:style)
    let new_repl = {}
    let new_repl[pattern] = {}

    for how in hows
      if how.local != -1 && how.local != bufnr
        continue
      endif

      let ft = index(fts, how.ft)
      if ft < 0 | continue | endif

      if empty(new_repl[pattern])
        let new_repl[pattern] = { 'replacement': how.replacement, 'prio': how.prio }
        let new_repl.ft = ft
      else
        let old_ft = get(new_repl, 'ft', -1)
        if ft < old_ft
          let new_repl[pattern] = { 'replacement': how.replacement, 'prio': how.prio }
          let new_repl.ft = ft
        elseif ft == old_ft
          if how.local == bufnr " then we override global setting
            let new_repl[pattern] = { 'replacement': how.replacement, 'prio': how.prio }
          endif
        endif " compare fts
      endif " compare to previous definition
    endfor
    if !empty(new_repl[pattern])
      unlet new_repl.ft
      call extend(res, new_repl)
    endif
  endfor

  return res
endfunction

" Function: lh#dev#style#_sort_styles(styles) {{{3
function! lh#dev#style#_sort_styles(styles) abort
  let prio_lists = {}
  for [key, style] in items(a:styles)
    if !has_key(prio_lists, style.prio)
      let prio_lists[style.prio] = []
    endif
    let prio_lists[style.prio] += [key]
  endfor
  let keys = []
  for prio in lh#list#sort(copy(keys(prio_lists)), 'N')
    let keys += reverse(lh#list#sort(map(prio_lists[prio], 'escape(v:val, "\\")')))
  endfor
  return keys
  " let keys = reverse(lh#list#sort(map(keys(a:styles), 'escape(v:val, "\\")')))
  " return keys
endfunction

" Function: lh#dev#style#apply(text [, ft]) {{{3
let g:applyied_on=[]
function! lh#dev#style#apply(text, ...) abort
  let g:applyied_on += [a:text]
  let ft = a:0 == 0 ? &ft : a:1
  let styles = lh#dev#style#get(ft)
  let keys = lh#dev#style#_sort_styles(styles)
  if empty(keys)
    return a:text
  else
    let sKeys = join(keys, '\|')
    " Using a sorted list of keys permits to avoid triggering "}" style on
    " "class {};" when there is a "};" style.
    let res = substitute(a:text, sKeys, '\=lh#dev#style#_get_replacement(styles, submatch(0), keys, a:text)', 'g')
  endif
  return res
endfunction

" # lh-brackets Adapters for snippets {{{2
" Function: lh#dev#style#surround() {{{3
function! lh#dev#style#surround(
      \ begin, end, isLine, isIndented, goback, mustInterpret, ...) range
  let begin = lh#dev#style#apply(a:begin)
  let end   = lh#dev#style#apply(a:end)
  return call(function('lh#map#surround'), [begin, end, a:isLine, a:isIndented, a:goback, a:mustInterpret]+a:000)
endfunction

"------------------------------------------------------------------------
" ## Internal functions {{{1
if !exists('s:style')
  call lh#dev#style#clear()
endif

" # :AddStyle API {{{2
" Function: lh#dev#style#_add(pattern, ...) {{{3
function! lh#dev#style#_add(...) abort
  " Analyse params {{{4
  let local = -1
  let ft    = '*'
  let prio  = 1
  let list  = 0
  for o in a:000
    if     o =~ '-b\%[uffer]'
      let local = bufnr('%')
    elseif o =~ '-pr\%[iority]'
      let prio = matchstr(o, '.*=\zs.*')
    elseif o =~ '-ft\|-filetype'
      let ft = matchstr(o, '.*=\zs.*')
      if empty(ft)
        let ft = &ft
      endif
    elseif o =~ '-l\%[ist]'
      let list = 1
    elseif !exists('pattern')
      let pattern = o
    else
      let repl = o
    endif
  endfor

  " list styles
  if list == 1
    let styles = lh#dev#style#get(ft)
    if exists('pattern')
      let styles = filter(copy(styles), 'v:key =~ pattern')
    endif
    echo join(map(items(styles), 'string(v:val)'), "\n")
    return
  endif


  if !exists('pattern')
    throw "Pattern unspecified in ".string(a:000)
  endif
  if !exists('repl')
    throw "Replacement text unspecified in ".string(a:000)
  endif
  " Interpret some escape sequences
  let repl = lh#mapping#reinterpret_escaped_char(repl)

  " Add the new style {{{4
  let previous = get(s:style, pattern, [])
  " but first check whether there is already something before adding anything
  for style in previous
    if style.local == local && style.ft == ft
      let style.replacement = repl
      let style.prio = prio
      return
    endif
  endfor
  " This is new => add ;; note the "return" in the search loop
  let s:style[pattern] = previous +
        \ [ {'local': local, 'ft': ft, 'replacement': repl, 'prio': prio }]
  call s:Verbose('Register %1 style for %2 filetype%3, of priority %4 on %5 -> %6',
        \ local < 0 ? 'global' : 'bufnr('.local.')' , ft=='*' ? 'all' : ft, ft=='*' ? 's' : '', prio, pattern, repl)
endfunction

" # Internals {{{2
" Function: lh#dev#style#_get_replacement(styles, match, keys, all_text) {{{3
function! lh#dev#style#_get_replacement(styles, match, keys, all_text) abort
  " if has_key(a:styles, a:match)
  "   return a:styles[a:match].replacement
  " else
  "   We have been called => there is a match!
  let idx = lh#list#match_re(a:keys, a:match)
  if a:keys[idx] =~ '^^\|$$'
    " echomsg "match begin/end"
    " Then, we have to match on all_text as well
    if a:all_text !~ a:keys[idx]
      " Search for another index
      let idx = lh#list#match_re(a:keys, a:match, idx+1)
    endif
  endif
  " echomsg "match: ". a:keys[idx] . " -> " . (a:styles[a:keys[idx]].replacement)
  return substitute(a:match, a:match, a:styles[a:keys[idx]].replacement, '')
  " endif
endfunction

"------------------------------------------------------------------------
" ## Default definitions {{{1

" # Space before open bracket in C & al {{{2
" A little space before all C constructs in C and child languages
" NB: the spaces isn't put before all open brackets
AddStyle if(     -ft=c   if\ (
AddStyle while(  -ft=c   while\ (
AddStyle for(    -ft=c   for\ (
AddStyle switch( -ft=c   switch\ (
AddStyle catch(  -ft=cpp catch\ (

" # Ignore style in C comments {{{2
" # Ignore style in comments after curly brackets {{{2
AddStyle {\ *// -ft=c \ &
AddStyle }\ *// -ft=c &

" # Multiple C++ namespaces on same line {{{2
AddStyle {\ *namespace -ft=cpp \ &
AddStyle }\ *} -ft=cpp &

" # Doxygen {{{2
" Doxygen Groups
AddStyle @{  -ft=c @{
AddStyle @}  -ft=c @}

" Doxygen Formulas
AddStyle \\f{ -ft=c \\\\f{
AddStyle \\f} -ft=c \\\\f}

" # Default style in C & al: Stroustrup/K&R {{{2
AddStyle {  -ft=c -prio=10 \ {\n
AddStyle }; -ft=c -prio=10 \n};\n
AddStyle }  -ft=c -prio=10 \n}

" # Inhibated style in C & al: Allman, Whitesmiths, Pico {{{2
" AddStyle {  -ft=c -prio=10 \n{\n
" AddStyle }; -ft=c -prio=10 \n};\n
" AddStyle }  -ft=c -prio=10 \n}\n

" # Ignore curly-brackets on single lines {{{2
AddStyle ^\ *{\ *$ -ft=c &
AddStyle ^\ *}\ *$ -ft=c &

" # Handle specifically empty pairs of curly-brackets {{{2
" On its own line
" -> Leave it be
AddStyle ^\ *{}\ *$ -ft=c &
" -> Split it
" AddStyle ^\ *{}\ *$ -ft=c {\n}

" Mixed
" -> Split it
" AddStyle {} -ft=c -prio=5 \ {\n}
" -> On the next line (unsplit)
AddStyle {} -ft=c -prio=5 \n{}
" -> On the next line (split)
" AddStyle {} -ft=c -prio=5 \n{\n}

" # Java style {{{2
" Force Java style in Java
AddStyle { -ft=java -prio=10 \ {\n
AddStyle } -ft=java -prio=10 \n}

" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
