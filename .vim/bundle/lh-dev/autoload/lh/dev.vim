"=============================================================================
" File:         autoload/lh/dev.vim                               {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://github.com/LucHermitte>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-dev/tree/master/License.md>
" Version:      2.0.0
let s:k_version = 200
" Created:      28th May 2010
" Last Update:  31st Aug 2018
"------------------------------------------------------------------------
" Description:
"       «description»
"
"------------------------------------------------------------------------
" History:
"       v2.2.0: ~ Update to lh-tags 3.0 new API
"       v2.0.0: ~ deprecating lh#dev#option#get, lh#dev#reinterpret_escaped_char
"               + Report ctags execution error
"               + Fix line field injection for recent uctags version
"       v1.6.3: ~ Typo in option
"       v1.6.2: ~ Minor refatoring
"       v1.6.1: + lh#dev#_goto_function_begin and end
"       v1.5.3: ~ enh: have lh#dev#find_function_boundaries support any
"                 language
"       v1.5.0: ~ Adapt c(pp)_ctags_understands_local_variables_in_one_pass to
"                 ctags flavor.
"       v1.3.4: ~ bug fix in lh#dev#reinterpret_escaped_char
"       v1.1.1: ~ bug fixed in lh#dev# comment related functions
"       v1.0.4: ~ bug fixed in lh#dev#__FindFunctions(line)
" 	v0.0.2: + lh#dev#*_comments()
"		+ ways to extract local variables
"		- lh#dev#_end_func fixed cursor movements
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
" ## Misc Functions     {{{1
" # Version {{{2
function! lh#dev#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = get(s:, 'verbose', 0)
function! lh#dev#verbose(...)
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

function! lh#dev#debug(expr) abort
  return eval(a:expr)
endfunction

"------------------------------------------------------------------------
" ## Exported functions {{{1

" because C&C++ b:match_words have (:) before {:} =>
let c_function_start_pat = '{'
let cpp_function_start_pat = '{'

" Function: lh#dev#reinterpret_escaped_char(seq) {{{2
" This function transforms '\<cr\>', '\<esc\>', ... '\<{keys}\>' into the
" interpreted sequences "\<cr>", "\<esc>", ...  "\<{keys}>".
" It is meant to be used by fonctions like MapNoContext(), InsertSeq(), ... as
" we can not define mappings (/abbreviations) that contain "\<{keys}>" into the
" sequence to insert.
" Note:	It accepts sequences containing double-quotes.
" @deprecated: use lh#mapping#reinterpret_escaped_char() instead
function! lh#dev#reinterpret_escaped_char(seq) abort
  call lh#notify#deprecated('lh#dev#reinterpret_escaped_char', 'lh#mapping#reinterpret_escaped_char')
  return lh#mapping#reinterpret_escaped_char(a:seq)
endfunction

" Function: lh#dev#find_function_boundaries(line) {{{2
"# Find the function that starts before {line}, and finish after.
" @todo: check monoline functions
" @note depend on tags
function! lh#dev#find_function_boundaries(line) abort
  try
    let session = lh#tags#session#get({'extract_functions': 1})
    let lTags = session.tags

    let info = lh#dev#__FindFunctions(a:line)

    let crt_function = info.idx " function starting just after the current line
    let lFunctions   = info.fn
    if crt_function == 0
      return lh#option#unset("No known function around (before) line ".a:line." in ctags base")
    endif

    " decrement by 1 to access the previous function in the list
    let crt_function -= 1
    let the_function = lFunctions[crt_function]
    let first_line = the_function.line
    call s:Verbose("Function data found: %1", the_function)

    " 2- find where the function ends
    if has_key(the_function, 'end')
      " When it can be done with ctags
      let last_line = the_function.end
    else
      " When it shall be done manually (for instance, with matchit)
      let last_line = lh#dev#__FindEndFunc(first_line)[1]
    endif
    if last_line < a:line
      return lh#option#unset("No known function around line ".a:line." in ctags base")
    endif

    let fun = {'lines': [first_line, last_line], 'fn':the_function}
    return fun
  finally
    call session.finalize()
  endtry
endfunction

" Function: lh#dev#get_variables(function_boundaries [, split points ...]) {{{2
" NB: In C++, ctags does not understand for (int i=0...), and thus it can't
" extract "i" as a local variable ...
" @note depend on tags
function! lh#dev#get_variables(function_boundaries, ...) abort
  let lVariables = lh#dev#option#call('function#_local_variables', &ft, a:function_boundaries)

  " split at given split-points
  let res = []
  let crt_list = []
  let split_point = 0
  for v in lVariables
    if split_point < a:0 && v.line >= a:000[split_point]
      call add(res, crt_list)
      let crt_list = []
      let split_point += 1
    endif
    call add(crt_list, v)
  endfor
  call add(res, crt_list)
  let res += repeat([[]], a:0 - split_point)

  return res
