"=============================================================================
" File:         autoload/lh/style.vim                         {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"               <URL:http://github.com/LucHermitte/lh-style/>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-style/tree/master/License.md>
" Version:      1.0.0
let s:k_version = 100
" Created:      12th Feb 2014
" Last Update:  17th Oct 2017
"------------------------------------------------------------------------
" Description:
"       Functions related to help implement coding styles (e.g. Allman or K&R
"       way of placing brackets, must there be spaces after ';' in for control
"       statements, ...)
"
"       Defines:
"       - support function for :AddStyle
"       - lh#style#get() that returns the style chosen for the given
"         filetype
"
" Requires:
"       - lh-vim-lib v4.0.0
" Tests:
"       See tests/lh/style.vim
" TODO:
"       Remove unloaded buffers
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim

"------------------------------------------------------------------------
" ## Misc Functions     {{{1
" # Version {{{2
function! lh#style#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = get(s:, 'verbose', 0)
function! lh#style#verbose(...)
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

function! lh#style#debug(expr) abort
  return eval(a:expr)
endfunction

" # Misc    {{{2
" s:getSNR([func_name]) {{{3
function! s:getSNR(...)
  if !exists("s:SNR")
    let s:SNR=matchstr(expand('<sfile>'), '<SNR>\d\+_\zegetSNR$')
  endif
  return s:SNR . (a:0>0 ? (a:1) : '')
endfunction

"------------------------------------------------------------------------
" ## Exported functions {{{1

" # Main Style functions {{{2
" Function: lh#style#clear() {{{3
function! lh#style#clear()
  let s:style        = {}
  let s:style_groups = {}
endfunction

" Function: lh#style#get(ft) {{{3
" priority:
" 1- same ft && buffer local
" 2- inferior ft (C++ inherits C stuff) && buffer local
" ...
" k-1- for all ft && buffer local
" k- same ft && global
" k+1- inferior ft (C++ inherits C stuff) && global
" ...
" 2*k- for all ft && global
"
" Let's say the priority is: group over single definitions
" TODO: test the new priorities
function! s:cmp_index(lhs, rhs) abort
  return a:lhs.ft_index - a:rhs.ft_index
endfunction

function! s:filter_hows(hows, fts, bufnr) abort
  " Keep only those related to the current buffer, or global
  let hows = filter(copy(a:hows), 'v:val.local == -1 || v:val.local == a:bufnr')

  if a:fts[0] != '!'
    " Compute ft adequation of the repl-ft to the current ft stack
    call map(hows, 'extend(v:val, {"ft_index": index(a:fts, v:val.ft)})')

    " Keep also only those with a related ft
    call filter(hows, 'v:val.ft_index >= 0')
  endif

  " algo: buffer locality > ft
  " We start by filtering either the local hows, or the remaining global ones
  let local_hows = filter(copy(hows), 'v:val.local == a:bufnr')
  if !empty(local_hows)
    " Note: having a mismatching ft for the current buffer makes no sense.
    " => len(local_hows) should be 1 at most
    let hows = local_hows
    " else: the initial (copied!!) value contains everything
  endif
  " call lh#assert#value(hows).not().empty()

  " Now we can sort by ft_index
  call lh#list#sort(hows, s:getSNR('cmp_index'))
  " TODO: assert -> We expect no duplicates given a ft_index
  return hows
endfunction

function! s:filter_related(styles, fts, bufnr) abort
  let styles = map(items(a:styles), '[v:val[0], s:filter_hows(v:val[1], a:fts, a:bufnr)]')
  call filter(styles, '!empty(v:val[1])')
  return styles
endfunction

function! lh#style#get_groups(ft) abort
  let fts = lh#ft#option#inherited_filetypes(a:ft) + ['*']
  let bufnr = bufnr('%')
  let style_groups = s:filter_related(s:style_groups, fts, bufnr)
  return style_groups
endfunction

