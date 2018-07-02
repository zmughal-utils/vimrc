"=============================================================================
" File:         tests/lh/dev-cpptypes.vim                         {{{1
" Author:       Luc Hermitte <EMAIL:luc {dot} hermitte {at} gmail {dot} com>
"               <URL:http://github.com/LucHermitte/lh-dev>
" Version:      2.0.0.
let s:k_version = '200'
" Created:      03rd Dec 2015
" Last Update:  20th Oct 2016
"------------------------------------------------------------------------
" Description:
"       Tests to autoload/lh/dev/cpp/types.vim functions
"
"------------------------------------------------------------------------
" TODO:
" - is_base_type
" - ConstCorrectType
" - IsPointer
" - is_smart_ptr
" - is_not_owning_ptr
" - remove_ptr
" }}}1
"=============================================================================

UTSuite [lh-dev] Testing lh/dev/cpp/types.vim

runtime autoload/lh/dev/cpp/types.vim
call lh#askvim#scriptnames()

let s:cpo_save=&cpo
set cpo&vim
let s:isk_save=&cpo
set isk&vim

"------------------------------------------------------------------------
" Base types examples {{{1
let s:k_signs = ['', 'signed ', 'unsigned ']
let s:k_precs = ['', 'short ', 'long ', 'long long ']
let s:k_prec_types = ['int']
let s:k_other_types = ['double', 'long double', 'float', 'char', 'wchar_t', 'void', 'size_t', 'ptrdiff_t', 'nullptr_t', 'std::vector<std::string>::size_type']
let s:k_ptr_types = ['', '*', '**', '&', ' const*', ' const&']

" Smart pointers examples {{{1
let s:k_owning_ptr = [
      \   'std::auto_ptr<FooBar>'
      \ , 'std::unique_ptr<FooBar>'
      \ , 'std::shared_ptr<FooBar>'
      \ , 'boost::shared_ptr<FooBar>'
      \ , 'boost::scoped_ptr<FooBar>'
      \ , 'owner<FooBar*>'
      \ ]

let s:k_smart_ptr = s:k_owning_ptr +
      \ [ 'boost::weak_ptr<FooBar>'
      \ , 'std::weak_ptr<FooBar>'
      \ , 'not_null<FooBar*>'
      \ , 'owner<FooBar*>'
      \ , 'span<FooBar>'
      \ , 'not_null<FooBar*>'
      \ ]
let s:k_views =
      \ [ 'string_view'
      \ , 'span<char>'
      \ ]

" ## Fixtures {{1
function! s:Setup()
  call lh#dev#cpp#types#verbose(0)
endfunction

function! s:Teardown()
  call lh#dev#cpp#types#verbose(0)
endfunction

" ## Tests {{1

