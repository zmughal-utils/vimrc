"=============================================================================
" File:         autoload/lh/style/__braces.vim                {{{1
" Author:       Luc Hermitte <EMAIL:luc {dot} hermitte {at} gmail {dot} com>
"		<URL:http://github.com/LucHermitte/lh-style>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-style/License.md>
" Version:      1.0.0.
let s:k_version = '100'
" Created:      29th Aug 2017
" Last Update:  17th Oct 2017
"------------------------------------------------------------------------
" Description:
"       Factorize all styles related to curly-braces.
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
function! lh#style#__braces#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = get(s:, 'verbose', 0)
function! lh#style#__braces#verbose(...)
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

function! lh#style#__braces#debug(expr) abort
  return eval(a:expr)
endfunction


"------------------------------------------------------------------------
" ## Internal functions {{{1
" Function: lh#style#__braces#__new(name, local_global, ft) {{{2
function! lh#style#__braces#__new(name, local_global, ft) abort
  let style = lh#style#define_group('curly-braces', a:name, a:local_global, a:ft)
  let s:crt_style = style
  return style
endfunction

" Function: lh#style#__braces#__k_r_end_bracket(style, a:prio) {{{2
" Many styles handle `}` in the same way: K&R, Java, 1TBS, 0TBS...
" NB:
" - finally belongs to java, C#...
" - catch belongs to C++, Java...
" TODO: Provide a way to inject other keywords.
let s:follow_end_braces_keywords            = ['else', 'while', 'catch', 'finally']
let s:re_accepted_keywords_after_end_braces = '\%(' . join(s:follow_end_braces_keywords, '\|') . '\)'
let s:re_accepted_after_end_braces          = join(s:follow_end_braces_keywords + [';', '$'], '\|')
function! lh#style#__braces#__k_r_end_bracket(style, prio) abort
  let re_marker = lh#marker#txt('.\{-}') . '\|!mark!'
  " call a:style.add('}\%(\s*\%(;\|else\|while\|catch\|finally\|$\|'.re_marker.'\|!mark!\)\)\@!' , '}\n' , a:prio)
  call a:style.add('}\%(\s*\%('.s:re_accepted_after_end_braces.'\|'.re_marker.'\)\)\@!' , '}\n' , a:prio)
  " Insert a space before the keyword
  call a:style.add('}\ze\%(\s*'.s:re_accepted_keywords_after_end_braces.'\)'            , '} '  , a:prio)
  " Wait after a marker or the end-of-line (as we don't know what the user will type
  call a:style.add('}\ze\('.re_marker.'\|$\)'                                           , '}'   , a:prio)
  " Always an extra new line after the end of a declaration in C++.
  call a:style.add('};'                                                                 , '};\n', a:prio)
endfunction

"------------------------------------------------------------------------
" ## Exported functions {{{1

" Function: lh#style#__braces#none(local_global, ft) {{{2
" Permits to clear everything on this topic and to define things manually
" instead.
function! lh#style#__braces#none(local_global, ft) abort
  let style = lh#style#__braces#__new('none', a:local_global, a:ft)
  return style
endfunction

" Function: lh#style#__braces#attach(local_global, ft, prio, ...) {{{2
" "attach" comes from clang-format BreakBeforeBrace
function! lh#style#__braces#attach(local_global, ft, prio, ...) abort
  let style = lh#style#__braces#__new('attach', a:local_global, a:ft)
  " except at the start of the line
  call style.add('^\@<!{', ' {\n'  , a:prio)
  call style.add('}'     , '\n}'   , a:prio)
  call lh#style#__braces#__k_r_end_bracket(style, a:prio)
  return style
endfunction

" Function: lh#style#__braces#linux(local_global, ft, prio, ...) {{{2
" "linux" comes from clang-format BreakBeforeBrace, and it's shared with
" editor-config indent_brace_style, except the latter will change indenting
" options as well.
" Like "attach", but break before braces on function, namespace and class
" definitions.
" TODO:
" - Handle multiline statements
" - Update the definition when marker characters change
" - rename it K&R
let s:k_linux_context_no_break
      \ = '\%('
      \ .        '\<\%(if\|while\|switch\|for\)\>\s*(.*)'
      \ . '\|' . '\<do\|else\>'
      \ . '\)'