function! lh#style#get(ft) abort
  let res = {}

  let fts = lh#ft#option#inherited_filetypes(a:ft) + ['*']
  let bufnr = bufnr('%')

  " Extract single definitions
  let styles = s:filter_related(s:style, fts, bufnr)
  for [pattern, hows] in styles
    call lh#assert#value(hows).not().empty()
    " call lh#assert#value(len(hows)).eq(1)
    let new_repl = {}
    let new_repl[pattern] = {'replacement': hows[0].replacement, 'prio': hows[0].prio}

    call extend(res, new_repl)
  endfor

  " Extract groups
  let style_groups = s:filter_related(s:style_groups, fts, bufnr)
  for [gname, hows] in style_groups
    call lh#assert#value(hows).not().empty()
    " call lh#assert#value(len(hows)).eq(1)
    call lh#assert#value(hows[0]).has_key('_definitions')
    for [pattern, really_how] in items(hows[0]._definitions)
      call s:Verbose("grp:%1: /%2/, hows: %2", gname, pattern, really_how)
      let new_repl = {}
      let new_repl[pattern] = {'replacement': really_how.replacement, 'prio': really_how.priority}
      call extend(res, new_repl)
    endfor
  endfor

  " Return the result...
  return res
endfunction

" Function: lh#style#_sort_styles(styles) {{{3
function! lh#style#_sort_styles(styles) abort
  let prio_lists = {}
  for [key, style] in items(a:styles)
    if !has_key(prio_lists, style.prio)
      let prio_lists[style.prio] = []
    endif
    let prio_lists[style.prio] += [key]
  endfor
  let keys = []
  for prio in lh#list#sort(copy(keys(prio_lists)), 'N')
    " let keys += reverse(lh#list#sort(map(prio_lists[prio], 'escape(v:val, "\\")')))
    let keys += reverse(lh#list#sort(prio_lists[prio]))
  endfor
  return keys
  " let keys = reverse(lh#list#sort(map(keys(a:styles), 'escape(v:val, "\\")')))
  " return keys
endfunction

" Function: lh#style#apply(text [, ft]) {{{3
function! lh#style#apply(text, ...) abort
  let ft = a:0 == 0 ? &ft : a:1
  let styles = lh#style#get(ft)
  return lh#style#apply_these(styles, a:text)
endfunction

" Function: lh#style#apply(styles, text) {{{3
" Function meant to be used in a loop after caching the styles
let g:applyied_on=[]
" function! s:cmp_e1_prio(lhs, rhs)
function! s:cmp_e1_prio(lhs, rhs)
  return get(a:lhs[1], 'prio', 0) - get(a:rhs[1], 'prio', 0)
endfunction

function! lh#style#apply_these(styles, text, ...) abort
  let g:applyied_on += [a:text]
  let s:cache_of_ignored_matches = get(a:, 1, [])
  " Alas:
  " - substitute+_get_replacement cannot work because it cannot tell exactly
  "   which key matched
  " - manual iteration with match(..., start) is not compatible with \zs
  " => patterns must explicitly specify their context
  " => new algo, new definitions
  let res = a:text
  let styles = items(a:styles)
  call lh#list#sort(styles, s:getSNR('cmp_e1_prio'))
  for [pattern, style] in styles
    " TODO: see whether a chained map() would be faster
    let res = substitute(res, pattern, style.replacement, 'g')
  endfor
  let res = call('lh#style#reinject_cached_ignored_matches', [res]+a:000)
  return res
endfunction

" Function: lh#style#reinject_cached_ignored_matches(text [, cache]) {{{3
function! s:reinject_cached_ignored_matches(match, nl) abort
  let res = s:cache_of_ignored_matches[a:match]
  if (!empty(a:nl) && res[-1:]!="\n")
    let res .= a:nl
  endif
  return res
endfunction

function! lh#style#reinject_cached_ignored_matches(text, ...) abort
  let s:cache_of_ignored_matches = get(a:, 1, [])
  if !empty(s:cache_of_ignored_matches)
    return substitute(a:text, '\v¤(\d+)¤(\n)=', '\=s:reinject_cached_ignored_matches(submatch(1), submatch(2))', 'g')
  else
    return a:text
  endif
endfunction

" Function: lh#style#ignore(pattern, local_global, ft) {{{3
function! lh#style#ignore(pattern, local_global, ft) abort
  call lh#assert#value(a:local_global).match('\v^%(l%[ocal]|g%[lobal])$', "lh#style#ignore() expects either 'local' or 'global' as 2nd parameter")
  let ignore_group = lh#style#define_group('ignored', 'ignored', a:local_global, 'c')
  call ignore_group.add(
        \ a:pattern,
        \ '\=lh#style#just_ignore_this(submatch(0))',
        \ 0)
endfunction

" Function: lh#style#just_ignore_this(text [, cache_of_ignored_matches]) {{{3
" Permits other tools to inject texts to reinject latter after style has
" been applied. See mu-template for an example of use.
function! lh#style#just_ignore_this(text, ...) abort
  " get() requires the s:var to exist, hence the explicit test
  " let cache_of_ignored_matches = get(a:, 1, s:cache_of_ignored_matches)
  let cache_of_ignored_matches = (a:0 > 0) ? (a:1) : (s:cache_of_ignored_matches)
  return "¤".(len(add(cache_of_ignored_matches, a:text))-1)."¤"
endfunction

" # lh-brackets Adapters for snippets {{{2
" Function: lh#style#surround() {{{3
function! lh#style#surround(
      \ begin, end, isLine, isIndented, goback, mustInterpret, ...) range
  let styles = lh#style#get(&ft)
  let begin = lh#style#apply_these(styles, a:begin)
  let end   = lh#style#apply_these(styles, a:end)
  return call(function('lh#map#surround'), [begin, end, a:isLine, a:isIndented, a:goback, a:mustInterpret]+a:000)