endfunction

"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
" # Tags sessions {{{2
let s:tags = {
      \ 'tags': [],
      \ 'count': 0
      \ }
function! lh#dev#start_tag_session(...) abort " {{{3
  call lh#notify#deprecated('lh#dev#start_tag_session', 'lh#tags#session#get')
  let s:tags = call('lh#tags#session#get', a:000)
  return s:tags
endfunction

function! lh#dev#end_tag_session() abort " {{{3
  call lh#notify#deprecated('lh#dev#end_tag_session', 'lh#tags#session#get().finalize')
  call s:tags.finalize()
endfunction

" # Cached Tags
" New: work in progress
let s:cached_tags = get(s:, 'cached_tags', {})

" Function: lh#dev#taglist(id [, filter]) {{{3
function! lh#dev#taglist(id, ...) abort
  let tags = call('lh#dev#__fetch_tags',[a:id] + a:000)
endfunction

" Function: lh#dev#__fetch_tags(id [, filter]) {{{3
function! lh#dev#__fetch_tags(id, ...) abort
  let tags = get(s:cached_tags, a:id, lh#option#unset())
  if lh#option#is_unset(tags)
    try
      " lh#dev#start_tag_session() return all tags from current buffer
      " taglist(id) filter tags matching id in &tags
      let session = lh#tags#session#get()
      let tags = session.indexer.taglist(a:id)
      if a:0 > 0
        " or lh#function#exe ...
        let tags = call(a:1, tags)
        let s:cached_tags[a:id] = tags
      endif
    finally
      call session.finalize()
    endtry
  else
    call tags.check_up_to_date()
  endif
endfunction

" # lh#dev#purge_comments(line, is_continuing_comment [, ft]) {{{2
" @return [fixed_line, is_continuing_comment]
function! lh#dev#purge_comments(line, is_continuing_comment, ...) abort
  let ft = (a:0 > 0) ? (a:1) : &ft
  let line = a:line
  let open_comment  = escape(lh#dev#option#call('_open_comment', ft) , '%<>+=*\[(){')
  let close_comment = escape(lh#dev#option#call('_close_comment', ft), '%<>+=*\[(){')
  let line_comment  = escape(lh#dev#option#call('_line_comment', ft) , '%<>+=*\[(){')
  " purge remaining comment from a previous line
  if a:is_continuing_comment
    " assert(!empty(close_comment))
    if empty(close_comment) || (-1 == match(line, close_comment))
      return ["", 1]
    else
      " todo: use p
      let line = substitute(line, '\v.{-}'.close_comment, '', '')
    endif
  endif
  " purge line comment (// in C++, # in perl, ...)
  if !empty(line_comment)
    let line = substitute(line, '\v'.line_comment.'.*', '', '')
  endif
  " purge "zone" comment (/**/ in C, ...)
  let is_continuing_comment = 0
  if !empty(open_comment)
    let line = substitute(line, '\v'.open_comment.'.{-}'.close_comment, '', 'g')
    let p = match(line, '\v'.open_comment)
    if -1 != p
      let line = line[0 : p-1]
      let is_continuing_comment = 1
    endif
  endif
  return [line, is_continuing_comment]
endfunction

"------------------------------------------------------------------------
" ## Internal functions {{{1
if !exists('s:temp_tags')
  let s:temp_tags = tempname()
  " let &tags .= ','.s:temp_tags
endif

" # lh#dev#__FindFunctions(line) {{{2
" @note depend on tags
function! lh#dev#__FindFunctions(line) abort
  try
    let session = lh#tags#session#get({'extract_functions': 1})
    let lTags = session.tags
    if empty(lTags)
      throw "No tags found, cannot find function definitions in ".expand('%')
    endif

    " 1- filter to keep functions only
    let [func_kind] = session.indexer.get_kind_flags(&ft, ['functions', 'f'])
    let lFunctions = filter(copy(lTags), 'index(func_kind, v:val.kind) >= 0')

    " Several cases to consider:
    " - no function starting before => fail
    " - the last function before terminates before as well
    " - the function starting before contains a:line

    if empty(lFunctions)
      throw "No known function in ctags base"
    endif
    " index of the function starting just after the current line
    let crt_function = lh#list#Find_if(lFunctions, 'v:val.line > '.a:line)
    if crt_function == -1 " We are after the last function
      let crt_function=len(lFunctions)
    endif
    return { 'idx': crt_function, 'fn': lFunctions}
  finally
    call session.finalize()
  endtry
endfunction

" # lh#dev#__FindEndFunc() {{{2
" @note depend on tags
function! lh#dev#__FindEndFunc(first_line) abort
  " 2.1- get the hook that find the end of a function ; default hook is based
  " on matchit , we may also want to play with tags kinds
  let end_func_hook_name = lh#ft#option#get('end_func_hook_name', &ft, 'lh#dev#_end_func')
  let hook_str = end_func_hook_name.'('.a:first_line.')'
  " 2.2- execute the hook => last line
  let last_line = eval(hook_str)
  return last_line
endfunction

" # lh#dev#__BuildCrtBufferCtags(...) {{{2
" arg1: [first-line, last-line] => imply get local variables...
" @note depend on tags
function! lh#dev#__BuildCrtBufferCtags(...) abort
  call lh#notify#deprecated('lh#dev#start_tag_session', 'lh#tags#session#get')
  return call(s:tags.analyse_buffer, a:000)
endfunction

" # lh#dev#_sort_lines(t1, t2) {{{2
function! lh#dev#_sort_lines(t1, t2) abort
  let l1 = a:t1.line
  let l2 = a:t2.line
  return    l1 == l2 ? 0
        \ : l1 >  l2 ? 1
        \ :           -1
endfunction

" # internal: matchit solution to find end of function {{{2
function! lh#dev#_end_func(line) abort
  try
    let pos0 = getpos('.')
    :exe a:line
    let start_pat = lh#ft#option#get('function_start_pat', &ft, '')
    if empty(start_pat)
      let starts = split(get(b:, 'match_words', '{,}'), ',')
      call map(starts, 'matchstr(v:val, "[^:]*")')
      let start_pat = join(starts, '\|')
    endif
    let l = search(start_pat, 'nW')
    let line = getline(l)
    let c = match(line, start_pat) " todo: check in utf-8
    " this keepjumps seems useless
    keepjumps call cursor(l, c)
    " keepjumps exe l.'normal! 0'.c.'l'
    " assert l < next func start
    " use matchit g%, to cycle backward => jump to the end of the function from
    " the beginning, avoiding any return instruction on the way
    keepjumps normal g%
    return getpos('.')
  finally
    keepjumps call setpos('.', pos0)
  endtry
endfunction

" # Comments related functions {{{2
" @move to lh/dev/comments/
" # lh#dev#_open_comment() {{{3
" @todo cache the results until :source that clears the table
function! lh#dev#_open_comment() abort
  " default asks to
  " - EnhancedCommentify
  if exists('b:ECcommentOpen') && !empty(b:ECcommentOpen) && exists('b:ECcommentClose') && !empty(b:ECcommentClose)
    return b:ECcommentOpen
  " - tComment
  " - NERDCommenter
  " - &commentstring
  elseif !empty(&commentstring) && &commentstring =~ '\v.+\%s.+'
    return matchstr(&commentstring, '\v.*\ze\%s')
  endif
  return ""
endfunction

" # lh#dev#_close_comment() {{{3
" @todo cache the results until :source that clear the table
function! lh#dev#_close_comment() abort
  " default asks to
  " - EnhancedCommentify
  if exists('b:ECcommentClose') && !empty(b:ECcommentClose)
    return b:ECcommentClose
  " - tComment
  " - NERDCommenter
  " - &commentstring
  elseif !empty(&commentstring) && &commentstring =~ '\v.+\%s.+'
    return matchstr(&commentstring, '\v.*\%s\zs.*')
  endif
  return ""
endfunction

" # lh#dev#_line_comment() {{{3
" @todo cache the results until :source that clear the table
function! lh#dev#_line_comment() abort
  " default asks to
  " - EnhancedCommentify
  if exists('b:ECcommentOpen') && !empty(b:ECcommentOpen) && (!exists('b:ECcommentClose') || empty(b:ECcommentClose))
    return b:ECcommentOpen
  " - tComment
  " - NERDCommenter
  " - &commentstring
  elseif !empty(&commentstring) && &commentstring =~ '\v.+\%s$'
    return matchstr(&commentstring, '\v.*\ze\%s.*')
  endif
  return ""
endfunction

" Function: lh#dev#_select_current_function() {{{3
" @note depend on tags
function! lh#dev#_select_current_function() abort
  let fn = lh#dev#find_function_boundaries(line('.'))
  call lh#dev#_goto_function_begin(fn)
  normal! v
  call lh#dev#_goto_function_end(fn)
endfunction

" Function: lh#dev#_goto_function_begin() {{{3
" @note depend on tags
function! lh#dev#_goto_function_begin(...) abort
  let fn = a:0>0 ? a:1 : lh#dev#find_function_boundaries(line('.'))
  exe fn.lines[0]
endfunction

" Function: lh#dev#_goto_function_end() {{{3
" @note depend on tags
function! lh#dev#_goto_function_end(...) abort
  let fn = a:0>0 ? a:1 : lh#dev#find_function_boundaries(line('.'))
  exe fn.lines[1]
endfunction
" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