function! lh#style#__braces#linux(local_global, ft, prio, ...) abort
  let style = lh#style#__braces#__new('linux', a:local_global, a:ft)
  " Let's assume there is no function definition in a control statement, we'll
  " see about lambdas later
  call style.add(s:k_linux_context_no_break.'\zs{'              , ' {\n', a:prio)
  " break if not behind one of the previous contexts, or at the beginning of
  " the line
  call style.add('\('.s:k_linux_context_no_break.'\s*\|^\)\@<!{', '\n{\n', a:prio + 1)
  call style.add('}'                                            , '\n}'  , a:prio)
  call lh#style#__braces#__k_r_end_bracket(style, a:prio)
  return style
endfunction

" Function: lh#style#__braces#stroustrup(local_global, ft, prio, ...) {{{2
" "stroustrup" comes from clang-format BreakBeforeBrace
" Like "attach", but break before function definitions.
" TODO: handle multiline statements
let s:k_stroutrup_context_no_break
      \ = '\%('
      \ .        '\<\%(if\|while\|switch\|for\)\>\s*(.\{-})'
      \ . '\|' . '\<do\|else\>'
      \ . '\|' . '\<\%(namespace\|class\|struct\|union\|enum\).\{-}\S\>'
      \ . '\)'
function! lh#style#__braces#stroustrup(local_global, ft, prio, ...) abort
  let style = lh#style#__braces#__new('stroustrup', a:local_global, a:ft)

  " Let's assume there is no function definition in a control statement, we'll
  " see about lambdas later
  call style.add(s:k_stroutrup_context_no_break.'\zs{'              , ' {' , a:prio)
  call style.add('{', '{\n', a:prio)
  " break if not behind one of the previous contexts, or at the beginning of
  " the line
  call style.add('\('.s:k_stroutrup_context_no_break.'\s*\|^\)\@<!{', '\n{', a:prio + 1)
  call style.add('}'                                                , '\n}'  , a:prio)
  " extra \n if followed by a semi-colon
  call style.add('};'                                               , '};\n' , a:prio)
  " extra \n either way
  call style.add('};\@!'                                            , '}\n', a:prio)
  return style
endfunction

" Function: lh#style#__braces#allman(local_global, ft, prio, ...) {{{2
" Always break before braces.
" "allman" comes from clang-format BreakBeforeBrace, and it's shared with
" editor-config indent_brace_style
function! lh#style#__braces#allman(local_global, ft, prio, ...) abort
  let style = lh#style#__braces#__new('allman', a:local_global, a:ft)

  call style.add('^\@<!{' , '\n{\n' , a:prio)
  call style.add('};\@!'  , '\n}\n' , a:prio)
  call style.add('};'     , '\n};\n', a:prio)
  return style
endfunction

" Function: lh#style#__braces#gnu(local_global, ft, prio, ...) {{{2
" Always break before braces and add an extra level of indentation to braces of
" control statements, not to those of class, function or other definitions.
" "gnu" comes from clang-format BreakBeforeBrace
" TODO: adjust cindent
function! lh#style#__braces#gnu(local_global, ft, prio, ...) abort
  let style = lh#style#__braces#__new('gnu', a:local_global, a:ft)

  call style.add('^\@<!{' , '\n{\n' , a:prio)
  call style.add('};\@!'  , '\n}\n' , a:prio)
  call style.add('};'     , '\n};\n', a:prio)
  return style
endfunction

" Function: lh#style#__braces#bsd_knf(local_global, ft, prio, ...) {{{2
" https://en.wikipedia.org/wiki/Indent_style#Variant:_BSD_KNF
" TODO: handle multiline statements
let s:k_bsd_knf_context_no_break
      \ = '\%('
      \ .        '\<\%(if\|while\|switch\|for\)\>\s*(.*)'
      \ . '\|' . '\<do\|else\>'
      \ . '\)'