endfunction

" # Use semantically named styles {{{2
" Function: lh#style#_prepare_options_for_add_style(input_options) {{{3
function! lh#style#_prepare_options_for_add_style(input_options) abort
  let options       = []
  let local = get(a:input_options, 'buffer', 0)
  if local
    let options += ['-b']
  endif
  let prio  = get(a:input_options, 'priority', 1)
  if prio != 1
    let options += ['-pr='.prio]
  endif

  let ft    = get(a:input_options, 'ft', '*')
  let options += [join(['-ft', ft], '=')]

  return [ options, local ? 'l' : 'g', prio, ft ]
endfunction

" Function: lh#style#use(styles [, options]) {{{3
" TODO: handle:
" * incompatible families
" * editor config possible future settings
"   - spaces_around_operators (true/hybrid/false) (see
"   https://github.com/jedmao/codepainter/tree/master/test/cases)
" * clang-format settings (https://clangformat.com/)
"   - BreakBeforeBinaryOperators
"   - BreakBeforeTernaryOperators
"   - BreakConstructorInitializersBeforeComma (though one!!)
"   - IndentCaseLabels
"   - IndentFunctionDeclarationAfterType
"   - NamespaceIndentation
"   - SpaceBeforeAssignmentOperators
"   - SpacesBeforeTrailingComments
"   - SpacesInAngles
"   - SpacesInCStyleCastParentheses
" * Need to be able to clear a previous similar style
let s:k_nb_leading_chars  = len('autoload/')
let s:k_nb_trailing_chars = len('.vim') + 1
function! lh#style#use(styles, ...) abort
  " let input_options = get(a:, 1, {})
  " let [options, local_global, prio, ft] = lh#style#_prepare_options_for_add_style(input_options)

  for [style_name, style_state] in items(a:styles)
    let style_name  = tolower(style_name)
    let style_state = tolower(style_state)
    let style_state = substitute(style_state, '.*', '\L&\E', '')
    let style_state = substitute(style_state, '\W', '_', 'g')
    let path = 'autoload/**/style/'.style_name.'/'.style_state.'.vim'
    let plugins = lh#path#glob_as_list(&rtp, path)
    if empty(plugins)
      let path = 'autoload/**/style/'.style_name.'.vim'
      let plugins = lh#path#glob_as_list(&rtp, path)
    endif

    if !empty(plugins)
      let args = [a:styles, style_state ] + a:000
      let plugins_relative_to_rtp = lh#path#strip_start(plugins, &rtp)
      let funcnames = map(copy(plugins_relative_to_rtp), 'v:val[s:k_nb_leading_chars : - s:k_nb_trailing_chars]')
      call map(funcnames, 'substitute(v:val, "[/\\\\]", "#", "g")."#use"')
      call s:Verbose('Loading styles for %1: %2: -> %3', style_name, style_state, funcnames)
      return min(map(copy(funcnames), 'call (function(v:val), args)'))
    else
      call s:Verbose('No style-plugin found for %1: %2', style_name, style_state)
      return 0
    endif
  endfor
