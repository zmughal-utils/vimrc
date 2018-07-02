"=============================================================================
" File:         autoload/lh/dev/import.vim                        {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} gmail {dot} com>
"		<URL:http://github.com/LucHermitte/lh-dev>
" Version:      2.0.0
let s:k_version = '200'
" Created:      21st Apr 2015
" Last Update:  20th Feb 2018
"------------------------------------------------------------------------
" Description:
"       Generic insertion of import/#include statements
"
"------------------------------------------------------------------------
" History:      «history»
" TODO:
" * In case of C++, search first the id in lh#cpp#types#get_headers()
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
" ## Misc Functions     {{{1
" # Version {{{2
function! lh#dev#import#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = get(s:, 'verbose', 0)
function! lh#dev#import#verbose(...)
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

function! lh#dev#import#debug(expr) abort
  return eval(a:expr)
endfunction

"------------------------------------------------------------------------
" ## Exported functions {{{1

" # Add imports/include lines {{{2

" Function: lh#dev#import#is_already_imported(filename, options) {{{3
function! lh#dev#import#is_already_imported(filename, options) abort
  let symbol = get(a:options, 'symbol', '')
  " the parameter can be a module name or a filename
  keepjumps normal! gg
  let pat = lh#dev#import#_pattern(a:filename, symbol)
  let a:options.pattern = pat
  let l = search(pat, 'c')
  return l > 0
endfunction

" Function: lh#dev#import#add(filename [,options]) {{{3
" @return if anything was added
" @param options : Dict
"       - "where" : "first"/"last"/language-specific
"       - "delim" : "angle"/"quote" (C, C++)
"       - "symbol": "a-name" (everything by default) (Python)
function! lh#dev#import#add(filename, ...) abort
  call lh#dev#option#pre_load_overrides('import', &ft)
  let filename0 = lh#dev#import#_clean_filename(a:filename)
  let options = get(a:000, 0, {})
  let noNeedToProceed = lh#dev#import#is_already_imported(filename0, options)
  if noNeedToProceed
    call lh#common#warning_msg(filename0." is already ".lh#dev#import#_preterit())
    return 0
  endif
  return lh#dev#import#_do_add(a:filename, filename0, options)
endfunction

" Function: lh#dev#import#add_any(filenames, ...) {{{3
" @return if anything was added
" @param options : Dict
"       - "where" : "first"/"last"/language-specific
"       - "delim" : "angle"/"quote" (C, C++)
"       - "symbol": "a-name" (everything by default) (Python)
" @version 1.4.0
function! lh#dev#import#add_any(filenames, ...) abort
  if empty(a:filenames) | return | endif
  call lh#dev#option#pre_load_overrides('import', &ft)
  let options = get(a:000, 0, {})

  let filenames = copy(a:filenames)
  let filenames0 = map(filenames, 'lh#dev#import#_clean_filename(v:val)')
  let pred = lh#function#bind('lh#dev#import#is_already_imported(v:1_, v:2_)', 'v:1_', options)
  let idx = lh#list#find_if(filenames0, pred)
  let noNeedToProceed = idx != -1
  if noNeedToProceed
    call lh#common#warning_msg(filenames0[idx]." is already ".lh#dev#import#_preterit())
    return 0
  endif

  return lh#dev#import#_do_add(a:filenames[0], filenames0[0], options)
endfunction

"------------------------------------------------------------------------
" ## Internal functions {{{1

" # Error messages {{{2
LetIfUndef g:c_import_preterit   'included'
LetIfUndef g:vim_import_preterit 'sourced'

" Function: lh#dev#import#_preterit() {{{3
function! lh#dev#import#_preterit() abort
  return lh#ft#option#get('import_preterit', &ft, 'imported')
endfunction

" # Import Statement {{{2
LetIfUndef g:c_import_statement    '#include'
LetIfUndef g:vim_import_statement  'runtime\ ${module}'
LetIfUndef g:ruby_import_statement 'require\ '.string('${module}')

" Function: lh#dev#import#_statement() {{{3
function! lh#dev#import#_statement() abort
  let statement = lh#ft#option#get('import_statement', &ft, 'import ${module}')
  return statement
endfunction

" # Pattern {{{2
LetIfUndef g:import_pattern        '^import\s\+${module}\>'
LetIfUndef g:python_import_pattern '^import\s\+${module}\>\|^from\s\+${module}\s\+import\s\+\(.*,\s*\)\=${symbol}\>'
LetIfUndef g:ruby_import_pattern   '^\s*require\S*\s\+''${module}'''
LetIfUndef g:c_import_pattern      '^#\s*include\s*["<]${module}\>'

" Function: lh#dev#import#_pattern(file, symbol [, ft]) {{{3
function! lh#dev#import#_pattern(file, symbol, ...) abort
  let ft = a:0 == 0 ? &ft : a:1
  " Force to pass around the filetype, so that the generic version knows it
  let res = lh#dev#option#fast_call('import#_do_generate_pattern', ft, a:file, a:symbol, ft)
  return res
endfunction

" Function: lh#dev#import#_do_generate_pattern(file, symbol , ft) {{{3
function! lh#dev#import#_do_generate_pattern(file, symbol, ft) abort
  let fmt = lh#ft#option#get('import_pattern', a:ft, '^\s*import\s\+%s\>')
  let res = lh#dev#snippet#eval(fmt, {'module': (a:file), 'symbol': (a:symbol)})
  return res
