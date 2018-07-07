"=============================================================================
" File:         tests/lh/style.vim                            {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://github.com/LucHermitte/lh-style>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-style/License.md>
" Version:      1.0.0
" Created:      14th Feb 2014
" Last Update:  17th Oct 2017
"------------------------------------------------------------------------
" Description:
"       Unit tests for lh#style
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim

UTSuite [lh-style] Testing lh#style

runtime! autoload/lh/style.vim autoload/lh/style/*.vim

runtime autoload/lh/marker.vim
function! s:marker(...)
  if !exists('*lh#marker#txt')
    return '<+'.get(a:, 1, '').'+>'
  else
    return call('lh#marker#txt', a:000)
  endif
endfunction

" Enforce at least a filetype when run from rspec
set ft=vim

" ## Helper function
function! s:GetStyle(...)
  let style = call('lh#style#get', a:000)
  let style = map(copy(style), 'v:val.replacement')
  return style
endfunction

" ## Tests {{{1
"------------------------------------------------------------------------
" # Setup/teardown {{{2
function! s:Setup()
  call lh#style#clear()
endfunction

"------------------------------------------------------------------------
" # Simple tests first {{{2
" Function: s:Test_global_all() {{{3
function! s:Test_global_all()
  " Todo: play with scratch buffer
  " Yes there is a trailing whitespace
  AddStyle [[:space:]]*;[[:space:]]* ;\ 
  AssertEqual(s:GetStyle(&ft), {'[[:space:]]*;[[:space:]]*': '; '})
  AssertEqual(s:GetStyle('fake'), {'[[:space:]]*;[[:space:]]*': '; '})

  AssertEqual(lh#style#apply('toto;titi'), 'toto; titi')
  " The [[:space:]] permits to have an idempotent pattern.
  " At this point, '\' is transformed into the character '\\', which makes
  " impossible to use '\s*;\s*' => TODO: may need a way to specify regex!
  AssertEqual(lh#style#apply('toto; titi'), 'toto; titi')
  AssertEqual(lh#style#apply('toto  ;   titi'), 'toto; titi')

  AddStyle | |\n
  AssertEqual(s:GetStyle(&ft), {'[[:space:]]*;[[:space:]]*': '; ', '|': '|\n'})
  AssertEqual(s:GetStyle('fake'), {'[[:space:]]*;[[:space:]]*': '; ', '|': '|\n'})

  AssertEqual(lh#style#apply('toto|titi'), "toto|\ntiti")
  " Shall the function be idempotent?
  " AssertEqual(lh#style#apply("toto|\ntiti"), "toto|\ntiti")
  " AssertEqual(lh#style#apply("toto  |\n   titi"), "toto|\ntiti")
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

" Function: s:Test_check_prio() {{{3
function! s:Test_check_prio()
  AddStyle T glob
  AssertEqual(s:GetStyle('fake'), {'T': 'glob'})
  AssertEqual(s:GetStyle(&ft)   , {'T': 'glob'})

  AddStyle T ft -ft
  AssertEqual(s:GetStyle('fake'), {'T': 'glob'})
  AssertEqual(s:GetStyle(&ft)   , {'T': 'ft'})

  " Buffer has priority over ft
  AddStyle T buffer -b
  AssertEqual(s:GetStyle('fake'), {'T': 'buffer'})
  AssertEqual(s:GetStyle(&ft)   , {'T': 'buffer'})

  " Check this is correctly filled
  let bufnr = bufnr('%')
  let style = lh#style#debug('s:style')
  AssertEqual! (len(style)  , 1)
  AssertEqual! (len(style.T), 3)
  " First added -> global
  AssertEqual(style.T[0].ft         , '*')
  AssertEqual(style.T[0].local      , -1)
  AssertEqual(style.T[0].replacement, 'glob')

  " Second added -> ft
  AssertEqual(style.T[1].ft         , &ft)
  AssertEqual(style.T[1].local      , -1)
  AssertEqual(style.T[1].replacement, 'ft')

  " Third added -> buffer
  AssertEqual(style.T[2].ft         , '*')
  AssertEqual(style.T[2].local      , bufnr)
  AssertEqual(style.T[2].replacement, 'buffer')

  " Check this is correctly restituted
  " Current buffer, whatever the buffer => locall style
  AssertEqual(s:GetStyle('fake'), {'T': 'buffer'})
  AssertEqual(s:GetStyle(&ft)   , {'T': 'buffer'})
  AssertEqual(&ft, 'vim')
  try " other buffer, no ft => global
    new " other ft
    AssertEqual(s:GetStyle('fake'), {'T': 'glob'})
    AssertEqual(s:GetStyle('vim')   , {'T': 'ft'})
  finally
    bw
  endtry
  try " other buffer, vim ft => vimstyle
    new " same ft
    set ft=vim
    AssertEqual(s:GetStyle('fake'), {'T': 'glob'})
    AssertEqual(s:GetStyle('vim')   , {'T': 'ft'})
  finally
    bw
  endtry
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
  let style = lh#style#debug('s:style')
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

"------------------------------------------------------------------------
" # Tests with used styles {{{2
" Function: s:Test_use_attach() {{{3
function! s:Test_use_bbb_attach() abort
  try
    new " same ft
    set ft=cpp
    call lh#style#use({"BreakBeforeBraces": "attach"}, {"buffer": 1})
    AssertEqual(lh#style#apply('class toto{toto};').'##', "class toto {\ntoto\n};\n##")
    AssertEqual(lh#style#apply('foo(){toto}').'##', "foo() {\ntoto\n}##")
    AssertEqual(lh#style#apply('if(cond){toto;}else if(c2){tutu;}else{titi;}').'##', "if(cond) {\ntoto;\n} else if(c2) {\ntutu;\n} else {\ntiti;\n}##")
  finally
    bw
  endtry
endfunction

function! s:Test_use_bbb_stroustrup() " #{{{3
  " if (x < 0) {
  "     puts("Negative");
  "     negative(x);
  " }
  " else {
  "     puts("Non-negative");
  "     nonnegative(x);
  " }
  " class Vector {
  " public:
  "     Vector(int s) :elem(new double[s]), sz(s) { }   // construct a Vector
  "     double& operator[](int i) { return elem[i]; }   // element access: subscripting
  "     int size() { return sz; }
  " private:
  "     double * elem;    // pointer to the elements
  "     int sz;           // number of elements
  " };
  try
    new " same ft
    set ft=cpp
    call lh#style#use({"BreakBeforeBraces": "stroustrup"}, {"buffer": 1})
    AssertEqual(lh#style#apply('class toto{toto};').'##', "class toto {\ntoto\n};\n##")
    AssertEqual(lh#style#apply('foo(){toto}').'##', "foo()\n{\ntoto\n}\n##")
    AssertEqual(lh#style#apply('if(cond){toto}').'##', "if(cond) {\ntoto\n}\n##")
    AssertEqual(lh#style#apply('if(cond){toto;}else if(c2){tutu;}else{titi;}').'##', "if(cond) {\ntoto;\n}\nelse if(c2) {\ntutu;\n}\nelse {\ntiti;\n}\n##")
  finally
    bw
  endtry
endfunction

function! s:Test_use_bbb_linux() " #{{{3
  " if (x < 0) {
  "     puts("Negative");
  "     negative(x);
  " }
  " else {
  "     puts("Non-negative");
  "     nonnegative(x);
  " }
  " class Vector
  " {
  " public:
  "     Vector(int s) :elem(new double[s]), sz(s) { }   // construct a Vector
  "     double& operator[](int i) { return elem[i]; }   // element access: subscripting
  "     int size() { return sz; }
  " private:
  "     double * elem;    // pointer to the elements
  "     int sz;           // number of elements
  " };
  try
    new " same ft
    set ft=cpp
    call lh#style#use({"BreakBeforeBraces": "linux"}, {"buffer": 1})
    AssertEqual(lh#style#apply('class toto{toto};').'##', "class toto\n{\ntoto\n};\n##")
    AssertEqual(lh#style#apply('int main(){toto;}').'##', "int main()\n{\ntoto;\n}##")
    AssertEqual(lh#style#apply('if(cond){toto}##'), "if(cond) {\ntoto\n}\n##")
    AssertEqual(lh#style#apply('if(cond){toto}').'##', "if(cond) {\ntoto\n}##")
    AssertEqual(lh#style#apply('if(cond){toto;}else{titi;}').'##', "if(cond) {\ntoto;\n} else {\ntiti;\n}##")
  finally
    bw
  endtry
endfunction

function! s:Test_use_bbb_allman() " #{{{3
  " while (x == y)
  " {
  "     something();
  "     somethingelse();
  " }
  try
    new " same ft
    set ft=cpp
    call lh#style#use({"BreakBeforeBraces": "allman"}, {"buffer": 1})
    AssertEqual(lh#style#apply('class toto{toto};').'##', "class toto\n{\ntoto\n};\n##")
    AssertEqual(lh#style#apply('foo(){toto}').'##', "foo()\n{\ntoto\n}\n##")
    AssertEqual(lh#style#apply('if(cond){toto}').'##', "if(cond)\n{\ntoto\n}\n##")
    AssertEqual(lh#style#apply('if(cond){toto;}else{titi;}').'##', "if(cond)\n{\ntoto;\n}\nelse\n{\ntiti;\n}\n##")
    AssertEqual(lh#style#apply('if(cond){toto;}else if(c2){tutu;}else{titi;}').'##', "if(cond)\n{\ntoto;\n}\nelse if(c2)\n{\ntutu;\n}\nelse\n{\ntiti;\n}\n##")
  finally
    bw
  endtry
endfunction

function! s:Test_use_bbb_gnu() " #{{{3
  " static char *
  " concat (char *s1, char *s2)
  " {
  "   while (x == y)
  "     {
  "       something ();
  "       somethingelse ();
  "     }
  "   finalthing ();
  " }
  try
    new " same ft
    set ft=cpp
    call lh#style#use({"BreakBeforeBraces": "gnu"}, {"buffer": 1})
    AssertEqual(lh#style#apply('class toto{toto};').'##', "class toto\n{\ntoto\n};\n##")
    AssertEqual(lh#style#apply('foo(){toto}').'##', "foo()\n{\ntoto\n}\n##")
    AssertEqual(lh#style#apply('if(cond){toto}').'##', "if(cond)\n{\ntoto\n}\n##")
    AssertEqual(lh#style#apply('if(cond){toto;}else{titi;}').'##', "if(cond)\n{\ntoto;\n}\nelse\n{\ntiti;\n}\n##")
    AssertEqual(lh#style#apply('if(cond){toto;}else if(c2){tutu;}else{titi;}').'##', "if(cond)\n{\ntoto;\n}\nelse if(c2)\n{\ntutu;\n}\nelse\n{\ntiti;\n}\n##")
  finally
    bw
  endtry
endfunction

function! s:Test_use_ibs_kr() " #{{{3
  " int main(int argc, char *argv[])
  " {
  "     ...
  "     while (x == y) {
  "         something();
  "         somethingelse();
  "
  "         if (some_error)
  "             do_correct();
  "         else
  "             continue_as_usual();
  "     }
  "
  "     finalthing();
  "     ...
  " }
  try
    new " same ft
    set ft=cpp
    call lh#style#use({"indent_brace_style": "K&R"}, {"buffer": 1})
    " AssertEqual(lh#style#apply('class toto{toto};').'##', "class toto\n{\ntoto\n};\n##")
    AssertEqual(lh#style#apply('int main(){toto;}').'##', "int main()\n{\ntoto;\n}##")
    AssertEqual(lh#style#apply('int main(){toto;}'.'##'), "int main()\n{\ntoto;\n}\n##")
    AssertEqual(lh#style#apply('if(cond){toto}').'##', "if(cond) {\ntoto\n}##")
    AssertEqual(lh#style#apply('if(cond){toto;}else{titi;}').'##', "if(cond) {\ntoto;\n} else {\ntiti;\n}##")
  finally
    bw
  endtry
endfunction

function! s:Test_use_ibs_0tbs() " #{{{3
  " int main(int argc, char *argv[])
  " {
  "     if (x < 0) {
  "         puts("Negative");
  "     } else {
  "         nonnegative(x);
  "     }
  "     ...
  "     while (x == y) {
  "         something();
  "         somethingelse();
  "
  "         if (some_error)
  "             do_correct();
  "         else
  "             continue_as_usual();
  "     }
  "
  "     finalthing();
  "     ...
  " }
  try
    new " same ft
    set ft=cpp
    call lh#style#use({"indent_brace_style": "0TBS"}, {"buffer": 1})
    " AssertEqual(lh#style#apply('class toto{toto};').'##', "class toto\n{\ntoto\n};\n##")
    AssertEqual(lh#style#apply('int main(){toto;}').'##', "int main()\n{\ntoto;\n}##")
    AssertEqual(lh#style#apply('if(cond){toto}').'##', "if(cond) {\ntoto\n}##")
    AssertEqual(lh#style#apply('if(cond){toto}'.s:marker('##')), "if(cond) {\ntoto\n}".s:marker("##"))
    AssertEqual(lh#style#apply('if(cond){toto;}else{titi;}').'##', "if(cond) {\ntoto;\n} else {\ntiti;\n}##")
  finally
    bw
  endtry
endfunction

function! s:Test_use_ibs_linux_kernel() " #{{{3
  try
    new " same ft
    set ft=cpp
    call lh#style#use({"indent_brace_style": "linux_kernel"}, {"buffer": 1})
    " AssertEqual(lh#style#apply('class toto{toto};').'##', "class toto\n{\ntoto\n};\n##")
    AssertEqual(lh#style#apply('int main(){toto;}').'##', "int main()\n{\ntoto;\n}##")
    AssertEqual(lh#style#apply('if(cond){toto}##'), "if(cond) {\ntoto\n}\n##")
    AssertEqual(lh#style#apply('if(cond){toto}').'##', "if(cond) {\ntoto\n}##")
    AssertEqual(lh#style#apply('if(cond){toto;}else{titi;}').'##', "if(cond) {\ntoto;\n} else {\ntiti;\n}##")
    AssertEqual(&expandtab, 1)
    AssertEqual(&tabstop, 8)
  finally
    bw
  endtry
endfunction

function! s:Test_use_ibs_bsd_knf() " #{{{3
  try
    new " same ft
    set ft=cpp
    call lh#style#use({"indent_brace_style": "bsd_knf"}, {"buffer": 1})
    " AssertEqual(lh#style#apply('class toto{toto};').'##', "class toto\n{\ntoto\n};\n##")
    AssertEqual(lh#style#apply('int main(){toto;}').'##', "int main()\n{\ntoto;\n}\n##")
    AssertEqual(lh#style#apply('if(cond){toto}').'##', "if (cond) {\ntoto\n}\n##")
    AssertEqual(lh#style#apply('if(cond){toto;}else{titi;}').'##', "if (cond) {\ntoto;\n}\nelse {\ntiti;\n}\n##")
    AssertEqual(&expandtab, 1)
    AssertEqual(&tabstop, 8)
    AssertEqual(&sw, 4)
  finally
    bw
  endtry
endfunction

function! s:Test_use_ibs_ratliff() " #{{{3
  " Identical to 1TBS/K&R, but with a special indent value (identical to
  " Whitesmiths') but not handled by this feature
  " https://en.wikipedia.org/wiki/Indent_style#Ratliff_style
  try
    new " same ft
    set ft=cpp
    call lh#style#use({"indent_brace_style": "ratliff"}, {"buffer": 1})
    " AssertEqual(lh#style#apply('class toto{toto};').'##', "class toto\n{\ntoto\n};\n##")
    AssertEqual(lh#style#apply('int main(){toto;}').'##', "int main()\n{\ntoto;\n}\n##")
    AssertEqual(lh#style#apply('if(cond){toto}').'##', "if(cond) {\ntoto\n}\n##")
    AssertEqual(lh#style#apply('if(cond){toto;}else{titi;}').'##', "if(cond) {\ntoto;\n}\nelse {\ntiti;\n}\n##")
    " TODO: AssertMatch(&&cindent, ????)
  finally
    bw
  endtry
endfunction

function! s:Test_use_ibs_allman() " #{{{3
  " while (x == y)
  " {
  "     something();
  "     somethingelse();
  " }
  try
    new " same ft
    set ft=cpp
    call lh#style#use({"indent_brace_style": "allman"}, {"buffer": 1})
    AssertEqual(lh#style#apply('class toto{toto};').'##', "class toto\n{\ntoto\n};\n##")
    AssertEqual(lh#style#apply('foo(){toto}').'##', "foo()\n{\ntoto\n}\n##")
    AssertEqual(lh#style#apply('if(cond){toto}').'##', "if(cond)\n{\ntoto\n}\n##")
    AssertEqual(lh#style#apply('if(cond){toto;}else{titi;}').'##', "if(cond)\n{\ntoto;\n}\nelse\n{\ntiti;\n}\n##")
    AssertEqual(lh#style#apply('if(cond){toto;}else if(c2){tutu;}else{titi;}').'##', "if(cond)\n{\ntoto;\n}\nelse if(c2)\n{\ntutu;\n}\nelse\n{\ntiti;\n}\n##")
  finally
    bw
  endtry
endfunction

function! s:Test_use_ibs_whitesmthis() " #{{{3
  " Identical to Allman, but with a special indent value but not handled by
  " this feature.
  " while (x == y)
  "     {
  "     something();
  "     somethingelse();
  "     }
  try
    new " same ft
    set ft=cpp
    call lh#style#use({"indent_brace_style": "whitesmiths"}, {"buffer": 1})
    AssertEqual(lh#style#apply('class toto{toto};').'##', "class toto\n{\ntoto\n};\n##")
    AssertEqual(lh#style#apply('foo(){toto}').'##', "foo()\n{\ntoto\n}\n##")
    AssertEqual(lh#style#apply('if(cond){toto}').'##', "if(cond)\n{\ntoto\n}\n##")
    AssertEqual(lh#style#apply('if(cond){toto;}else{titi;}').'##', "if(cond)\n{\ntoto;\n}\nelse\n{\ntiti;\n}\n##")
    AssertEqual(lh#style#apply('if(cond){toto;}else if(c2){tutu;}else{titi;}').'##', "if(cond)\n{\ntoto;\n}\nelse if(c2)\n{\ntutu;\n}\nelse\n{\ntiti;\n}\n##")
    " TODO: AssertMatch(&&cindent, ????)
  finally
    bw
  endtry
endfunction

function! s:Test_use_ibs_gnu() " #{{{3
  " Identical to Allman, but with a special indent value but not handled by
  " this feature.
  " while (x == y)
  "   {
  "     something();
  "     somethingelse();
  "   }
  try
    new " same ft
    set ft=cpp
    call lh#style#use({"indent_brace_style": "GNU"}, {"buffer": 1})
    AssertEqual(lh#style#apply('class toto{toto};').'##', "class toto\n{\ntoto\n};\n##")
    AssertEqual(lh#style#apply('foo(){toto}').'##', "foo()\n{\ntoto\n}\n##")
    AssertEqual(lh#style#apply('if(cond){toto}').'##', "if(cond)\n{\ntoto\n}\n##")
    AssertEqual(lh#style#apply('if(cond){toto;}else{titi;}').'##', "if(cond)\n{\ntoto;\n}\nelse\n{\ntiti;\n}\n##")
    AssertEqual(lh#style#apply('if(cond){toto;}else if(c2){tutu;}else{titi;}').'##', "if(cond)\n{\ntoto;\n}\nelse if(c2)\n{\ntutu;\n}\nelse\n{\ntiti;\n}\n##")
    " TODO: AssertMatch(&&cindent, ????)
  finally
    bw
  endtry
endfunction

function! s:Test_use_ibs_hortsmann() " #{{{3
  " https://en.wikipedia.org/wiki/Indent_style#Horstmann_style
  " while (x == y)
  " {   something();
  "     somethingelse();
  "     //...
  "     if (x < 0)
  "     {   printf("Negative");
  "         negative(x);
  "     }
  "     else
  "     {   printf("Non-negative");
  "         nonnegative(x);
  "     }
  " }
  " finalthing();
  try
    new " same ft
    set ft=cpp
    setlocal sw=4
    AssertEqual!(&sw, 4)
    call lh#style#use({"indent_brace_style": "Horstmann"}, {"buffer": 1})
    AssertEqual(lh#style#apply('class toto{toto};').'##', "class toto\n{   toto\n};\n##")
    AssertEqual(lh#style#apply('foo(){toto}').'##', "foo()\n{   toto\n}\n##")
    AssertEqual(lh#style#apply('if(cond){toto}').'##', "if(cond)\n{   toto\n}\n##")
    AssertEqual(lh#style#apply('if(cond){toto;}else{titi;}').'##', "if(cond)\n{   toto;\n}\nelse\n{   titi;\n}\n##")
    AssertEqual(lh#style#apply('if(cond){toto;}else if(c2){tutu;}else{titi;}').'##', "if(cond)\n{   toto;\n}\nelse if(c2)\n{   tutu;\n}\nelse\n{   titi;\n}\n##")
  finally
    bw
  endtry
endfunction

function! s:Test_use_ibs_pico() " #{{{3
  " https://en.wikipedia.org/wiki/Indent_style#Pico_style
  " stuff(n):
  " { x: 3 * n;
  "   y: doStuff(x);
  "   y + x }
  try
    new " same ft
    set ft=cpp
    setlocal sw=4
    AssertEqual!(&sw, 4)
    call lh#style#use({"indent_brace_style": "Pico"}, {"buffer": 1})
    AssertEqual(lh#style#apply('class toto{toto};').'##', "class toto\n{   toto };\n##")
    AssertEqual(lh#style#apply('foo(){toto}').'##', "foo()\n{   toto }\n##")
    AssertEqual(lh#style#apply('if(cond){toto}').'##', "if(cond)\n{   toto }\n##")
    AssertEqual(lh#style#apply('if(cond){toto;}else{titi;}').'##', "if(cond)\n{   toto; }\nelse\n{   titi; }\n##")
    AssertEqual(lh#style#apply('if(cond){toto;}else if(c2){tutu;}else{titi;}').'##', "if(cond)\n{   toto; }\nelse if(c2)\n{   tutu; }\nelse\n{   titi; }\n##")
  finally
    bw
  endtry
endfunction

function! s:Test_use_ibs_lisp() " #{{{3
  " for (i = 0; i < 10; i++) {
  "     if (i % 2 == 0)
  "         doSomething(i);
  "     else {
  "         doSomethingElse(i);
  "         doThirdThing(i);}}
  try
    new " same ft
    set ft=cpp
    call lh#style#use({"indent_brace_style": "Lisp"}, {"buffer": 1})
    " AssertEqual(lh#style#apply('class toto{toto};').'##', "class toto {\ntoto};\n##")
    AssertEqual(lh#style#apply('int main(){toto;}').'##', "int main() {\ntoto;}\n##")
    AssertEqual(lh#style#apply('if(cond){toto}').'##', "if(cond) {\ntoto}\n##")
    AssertEqual(lh#style#apply('if(cond){toto}').'##', "if(cond) {\ntoto}\n##")
    AssertEqual(lh#style#apply('if(cond){toto;}else{titi;}').'##', "if(cond) {\ntoto;}\nelse {\ntiti;}\n##")
    AssertEqual(lh#style#apply('if(cond){if(cond2){toto;}else{titi;}}else{tutu;}').'##', "if(cond) {\nif(cond2) {\ntoto;}\nelse {\ntiti;}}\nelse {\ntutu;}\n##")
  finally
    bw
  endtry
endfunction

function! s:Test_use_ibs_java() " #{{{3
  try
    new " same ft
    set ft=cpp
    call lh#style#use({"indent_brace_style": "java"}, {"buffer": 1})
    " AssertEqual(lh#style#apply('class toto{toto};').'##', "class toto {\ntoto\n};\n##")
    AssertEqual(lh#style#apply('int main(){toto;}').'##', "int main() {\ntoto;\n}##")
    AssertEqual(lh#style#apply('if(cond){toto}').'##', "if(cond) {\ntoto\n}##")
    AssertEqual(lh#style#apply('if(cond){toto}##').'##', "if(cond) {\ntoto\n}\n####")
    AssertEqual(lh#style#apply('if(cond){toto;}else{titi;}').'##', "if(cond) {\ntoto;\n} else {\ntiti;\n}##")
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
" Vim: let b:vim_maintain.remove_trailing=0