endfunction


function! s:getSID() abort
  return eval(matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_getSID$'))
endfunction
let s:k_script_name      = s:getSID()

"------------------------------------------------------------------------
" ## Internal functions {{{1
if !exists('s:style')
  call lh#style#clear()
endif

" # :UseStyle API {{{2
" Function: lh#style#_decode_use_params(pattern, ...) {{{3
function! lh#style#_decode_use_params(...) abort
  let local = -1
  let ft    = '*'
  let prio  = 1
  let list  = 0
  let name  = ''
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
    else
      let name = o
    endif
  endfor

  return [local, ft, prio, list, name]
endfunction

" Function: lh#style#_use_cmd(...) {{{3
function! lh#style#_use_cmd(...) abort
  " Analyse params {{{4
  let [local, ft, prio, list, name] = call('lh#style#_decode_use_params', a:000)

  " list styles
  if list == 1
    let groups = copy(lh#style#get_groups(ft))
    if empty(groups)
      echo "No style used for ft=".ft
      return
    endif
    let show = []
    for [group, specialisations] in groups
      for spe in specialisations
        let show += [ {'group': group, 'name': spe.name, 'ft': spe.ft, 'local': spe.local}]
      endfor
    endfor
    let align_idx = lh#list#arg_max(lh#list#get(show, 'group'), function('lh#encoding#strlen'))
    let align_group = lh#encoding#strlen(show[align_idx].group)

    let align_idx = lh#list#arg_max(lh#list#get(show, 'name'), function('lh#encoding#strlen'))
    let align_name = lh#encoding#strlen(show[align_idx].name)

    let align_idx = lh#list#arg_max(lh#list#get(show, 'ft'), function('lh#encoding#strlen'))
    let align_ft = lh#encoding#strlen(show[align_idx].ft)

    " let align_idx = lh#list#arg_max(lh#list#get(show, 'local'), function('lh#encoding#strlen'))
    " let align_local = lh#encoding#strlen(show[align_idx].local) + 1

    let text = map(copy(show), ' printf("- %-".align_group."S: %-".align_name."S ; ft: %-".align_ft."S ; local: %s(%d)", v:val.group, v:val.name, v:val.ft, v:val.local==-1 ? "*" : bufname(v:val.local), v:val.local)')
    " let show += [ printf("- %".align."s: %10s  ft: %10s  local: %d", group, spe.name, spe.ft, spe.local)]
    echo join(text, "\n")
    " if has_key(strs, 'pattern')
      " let styles = filter(copy(styles), 'v:key =~ strs.pattern')
    " endif
    " echo join(map(items(styles), 'string(v:val)'), "\n")
    return
  endif
  if empty('name')
    throw 'UseStyle: You need to specify the name of the style you want to use'
  endif

  let [all, style, value; dummy] = matchlist(name, '\v(.{-})\=(.*)')
  let options = {'ft': ft, 'prio': prio, 'local': local }
  let arg = {}
  let arg[style] = value
  call call('lh#style#use', [arg, options])
endfunction

" Function: lh#style#_use_complete(ArgLead, CmdLine, CursorPos) {{{3
let s:k_use_style_options = ['-b', '-ft']
function! lh#style#_use_complete(ArgLead, CmdLine, CursorPos) abort
  let [pos, tokens, ArgLead, CmdLine, CursorPos] = lh#command#analyse_args(a:ArgLead, a:CmdLine, a:CursorPos)
  if ArgLead =~ '^-'
    let res = copy(s:k_use_style_options)
  elseif ArgLead =~ "="
    let style = matchstr(ArgLead, '\v.{-}\ze\=')
    let res = call('lh#style#'.style.'#_known_list', [])
    call map(res, 'style."=".v:val')
  else
    let path = 'autoload/**/style/**/*.vim'
    let plugins = lh#path#glob_as_list(&rtp, path)
    " call s:Verbose("styles: %1", plugins)
    let res = map(plugins, 'matchstr(v:val, ".*[\\/]\\zs.*\\ze\\.vim")."="')
    " call s:Verbose("styles: %1", styles)
  endif
  let ArgLead = substitute(ArgLead, '\*', '.*', 'g')
  call filter(res, 'v:val =~ ArgLead')
  return res
endfunction


" # :AddStyle API {{{2
" Function: lh#style#_decode_add_params(pattern, ...) {{{3
function! lh#style#_decode_add_params(...) abort
  let local = -1
  let ft    = '*'
  let prio  = 1
  let list  = 0
  let strs  = {}
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
    elseif !has_key(strs, 'pattern')
      let strs.pattern = o
    else
      let strs.repl = o
    endif
  endfor

  return [local, ft, prio, list, strs]
endfunction

" Function: lh#style#_add(pattern, ...) {{{3
function! lh#style#_add(...) abort
  " Analyse params {{{4
  let [local, ft, prio, list, strs] = call('lh#style#_decode_add_params', a:000)

  " list styles
  if list == 1
    let styles = lh#style#get(ft)
    if has_key(strs, 'pattern')
      let styles = filter(copy(styles), 'v:key =~ strs.pattern')
    endif
    echo join(map(items(styles), 'string(v:val)'), "\n")
    return
  endif


  if !has_key(strs, 'pattern')
    throw "Pattern unspecified in ".string(a:000)
  endif
  if !has_key(strs, 'repl')
    throw "Replacement text unspecified in ".string(a:000)
  endif
  let pattern = strs.pattern
  " Interpret some escape sequences
  let repl = lh#mapping#reinterpret_escaped_char(strs.repl)

  " Add the new style {{{4
  let previous = get(s:style, pattern, [])
  " but first check whether there is already something before adding anything
  let styles = filter(copy(previous), 'v:val.local == local && v:val.ft == ft')
  if !empty(styles)
    let style = styles[0]
    let style.override = get(style, 'override', []) + [{'replacement': style.replacement, 'prio': style.prio}]
    let style.replacement = repl
    let style.prio = prio
    return {pattern: copy(style)}
  endif
  " This is new => add ;; note the "return" after the search loop
  let style = {'local': local, 'ft': ft, 'replacement': repl, 'prio': prio }
  let s:style[pattern] = previous + [style]
  call s:Verbose('Register %1 style for %2 filetype%3, of priority %4 on %5 -> %6',
        \ local < 0 ? 'global' : 'bufnr('.local.')' , ft=='*' ? 'all' : ft, ft=='*' ? 's' : '', prio, pattern, repl)
  let res = {}
  let res[pattern] = copy(style)
  return pattern
endfunction

" Function: lh#style#define_group(kind, name, local_global, ft) {{{3
function! lh#style#define_group(kind, name, local_global, ft) abort
  call lh#assert#value(a:local_global).match('\v^%(l%[ocal]|g%[lobal])$', "lh#style#define_group() expects either 'local' or 'global' as 3rd parameter")
  let previous = get(s:style_groups, a:kind, [])
  let local = (a:local_global =~ '\v^l%[local]$') ? bufnr('%') : -1
  " first check whether there is already something before adding anything
  let groups = filter(copy(previous), 'v:val.local == local && v:val.ft == a:ft')

  "TODO: if the kind contains dots, then we can support families. e.g.
  "space.brace.ec / space.brace.cf.{before,in_empty,...}
  "different family => override
  if !empty(groups)
    " We will override all the styles
    call lh#assert#value(len(groups)).eq(1)
    let group = groups[0]
  else
    " We will define a bunch of new styles
    let group = lh#object#make_top_type({'local': local, 'ft': a:ft})
    let s:style_groups[a:kind] = previous + [group]
  endif
  call lh#assert#value(group).get('ft').eq(a:ft)
  call lh#assert#value(group).get('local').eq(local)
  let group.name         = a:name
  let group._definitions = {}
  call lh#object#inject_methods(group, s:k_script_name, ['add'])
  return group
endfunction

function! s:add(pattern, repl, ...) dict abort
  call s:Verbose("Add style: /%1/ -> %2", a:pattern, a:repl)
  let prio = get(a:, 1, 1)
  let self._definitions[a:pattern] = {'replacement': a:repl, 'priority': prio}
  return self
endfunction

" # Internals {{{2
" Function: lh#style#_get_replacement(styles, match, keys, all_text) {{{3
function! lh#style#_get_replacement(styles, match, keys, all_text) abort
  " We have been called => there is a match!
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
  return substitute(a:match, a:keys[idx], a:styles[a:keys[idx]].replacement, '')
endfunction

"------------------------------------------------------------------------
" ## Default definitions {{{1

" # Space before open bracket in C & al {{{2
" A little space before all C constructs in C and child languages
" NB: the spaces isn't put before all open brackets
call lh#style#use({'spacesbeforeparens': 'ControlStatements'}, {'ft': 'c', 'prio': 10})
call lh#style#use({'spacesinptyparentheses': 'no'}           , {'ft': 'c', 'prio': 20})
" call lh#style#use({'spacesinemptyparentheses': 'no'}         , {'ft': 'c', 'prio': 20})

" # Ignore style in C comments {{{2
" # Ignore style in comments after curly brackets {{{2
" TODO
AddStyle {\ *// -ft=c \ &
AddStyle }\ *// -ft=c &

" # Multiple C++ namespaces on same line {{{2
AddStyle {\\_s*namespace -ft=cpp {\ namespace -prio=20
AddStyle }\\_s*}         -ft=cpp }\ }         -prio=20

