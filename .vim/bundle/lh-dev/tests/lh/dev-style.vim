"=============================================================================
" File:         tests/lh/dev-style.vim                            {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://github.com/LucHermitte/lh-dev>
" Version:      1.3.9
" Created:      14th Feb 2014
" Last Update:  06th Dec 2015
"------------------------------------------------------------------------
" Description:
"       Unit tests for lh#dev#style
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim

UTSuite [lh-dev] Testing lh#dev#style

runtime autoload/lh/dev/style.vim

" Enforce at least a filetype when run from rspec
set ft=vim

" ## Helper function
function! s:GetStyle(...)
  let style = call('lh#dev#style#get', a:000)
  let style = map(copy(style), 'v:val.replacement')
  return style
endfunction

" ## Tests {{{1
"------------------------------------------------------------------------
" # Setup/teardown {{{2
function! s:Setup()
  call lh#dev#style#clear()
endfunction

"------------------------------------------------------------------------
" # Simple tests first {{{2
" Function: s:Test_global_all() {{{3
function! s:Test_global_all()
  " Todo: play with scratch buffer
  " Yes there is a trailing whitespace
  AddStyle ; ;\ 
  AssertEqual(s:GetStyle(&ft), {';': '; '})
  AssertEqual(s:GetStyle('fake'), {';': '; '})

  AssertEqual(lh#dev#style#apply('toto;titi'), 'toto; titi')
  " Shall the function be idempotent?
  " AssertEqual(lh#dev#style#apply('toto; titi'), 'toto; titi')
  " AssertEqual(lh#dev#style#apply('toto  ;   titi'), 'toto; titi')

  AddStyle | |\n
  AssertEqual(s:GetStyle(&ft), {';': '; ', '|': '|\n'})
  AssertEqual(s:GetStyle('fake'), {';': '; ', '|': '|\n'})

  AssertEqual(lh#dev#style#apply('toto|titi'), "toto|\ntiti")
  " Shall the function be idempotent?
  " AssertEqual(lh#dev#style#apply("toto|\ntiti"), "toto|\ntiti")
  " AssertEqual(lh#dev#style#apply("toto  |\n   titi"), "toto|\ntiti")
endfunction

" Function: s:Test_local_all() {{{3
function! s:Test_local_all()
  " Todo: play with scratch buffer
  AddStyle ; ;\  -b
  AssertEqual(s:GetStyle(&ft), {';': '; '})
  AssertEqual(s:GetStyle('fake'), {';': '; '})

  AddStyle | |\n -b
  AssertEqual(s:GetStyle(&ft), {';': '; ', '|': '|\n'})
  AssertEqual(s:GetStyle('fake'), {';': '; ', '|': '|\n'})
endfunction

" Function: s:Test_global_this_ft() {{{3
function! s:Test_global_this_ft()
  AddStyle ; ;\  -ft
  AssertEqual(s:GetStyle(&ft), {';': '; '})
  AssertEqual(s:GetStyle('fake'), {})

  AddStyle | |\n -ft
  AssertEqual(s:GetStyle(&ft), {';': '; ', '|': '|\n'})
  AssertEqual(s:GetStyle('fake'), {})
endfunction

" Function: s:Test_global_SOME_ft() {{{3
function! s:Test_global_SOME_ft()
  AddStyle ; ;\  -ft=SOME
  AssertEqual(s:GetStyle('SOME'), {';': '; '})
  AssertEqual(s:GetStyle('fake'), {})
  AssertEqual(s:GetStyle(&ft), {})

  AddStyle | |\n -ft=SOME
  AssertEqual(s:GetStyle('SOME'), {';': '; ', '|': '|\n'})
  AssertEqual(s:GetStyle('fake'), {})
  AssertEqual(s:GetStyle(&ft), {})
endfunction

" Function: s:Test_local_this_ft() {{{3
function! s:Test_local_this_ft()
  AddStyle ; ;\  -ft -b
  AssertEqual(s:GetStyle(&ft), {';': '; '})
  AssertEqual(s:GetStyle('fake'), {})

  AddStyle | |\n -ft -b
  AssertEqual(s:GetStyle(&ft), {';': '; ', '|': '|\n'})
  AssertEqual(s:GetStyle('fake'), {})
endfunction

" Function: s:Test_local_SOME_ft() {{{3
function! s:Test_local_SOME_ft()
  AddStyle ; ;\  -ft=SOME -b
  AssertEqual(s:GetStyle('SOME'), {';': '; '})
  AssertEqual(s:GetStyle('fake'), {})
  AssertEqual(s:GetStyle(&ft), {})

  AddStyle | |\n -ft=SOME -b
  AssertEqual(s:GetStyle('SOME'), {';': '; ', '|': '|\n'})
  AssertEqual(s:GetStyle('fake'), {})
  AssertEqual(s:GetStyle(&ft), {})
endfunction

" }}}2
"------------------------------------------------------------------------
" # Tests with global/local overriding {{{2
" Function: s:Test_global_over_local() {{{3
function! s:Test_global_over_local()
  AddStyle ; ;\  -b
  AssertEqual(s:GetStyle('fake'), {';': '; '})
  AssertEqual(s:GetStyle(&ft)   , {';': '; '})

  AddStyle ; ;
  AssertEqual(s:GetStyle('fake'), {';': '; '})
  AssertEqual(s:GetStyle(&ft)   , {';': '; '})

  try
    new
    AssertEqual(s:GetStyle('fake'), {';': ';'})
    AssertEqual(s:GetStyle(&ft)   , {';': ';'})
  finally
    bw
  endtry
  AssertEqual(s:GetStyle('fake'), {';': '; '})
  AssertEqual(s:GetStyle(&ft)   , {';': '; '})
endfunction

" Function: s:Test_local_over_global() {{{3
function! s:Test_local_over_global()
  AddStyle ; ;\ 
  AssertEqual(s:GetStyle('fake'), {';': '; '})
  AssertEqual(s:GetStyle(&ft)   , {';': '; '})

  AddStyle ; ;  -b
  AssertEqual(s:GetStyle('fake'), {';': ';'})
  AssertEqual(s:GetStyle(&ft)   , {';': ';'})

  try
    new
    AssertEqual(s:GetStyle('fake'), {';': '; '})
    AssertEqual(s:GetStyle(&ft)   , {';': '; '})
  finally
    bw
  endtry
  AssertEqual(s:GetStyle('fake'), {';': ';'})
  AssertEqual(s:GetStyle(&ft)   , {';': ';'})
endfunction

" Function: s:Test_all_over_this_ft() {{{3
function! s:Test_all_over_this_ft()
  AddStyle ; ;\  -ft
  AssertEqual(s:GetStyle('fake'), {})
  AssertEqual(s:GetStyle(&ft)   , {';': '; '})

  AddStyle ; ;
  AssertEqual(s:GetStyle('fake'), {';': ';'})
  AssertEqual(s:GetStyle(&ft)   , {';': '; '})

  try
    new
    AssertEqual(s:GetStyle('fake'), {';': ';'})
    AssertEqual(s:GetStyle(&ft)   , {';': ';'})
  finally
    bw
  endtry
  AssertEqual(s:GetStyle('fake'), {';': ';'})
  AssertEqual(s:GetStyle(&ft)   , {';': '; '})
endfunction

" Function: s:Test_this_ft_over_all() {{{3
function! s:Test_this_ft_over_all()
  AddStyle ; ;\  -ft
  AssertEqual(s:GetStyle('fake'), {})
  AssertEqual(s:GetStyle(&ft)   , {';': '; '})

  AddStyle ; ;
  AssertEqual(s:GetStyle('fake'), {';': ';'})
  AssertEqual(s:GetStyle(&ft)   , {';': '; '})

  try
    new
    AssertEqual(s:GetStyle('fake'), {';': ';'})
    AssertEqual(s:GetStyle(&ft)   , {';': ';'})
  finally
    bw
  endtry
  AssertEqual(s:GetStyle('fake'), {';': ';'})
  AssertEqual(s:GetStyle(&ft)   , {';': '; '})
endfunction

" Function: s:Test_mix_everything() {{{3
function! s:Test_mix_everything()
  AddStyle T 1 -ft -b
  AssertEqual(s:GetStyle('fake'), {})
  AssertEqual(s:GetStyle(&ft)   , {'T': '1'})

  AddStyle T 2 -ft
  AssertEqual(s:GetStyle('fake'), {})
  AssertEqual(s:GetStyle(&ft)   , {'T': '1'})

  AddStyle T 3 -b
  AssertEqual(s:GetStyle('fake'), {'T': '3'})
  AssertEqual(s:GetStyle(&ft)   , {'T': '1'})

  AddStyle T 4
  AssertEqual(s:GetStyle('fake'), {'T': '3'})
  AssertEqual(s:GetStyle(&ft)   , {'T': '1'})

  " Check this is correctly filled
  let bufnr = bufnr('%')
  let style = lh#dev#style#debug('s:style')
  AssertEqual(len(style)  , 1)
  AssertEqual(len(style.T), 4)
  AssertEqual(style.T[0].ft         , &ft)
  AssertEqual(style.T[0].local      , bufnr)
  AssertEqual(style.T[0].replacement, '1')

  AssertEqual(style.T[1].ft         , &ft)
  AssertEqual(style.T[1].local      , -1)
  AssertEqual(style.T[1].replacement, '2')

  AssertEqual(style.T[2].ft         , '*')
  AssertEqual(style.T[2].local      , bufnr)
  AssertEqual(style.T[2].replacement, '3')

  AssertEqual(style.T[3].ft         , '*')
  AssertEqual(style.T[3].local      , -1)
  AssertEqual(style.T[3].replacement, '4')

  " Check this is correctly restituted
  AssertEqual(s:GetStyle('fake'), {'T': '3'})
  AssertEqual(s:GetStyle(&ft)   , {'T': '1'})
  AssertEqual(&ft, 'vim')
  try
    new " other ft
    AssertEqual(s:GetStyle('fake'), {'T': '4'})
    AssertEqual(s:GetStyle('vim')   , {'T': '2'})
  finally
    bw
  endtry
  try
    new " same ft
    set ft=vim
    AssertEqual(s:GetStyle('fake'), {'T': '4'})
    AssertEqual(s:GetStyle('vim')   , {'T': '2'})
  finally
    bw
  endtry
endfunction

" }}}2
"------------------------------------------------------------------------
" # Override last definition {{{2
function! s:Test_override_global()
  " Yes there is a trailing whitespace
  AddStyle ; ;\ 
  AssertEqual(s:GetStyle(&ft), {';': '; '})

  AddStyle ; zz
  AssertEqual(s:GetStyle(&ft), {';': 'zz'})
endfunction

function! s:Test_override_local()
  " Yes there is a trailing whitespace
  AddStyle ; ;\  -b
  AssertEqual(s:GetStyle(&ft), {';': '; '})

  AddStyle ; zz -b
  AssertEqual(s:GetStyle(&ft), {';': 'zz'})
endfunction

" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