function! s:Test_is_base_type() abort " {{{2
  " The base types {{{3
  for sign in s:k_signs
    for prec in s:k_precs
      for num_t in s:k_prec_types
        for ptr in s:k_ptr_types
          let type = sign.prec.num_t.ptr
        endfor
      endfor
      AssertTxt(lh#dev#cpp#types#is_base_type(type, 1), type .' not recognized as a base type')
    endfor
  endfor

  for type in s:k_other_types
    AssertTxt(lh#dev#cpp#types#is_base_type(type, 1), type .' not recognized as a base type')
  endfor

  " C++11 typedefs {{{3
  for prec in [8, 16, 32, 64]
    for sign in ['u', '']
      for speed in ['', '_fast', '_least']
        let type = lh#fmt#printf('%1int%2%3_t', sign, speed, prec)
        AssertTxt(lh#dev#cpp#types#is_base_type(type, 1), type .' not recognized as a base type')
      endfor
    endfor
  endfor

  " Lib traits {{{3
  let type = 'domain::Vector<FooBar>::SizeType'
  let cleanup = lh#on#exit()
        \.restore_option('cpp_base_type_pattern')
  try
    let b:cpp_base_type_pattern = ''
    AssertTxt(! lh#dev#cpp#types#is_base_type(type, 1), type .' recognized as a base type')
    let b:cpp_base_type_pattern = '<SizeType>'
    AssertTxt(lh#dev#cpp#types#is_base_type(type, 1), type .' not recognized as a base type')
  finally
    call cleanup.finalize()
  endtry

  " Test non-base w/ and w/o pointers {{{3
  let type = 'std::string'
  AssertTxt(! lh#dev#cpp#types#is_base_type(type, 1), type .' recognized as a base type')
  let type = 'std::string*'
  AssertTxt(lh#dev#cpp#types#is_base_type(type, 1), type .' not recognized as a base type')

endfunction

" Function: s:Test_const_correct_type() {{{2
function! s:Test_const_correct_type() abort
  " Base types -> unchanged {{{3
  for sign in s:k_signs
    for prec in s:k_precs
      for num_t in s:k_prec_types
        let type = sign.prec.num_t
      endfor
      AssertEqual(lh#dev#cpp#types#const_correct_type(type), type)
    endfor
  endfor

  for type in s:k_other_types
      AssertEqual(lh#dev#cpp#types#const_correct_type(type), type)
  endfor

  " C++11 typedefs -> unchanged {{{3
  for prec in [8, 16, 32, 64]
    for sign in ['u', '']
      for speed in ['', '_fast', '_least']
        let type = lh#fmt#printf('%1int%2%3_t', sign, speed, prec)
        AssertEqual(lh#dev#cpp#types#const_correct_type(type), type)
      endfor
    endfor
  endfor

  " Lib traits -> unchanged {{{3
  let type = 'domain::Vector<FooBar>::SizeType'
  let cleanup = lh#on#exit()
        \.restore_option('cpp_base_type_pattern')
        \.restore_option('cpp_place_const_after_type')
  try
    let b:cpp_base_type_pattern = ''
    let b:cpp_place_const_after_type = 1
    AssertEqual(lh#dev#cpp#types#const_correct_type(type), type.' const&')
    let b:cpp_base_type_pattern = '<SizeType>'
    AssertEqual(lh#dev#cpp#types#const_correct_type(type), type)
  finally
    call cleanup.finalize()
  endtry

  " Other types {{{3
  let cleanup = lh#on#exit()
        \.restore_option('cpp_place_const_after_type')
  try
    let b:cpp_place_const_after_type = 1
    AssertEqual(lh#dev#cpp#types#const_correct_type('std::string'), 'std::string const&')
    AssertEqual(lh#dev#cpp#types#const_correct_type('std::string *'), 'std::string const*')
    AssertEqual(lh#dev#cpp#types#const_correct_type('boost::ptr_vector<Foo>'), 'boost::ptr_vector<Foo> const&')

    let b:cpp_place_const_after_type = 0
    AssertEqual(lh#dev#cpp#types#const_correct_type('std::string'), 'const std::string &')
    AssertEqual(lh#dev#cpp#types#const_correct_type('std::string *'), 'const std::string *')
  finally
    call cleanup.finalize()
  endtry

  " Yeak scoped_ptr can't be copied => const-ref
  for ptr in s:k_smart_ptr
    AssertEqual(lh#dev#cpp#types#const_correct_type(ptr), ptr)
  endfor
endfunction

" Function: s:Test_is_pointer() {{{2
function! s:Test_is_pointer() abort
  for ptr in s:k_smart_ptr
    AssertTxt(lh#dev#cpp#types#is_pointer(ptr), ptr . ' is not a pointer type')
  endfor

    Assert lh#dev#cpp#types#is_pointer('void *')
    Assert lh#dev#cpp#types#is_pointer('void **')
    Assert lh#dev#cpp#types#is_pointer('std::string*')
    Assert lh#dev#cpp#types#is_pointer('nullptr_t')

    " Non pointers
    Assert !lh#dev#cpp#types#is_pointer('std::string')
    Assert !lh#dev#cpp#types#is_pointer('owner<T&>')
    Assert !lh#dev#cpp#types#is_pointer('int')
endfunction

" Function: s:Test_is_smart_ptr() {{{2
function! s:Test_is_smart_ptr() abort
  for ptr in s:k_smart_ptr
    AssertTxt(lh#dev#cpp#types#is_smart_ptr(ptr), ptr . ' is not a smart pointer type')
  endfor

    Assert !lh#dev#cpp#types#is_smart_ptr('void *')
    Assert !lh#dev#cpp#types#is_smart_ptr('void **')
    Assert !lh#dev#cpp#types#is_smart_ptr('std::string*')
    Assert !lh#dev#cpp#types#is_smart_ptr('nullptr_t')

    " Non pointers
    Assert !lh#dev#cpp#types#is_smart_ptr('std::string')
    Assert !lh#dev#cpp#types#is_smart_ptr('owner<T&>')
endfunction

" Function: s:Test_is_not_owning_ptr() {{{2
function! s:Test_is_not_owning_ptr() abort
  for ptr in s:k_owning_ptr
    AssertTxt(!lh#dev#cpp#types#is_not_owning_ptr(ptr), ptr . ' is not a not-owning pointer type')
  endfor

  Assert lh#dev#cpp#types#is_not_owning_ptr('nullptr_t')
  " Depend on is_following_CppCoreGuideline option
  let cleanup = lh#on#exit()
        \.restore_option('is_following_CppCoreGuideline')
  try
    let b:cpp_is_following_CppCoreGuideline = 1
    " => no mention => don't own
    Assert lh#dev#cpp#types#is_not_owning_ptr('void *')
    Assert lh#dev#cpp#types#is_not_owning_ptr('void **')
    Assert lh#dev#cpp#types#is_not_owning_ptr('std::string*')

    let b:cpp_is_following_CppCoreGuideline = 0
    " => Usual case: no-mention -> likelly to own ?
    Assert !lh#dev#cpp#types#is_not_owning_ptr('void *')
    Assert !lh#dev#cpp#types#is_not_owning_ptr('void **')
    Assert !lh#dev#cpp#types#is_not_owning_ptr('std::string*')
  finally
    call cleanup.finalize()
  endtry

  " Non pointers, makes no sense.
  " Assert !lh#dev#cpp#types#is_not_owning_ptr('std::string')
  " Assert !lh#dev#cpp#types#is_not_owning_ptr('owner<T&>')
endfunction

" Function: s:Test_remove_ptr() {{{2
function! s:Test_remove_ptr() abort
    AssertEqual (lh#dev#cpp#types#remove_ptr('void *'), 'void')
    AssertEqual (lh#dev#cpp#types#remove_ptr('void **'), 'void *')
    AssertEqual (lh#dev#cpp#types#remove_ptr('std::string*'), 'std::string')
    AssertEqual (lh#dev#cpp#types#remove_ptr('std::unique_ptr<TT>'), 'TT')
    AssertEqual (lh#dev#cpp#types#remove_ptr('std::unique_ptr< TT >'), 'TT')
    AssertThrows lh#dev#cpp#types#remove_ptr('nullptr_t')
    AssertThrows lh#dev#cpp#types#remove_ptr('std::string')
    AssertThrows lh#dev#cpp#types#remove_ptr('int')

    for ptr in s:k_smart_ptr
      AssertEquals(lh#dev#cpp#types#remove_ptr(ptr), 'FooBar')
    endfor
endfunction

" Function: s:Test_remove_reference() {{{2
function! s:Test_remove_reference() abort
    AssertEqual (lh#dev#cpp#types#remove_reference('std::string&'), 'std::string')
    AssertEqual (lh#dev#cpp#types#remove_reference('std::string'),  'std::string')
    AssertEqual (lh#dev#cpp#types#remove_reference('std::string const&'), 'std::string const')
    AssertEqual (lh#dev#cpp#types#remove_reference('std::string const'),  'std::string const')
    AssertEqual (lh#dev#cpp#types#remove_reference('const std::string&'), 'const std::string')
    AssertEqual (lh#dev#cpp#types#remove_reference('const std::string'),  'const std::string')
endfunction

" Function: s:Test_remove_reference() {{{2
function! s:Test_remove_cv() abort
    AssertEqual (lh#dev#cpp#types#remove_cv('std::string'), 'std::string')
    AssertEqual (lh#dev#cpp#types#remove_cv('std::string const'),  'std::string')
    AssertEqual (lh#dev#cpp#types#remove_cv('const std::string'),  'std::string')
    AssertEqual (lh#dev#cpp#types#remove_cv('T const*'), 'T const*')
    AssertEqual (lh#dev#cpp#types#remove_cv('T const* const'), 'T const*')
    AssertEqual (lh#dev#cpp#types#remove_cv('T const* const*'), 'T const* const*')
endfunction

" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
let &isk=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
