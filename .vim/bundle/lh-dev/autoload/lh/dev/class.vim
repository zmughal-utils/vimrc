"=============================================================================
" File:         autoload/lh/dev/class.vim                         {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"               <URL:http://github.com/LucHermitte/lh-dev>
" Version:      2.0.0
" Created:      31st May 2010
" Last Update:  17th Oct 2016
"------------------------------------------------------------------------
" Description:
"       Various helper functions that return ctags information on (OO) classes
"
"------------------------------------------------------------------------
" Installation:
"       Drop this file into {rtp}/autoload/lh/dev
"       Requires Vim7+, exhuberant ctags
" History:
"       v0.0.1: code moved from lh-cpp
"       v0.0.2: Ways to get class separators (mostly for lh-refactor)
"       v2.0.0: Deprecating lh#dev#option#get
" TODO:
"       - option to return inherited members
"       - option to return prototypes or function definitions
"       - option to use another code tool analysis that is not ft-dependant
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
" ## Misc Functions     {{{1
" # Version {{{2
function! lh#dev#class#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = get(s:, 'verbose', 0)
function! lh#dev#class#verbose(...)
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

function! lh#dev#class#debug(expr) abort
  return eval(a:expr)
endfunction

"------------------------------------------------------------------------
" ## Exported functions {{{1
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
" # Fetch Attributes {{{2
" @todo, may need to adapt m_member to other languages
function! lh#dev#class#attributes(id)
  return s:FetchMembers(a:id, 'm')
endfunction

" # Fetch Methods {{{2
function! lh#dev#class#methods(id)
" @todo, may need to adapt f_unction to other languages
  return s:FetchMembers(a:id, '[fp]')
endfunction

" # Fetch Attributes & Methods {{{2
" @todo, may need to adapt f_unction and m_member to other languages
function! lh#dev#class#members(id)
  return s:FetchMembers(a:id, '[mfp]')
endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
" # Class separators {{{2
function! lh#dev#class#sep_decl()
  " sorry, I do C++.
  return lh#ft#option#get('class_sep_use', &ft, '::')
endfunction

function! lh#dev#class#sep_use()
  return lh#ft#option#get('class_sep_use', &ft, '.')
endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
" # Class tags {{{2
" @pre relies on ctags via lh-tags
" @todo, may need to adapt s_struct, c_lass a,d m_member to other languages

function! lh#dev#class#get_class_tag(id)
  let tags = taglist(a:id)
  " In C++, a struct is a class, but with different default access rights
  let class_tags = filter(copy(tags), 'v:val.kind=~"[sc]"')
  return class_tags
endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
" # Ancestors {{{2
" @pre relies on ctags via lh-tags