" # Doxygen {{{2
" Doxygen Groups
call lh#style#ignore('@{' , 'global', 'c')
call lh#style#ignore('@}' , 'global', 'c')
call lh#style#ignore('\\{', 'global', 'c')
call lh#style#ignore('\\}', 'global', 'c')
" AddStyle @\\_s*{  -ft=c @{ -prio=100
" AddStyle @\\_s*}  -ft=c @} -prio=100

" Doxygen Formulas
" First \ -> cmdline => \\ == One '\' character passed to vim function
" => \\\\ => 2 '\' characters, interpreted as a single '\' character in regex
AddStyle \\\\f{ -ft=c \\\\f{
AddStyle \\\\f} -ft=c \\\\f}

" # Default style in C & al: Stroustrup/K&R {{{2
call lh#style#use({'indent_brace_style': 'Stroustrup'}       , {'ft': 'c', 'prio': 10})

" # Inhibated style in C & al: Allman, Whitesmiths, Pico {{{2
" call lh#style#use('Allman', {'ft': 'c', 'prio': 10})

" # Ignore curly-brackets on single lines {{{2
" TODO
AddStyle ^\ *{\ *$ -ft=c &
AddStyle ^\ *}\ *$ -ft=c &

" # Handle specifically empty pairs of curly-brackets {{{2
call lh#style#use({'empty_braces': 'nl'}, {'ft': 'c', 'prio': 10})
" call lh#style#use({'empty_braces': 'empty'}, {'ft': 'c', 'prio': 10})
" call lh#style#use({'empty_braces': 'space'}, {'ft': 'c', 'prio': 10})

" Mixed
" -> Split it
" AddStyle {} -ft=c -prio=5 \ {\n}
" -> On the next line (unsplit)
" AddStyle \\_s*{\\_s*} -ft=c -prio=20 \n{}
" -> On the next line (split)
" AddStyle \\_s*{\\_s*} -ft=c -prio=20 \n{\n}

" # Some generic patterns to ignore {{{2
" In my templates, I write my email address as "luc {dot} ... {at}..."
" These artefacts shall be left alone.
call lh#style#ignore('{\w\+}', 'global', 'c')

" # Java style {{{2
" Force Java style in Java
" AddStyle { -ft=java -prio=10 \ {\n
" AddStyle } -ft=java -prio=10 \n}
call lh#style#use({'indent_brace_style': 'java'}, {'ft': 'java', 'prio': 10})
call lh#style#use({'spacesbeforeparens': 'ControlStatements'}, {'ft': 'java', 'prio': 10})

" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
