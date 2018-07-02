"=============================================================================
" File:         autoload/lh/dev.vim                               {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://github.com/LucHermitte>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-dev/tree/master/License.md>
" Version:      2.0.0
let s:k_version = 200
" Created:      28th May 2010
" Last Update:  09th Mar 2018
"------------------------------------------------------------------------
" Description:
"       «description»
"
"------------------------------------------------------------------------
" History:
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
    let lTags = lh#dev#start_tag_session()

    let info = lh#dev#__FindFunctions(a:line)

    let crt_function = info.idx " function starting just after the current line
    let lFunctions   = info.fn
    if crt_function == 0
      throw "No known function around (before) line ".a:line." in ctags base"
    endif
    " echomsg "first after=="crt_function."->".string(lFunctions[crt_function])

    " decrement by 1 to access the previous function in the list
    let crt_function -= 1
    let first_line = lFunctions[crt_function].line

    " 2- find where the function ends
    let last_line = lh#dev#__FindEndFunc(first_line)
    "
    let fun = {'lines': [first_line, last_line[1]], 'fn':lFunctions[crt_function]}
    return fun
  finally
    call lh#dev#end_tag_session()
  endtry
endfunction

" Function: lh#dev#get_variables(function_boundaries [, split points ...]) {{{2
" NB: In C++, ctags does not understand for (int i=0...), and thus it can't
" extract "i" as a local variable ...
" @note depend on tags
if lh#tags#ctags_flavour() =~ 'utags'
  let c_ctags_understands_local_variables_in_one_pass = 1
  let cpp_ctags_understands_local_variables_in_one_pass = 1
else
  let c_ctags_understands_local_variables_in_one_pass = 0
  let cpp_ctags_understands_local_variables_in_one_pass = 0
endif

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
function! lh#dev#start_tag_session() abort
  if s:tags.count < 0
    let s:tags.count = 0
  endif
  let s:tags.count += 1
  if s:tags.count == 1
    let s:tags.tags = lh#dev#__BuildCrtBufferCtags()
  endif
  return s:tags.tags
endfunction

function! lh#dev#end_tag_session() abort
  let s:tags.count -= 1
  if s:tags.count == 0
    let s:tags.tags = []
  endif
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
      call lh#dev#start_tag_session()
      let tags = taglist(a:id)
      if a:0 > 0
        " or lh#function#exe ...
        let tags = call(a:1, tags)
        let s:cached_tags[a:id] = tags
      endif
    finally
      call lh#dev#end_tag_session()
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
  let func_kind = lh#tags#func_kind(&ft)
  try
    let lTags = lh#dev#start_tag_session()
    if empty(lTags)
      throw "No tags found, cannot find function definitions in ".expand('%')
    endif

    " 1- filter to keep functions only
    let lFunctions = filter(copy(lTags), 'v:val.kind==func_kind')

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
    call lh#dev#end_tag_session()
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
  " let temp_tags = tempname()
  let ctags_dirname = fnamemodify(s:temp_tags, ':h')

  if &modified || a:0 > 0
    if a:0 > 0
      let s = a:1[0]
      let e = a:1[1]
    else
      let s = 1
      let e = '$'
    endif
    let source_name = tempname()
    call writefile(getline(s, e), source_name, 'b')
  else
    " todo: corriger le path car injecté par défaut...
    let source_name    = expand('%:p')
    " let source_name    = lh#path#relative_to(ctags_dirname, expand('%:p'))
  endif
  let ctags_pathname = s:temp_tags

  let cmd_line = lh#tags#cmd_line(ctags_pathname)
  let lang = lh#tags#option_force_lang(&ft)
  if lh#option#is_unset(lang)
    call lh#common#warning_msg("lh-tags may not know how to recognize and parse ".&ft." files")
  else
    let cmd_line .= ' --language-force='.lang
  endif
  if cmd_line =~ '--fields='
    let cmd_line = substitute(cmd_line, '--fields=\S\+', '&n', '') " inject line numbers in fields
  else
    let cmd_line .= ' --fields=n'
  endif
  " let cmd_line = substitute(cmd_line, '--fields=\S\+', '&t', '') " inject types in fields
  let cmd_line = substitute(cmd_line, '-kinds=\S\+\zsp', '', '') " remove prototypes, todo: ft-specific
  if a:0>0 || lh#ft#option#get('ctags_understands_local_variables_in_one_pass', &ft, 1)
    if stridx(cmd_line, '-kinds=') != -1
      let cmd_line = substitute(cmd_line, '-kinds=\S\+', '&l', '') " inject local variable, todo: ft-specific
    else
      let cmd_line .= ' --' . &ft . '-kinds=lv'
    endif
  endif
  let cmd_line .= ' ' . shellescape(source_name)
  if filereadable(s:temp_tags)
    call delete(s:temp_tags)
  endif
  call s:Verbose(cmd_line)
  let exec = system(cmd_line)
  if v:shell_error != 0
    throw "Cannot execute `".cmd_line."`: ".exec
  endif

  try
    let tags_save = &tags
    let &tags = s:temp_tags
    let lTags = taglist('.')
  finally
    let &tags = tags_save
    if lh#dev#verbose() < 2
      call delete(s:temp_tags)
    else
      let b = bufwinnr('%')
      call lh#buffer#jump(s:temp_tags, "sp")
      exe b.'wincmd w'
    endif
  endtry
  call s:EvalLines(lTags)
  call sort(lTags, function('lh#dev#_sort_lines'))
  return lTags
endfunction

" # s:EvalLines(list) {{{2
function! s:EvalLines(list) abort
  for t in a:list
    if !has_key(t, 'line') " sometimes, VimL declarations are badly understood
      let fields = split(t.cmd)
      for field in fields
        if field =~ '\v^\k+:'
          let [all, key, value; rest ] = matchlist(field, '\v^(\k+):(.*)')
          let t[key] = value
        elseif field =~ '^.$'
          let t.kind = field
        elseif field =~ '/.*/";'
          let t.cmd = field
        endif
      endfor
      let t.file = fields[0]
    endif
    " and do evaluate the line eventually
    let t.line = eval(t.line)
    unlet t.filename
  endfor
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