function! lh#dev#class#fetch_direct_parents(id)
  let k_inherits = lh#ft#option#get('inherits_tag', &ft, 'inherits')

  let parents = []
  if !exists('s:instance')
    let s:instance = {}
  endif
  " 1- Fetch the tags associated to classes names a:id
  let classes = s:DoFetchClasses(a:id, s:instance)
  " select the classes that inherit from another ... in order to found their parents
  call filter(classes, 'has_key(v:val, '.string(k_inherits).')')
  " 2- Select the best match for the a:id class
  if len(classes) > 1
    echomsg "Warning lh#dev#class#fetch_direct_parents: has detected several classes named `".a:id."'"
  endif
  for class in classes
    " 3- Look at its parents
    let sParents = class.inherits
    " echomsg "[".a:id.']'.class.name . " inherits " . sParents
    let lParents = split(sParents, ',')
    " 4- Keep the best candidates as parents
    " todo: select the class that better matches the current context (imported
    " namespaces, and current namespace)
    "    -> omni#cpp#namespaces#GetContexts()
    "    How can we obtain the exact parent names without fetching them ahead ?
    "    Or may be we need to fetch (and cache them ahead)... <-------- GO for this one!
    "
    " 4.a- open a scratch buffer, goto class definition, check its context
    " 4.b- compare each parent with the context
    " 4.c- save the exact good parents
    call extend(parents, lParents)
  endfor
  return parents
endfunction

function! lh#dev#class#ancestors(id)
  try
    let id = type(a:id) == type([]) ? a:id : [a:id]
    let s:instance = {}
    let parents = lh#graph#tsort#depth(function('lh#dev#class#fetch_direct_parents'), id)
    " and then remove the first node: a:id
    call remove(parents, 0)
    " echomsg string(parents)
    return parents
  catch /Tsort.*/
    let cycle = matchstr(v:exception, '.*: \zs.*')
    throw "Cycle in ".string(a:id)." inheritance tree detected: ".cycle
  finally
    unlet s:instance
  endtry
endfunction

" With:
"   struct V {};
"   struct C1 : virtual V {};
"   struct C2 : virtual V {};
"   struct C3 : C2{};
"   struct D : C1, C3 {};
" ":Parent D" must return: [C1, C3, C2, V]
" (at least, we must see: C1 < V, and C3 < C2 < V)

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
" # Children {{{2
" @pre relies on ctags via lh-tags
" a:scope_where_to_search is a hack because listing all element to extract
" classes is very slow!
function! lh#dev#class#fetch_direct_children(id, scope_where_to_search, ...)
  let k_scope_sep = lh#ft#option#get('scope_separator', &ft, '\.')
  let k_inherits  = lh#ft#option#get('inherits_tag', &ft, 'inherits')

  let children = []
  if !exists('s:instance') || (a:0 > 0 && a:1)
    let s:instance = {}
  endif
  " 1- Fetch the tags associated to classes names a:id
  let scope = (empty(a:scope_where_to_search) || a:scope_where_to_search =~ '^\s*$' ? '' : a:scope_where_to_search.k_scope_sep)
        \ . '.*'
  let classes = s:DoFetchClasses(scope, s:instance)
  " select the classes that inherit from another ... in order to found their parents
  call filter(classes,
        \ 'has_key(v:val, '.string(k_inherits).') && v:val.'.k_inherits.'=~'.string(a:id))
  " 2- Select the best match for the a:id class
  let children = lh#list#Transform(classes, [], 'v:val.name')
  return children
endfunction

LetIfUndef g:cpp_scope_separator '::'

"------------------------------------------------------------------------
" ## Internal functions {{{1

" Returns cached information about CTags base {{{2
function! s:DoFetchClasses(id, instance)
  if has_key(a:instance, a:id)
    return a:instance[a:id]
  else
    let classes = lh#dev#option#call('class#get_class_tag', &ft, '^'.a:id.'$')
    let a:instance[a:id] = classes
    return classes
  endif
endfunction

" Returns any member (method, attribute, ...) {{{2
" @pre relies on ctags via lh-tags
" @todo, may need to adapt s_struct, and c_lass to other languages
function! s:FetchMembers(id, member_kind)
  let tags = taglist(a:id)
  let class_tags = filter(copy(tags), 'v:val.kind=~"[sc]" && v:val.name=="'.a:id.'"')
  " overwrite tagnames
  for class in class_tags
    let class.name = lh#tags#tag_name(class)
  endfor
  let class_tags = lh#list#unique_sort2(class_tags)
  " echo join(class_tags, "\n")
  let nb_matches=len(class_tags)
  let struct_class_filter = [0]
  for class in class_tags
    if class.kind == 's'
      call add(struct_class_filter, '(has_key(v:val,"struct") && v:val.struct=="'.class.name.'")')
    elseif class.kind == 'c'
      call add(struct_class_filter, '(has_key(v:val,"class") && v:val.class=="'.class.name.'")')
    endif
  endfor

  let members = filter(copy(tags), 'v:val.kind=~'.string(a:member_kind))
  let class_filter = join(struct_class_filter, '||')
  call s:Verbose ("filter=". class_filter)
  let members = filter(members, class_filter)
  return members
endfunction


"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