endfunction

" # Clean Filename {{{2

" Function: lh#dev#import#_clean_filename(filename) {{{3
function! lh#dev#import#_clean_filename(filename) abort
  let res = lh#dev#option#fast_call('import#_do_clean_filename', &ft, a:filename)
  return res
endfunction

" Function: lh#dev#import#_do_clean_filename(filename) {{{3
function! lh#dev#import#_do_clean_filename(filename) abort
  return a:filename
endfunction

" # The import! {{{2
" Function: lh#dev#import#_do_add(filename, filename0, options) {{{3
function! lh#dev#import#_do_add(filename, filename0, options) abort
  let a:options.filename = a:filename " This may be useful for python
  let line = lh#dev#import#_search_where_to_insert(a:options)
  let a:options.line = line " This may be useful for python
  let text = lh#dev#import#_build_import_string(a:filename, a:options)
  if lh#option#is_unset(text)
    call lh#common#warning_msg(a:filename0." is already ".lh#dev#import#_preterit().' through ``'.getline(line)."''")
    return 0
  elseif type(text) == type({})
    call setline(line, getline(line). text.append)
    call lh#common#warning_msg(text.append . ' added')
  else
    call append(line, text)
    call lh#common#warning_msg(text . ' added')
  endif
  return 1
endfunction

" # Build import string {{{2
" Function: lh#dev#import#_build_import_string(filename, options) {{{3
function! lh#dev#import#_build_import_string(filename, options) abort
  let res = lh#dev#option#fast_call('import#_do_build_import_string', &ft, a:filename, a:options)
  return res
endfunction

" Function: lh#dev#import#_do_build_import_string(filename, options) {{{3
" Overridden for:
" - Python,
" - C
function! lh#dev#import#_do_build_import_string(filename, options) abort
  let symbol = get(a:options, 'symbol', '')
  let stmt = lh#dev#import#_statement()
  let res  = lh#dev#snippet#eval(stmt, {'module': a:filename, 'symbol': symbol})
  return res
endfunction

" # Search Where to insert {{{2
" Function: lh#dev#import#_search_where_to_insert(options) {{{3
function! lh#dev#import#_search_where_to_insert(options) abort
  let res = lh#dev#option#fast_call('import#_do_search_where_to_insert', &ft, a:options)
  return res
endfunction

" Function: lh#dev#import#_do_search_where_to_insert(options) {{{3
function! lh#dev#import#_do_search_where_to_insert(options) abort
  let where = get(a:options, 'where', 'last')
  " This time, we avoid to define yet another option...
  let pattern = lh#dev#import#_pattern('\f\+', '\k\+')
  if where == "last"
    keepjumps normal! G
    let line = search(pattern, 'b')
    if line == 0
      " no other #include found => like first
      let options = copy(a:options)
      let options.where = 'first'
      return lh#dev#import#_do_search_where_to_insert(options)
    endif
  elseif where == "first"
    keepjumps normal! gg
    let line = search(pattern, 'c')
    if line == 0 " try after the first #include/import
      " I hardcode here C special case
      " Search for the #ifndef/#define in case of include files
      let line = search('^#ifndef \(\k\+\)\>.*\n#define \1\>')
      if line > 0
        let line += 1
      elseif line('$') == 1 " empty file
        let line = 0
      else
        " Search for after the file headers
        let line = 1
        while line <= line('$')
          let ll = getline(line)
          if !lh#syntax#is_a_comment_at(line, 1) && !lh#syntax#is_a_comment_at(line, len(ll)+1) && ll !~ '^\s*\*'
            " Sometimes doxygen comments don't have a synstack
            break
          endif
          let line += 1
        endwhile
        let line -= line != line('$')
        call cursor(line, 0)
      endif
    else
      let line -= 1
    endif
  endif

  return line
endfunction

" }}}1
" ## Deported function (for mappings) {{{1

" Function: lh#dev#import#_insert_import(...) {{{2
function! lh#dev#import#_insert_import(...) abort
  " If there are several choices, ask which one to use.
  " But first: check the files.
  let [id, info] = lh#dev#tags#fetch("insert-include")

  let files = {}
  for t in info
    if ! has_key(files, t.filename)
      let files[t.filename] = {}
    endif
    let files[t.filename][t.kind[0]] = ''
  endfor
  " NB: there shouldn't be any to prioritize between p and f kinds as the
  " filtering on include files shall get rid of the f kinds (that exist along
  " with a prototype)
  if len(files) > 1
    call lh#common#error_msg("insert-include: too many acceptable tags for `"
          \ .id."': ".string(files))
    return
  endif
  mark '
  let fullfilename = keys(files)[0]
  let filename = fullfilename " this is the full filename
  " echo filename
  try
    call lh#dev#import#add(filename, {'fullfilename': fullfilename})
  catch /^insert-include:.* is already included/
    call lh#common#warning_msg("insert-include: ".filename.", where `"
          \ .id."' is defined, is already included")
  endtry
  echo "Use CTRL-O to go back to previous cursor position"
endfunction
" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