function! lh#style#__braces#bsd_knf(local_global, ft, prio, ...) abort
  let style = lh#style#__braces#__new('bsd_knf', a:local_global, a:ft)
  " Let's assume there is no function definition in a control statement, we'll
  " see about lambdas later
  call style.add(s:k_bsd_knf_context_no_break.'\zs{'              , ' {\n', a:prio)
  " break if not behind one of the previous contexts, or at the beginning of
  " the line
  call style.add('\('.s:k_bsd_knf_context_no_break.'\s*\|^\)\@<!{', '\n{\n', a:prio + 1)
  call style.add('};\@!'                                          , '\n}\n', a:prio)
  call style.add('};'                                             , '\n};\n', a:prio)

  " TODO: should it be registered as a paren_style?
  call style.add('\<\%(if\|while\|switch\|for\|catch\)\>\zs(', ' (', a:prio)

  return style
endfunction

" Function: lh#style#__braces#ratliff(local_global, ft, prio, ...) {{{2
let s:k_ratliff_context_no_break
      \ = '\%('
      \ .        '\<\%(if\|while\|switch\|for\)\>\s*(.*)'
      \ . '\|' . '\<do\|else\>'
      \ . '\)'
function! lh#style#__braces#ratliff(local_global, ft, prio, ...) abort
  let style = lh#style#__braces#__new('ratliff', a:local_global, a:ft)
  " Let's assume there is no function definition in a control statement, we'll
  " see about lambdas later
  call style.add(s:k_ratliff_context_no_break.'\zs{'              , ' {\n', a:prio)
  " break if not behind one of the previous contexts, or at the beginning of
  " the line
  call style.add('\('.s:k_ratliff_context_no_break.'\s*\|^\)\@<!{', '\n{\n', a:prio + 1)
  call style.add('};\@!'                                          , '\n}\n', a:prio)
  call style.add('};'                                             , '\n};\n', a:prio)
  return style
endfunction

" Function: lh#style#__braces#horstmann(local_global, ft, prio) {{{2
" Horstmann 97 style, as the 2003 one is identical to Allman's.
" TODO: adapt the indent when sw is changed, or read it in a:styles
" This also means that if Horstmann/Pico is global and &sw is not, it'll
" complicates &sw management...
function! lh#style#__braces#horstmann(local_global, ft, prio, ...) abort
  let style = lh#style#__braces#__new('horstmann', a:local_global, a:ft)
  call style.add('^\@<!{', '\n{'.repeat( ' ', &sw-1), a:prio)
  call style.add('^{'    , '\n{'.repeat( ' ', &sw-1), a:prio)
  call style.add('};\@!' , '\n}\n'                  , a:prio)
  call style.add('};'    , '\n};\n'                 , a:prio)
  return style
endfunction

" Function: lh#style#__braces#pico(local_global, ft, prio) {{{2
" TODO: adapt the indent when sw is changed, or read it in a:styles
" This also means that if Horstmann/Pico is global and &sw is not, it'll
" complicates &sw management...
function! lh#style#__braces#pico(local_global, ft, prio, ...) abort
  let style = lh#style#__braces#__new('pico', a:local_global, a:ft)
  call style.add('^\@<!{', '\n{'.repeat( ' ', &sw-1), a:prio)
  call style.add('^{'    , '{'.repeat( ' ', &sw-1)  , a:prio)
  " TODO: Don't add a space in `{}` case.
  call style.add('};\@!' , ' }\n'                   , a:prio)
  call style.add('};'    , ' };\n'                  , a:prio)
  return style
endfunction

" Function: lh#style#__braces#lisp(local_global, ft, prio) {{{2
function! lh#style#__braces#lisp(local_global, ft, prio, ...) abort
  let style = lh#style#__braces#__new('lisp', a:local_global, a:ft)
  call style.add('^\@<!{' , ' {\n', a:prio)
  call style.add('^{'     , '{\n' , a:prio) " Not meant to exist
  call style.add('}\+;\=\zs'     , '\n', a:prio)
  return style
endfunction

" Function: lh#style#__braces#java(local_global, ft, prio) {{{2
function! lh#style#__braces#java(local_global, ft, prio, ...) abort
  let style = lh#style#__braces#__new('java', a:local_global, a:ft)
  call style.add('^{'    , ' {\n'    , a:prio) " Not meant to exist
  call style.add('^\@<!{', ' {\n'    , a:prio)
  call style.add('}'                                            , '\n}'  , a:prio)
  call lh#style#__braces#__k_r_end_bracket(style, a:prio)
  return style
endfunction

"------------------------------------------------------------------------
" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
