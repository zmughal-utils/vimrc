"=============================================================================
" File:         plugin/dev.vim                                    {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"               <URL:http://github.com/LucHermitte>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-dev/License.md>
" Version:      1.3.0
let s:k_version = 130
" Created:      31st May 2010
" Last Update:  17th Oct 2017
"------------------------------------------------------------------------
" Description:
"       Global commands and definitions of lh-dev
" }}}1
"=============================================================================

" Avoid global reinclusion {{{1
if &cp || (exists("g:loaded_dev")
      \ && (g:loaded_dev >= s:k_version)
      \ && !exists('g:force_reload_dev'))
  finish
endif
let g:loaded_dev = s:k_version
let s:cpo_save=&cpo
set cpo&vim
" Avoid global reinclusion }}}1
"------------------------------------------------------------------------
" ## Commands and Mappings {{{1

"------------------------------------------------------------------------
" ## Register to editorconfig if found {{{1
"------------------------------------------------------------------------
" ## Functions {{{1
" Note: most functions are best placed into
" autoload/«your-initials»/«dev».vim
" Keep here only the functions are are required when the plugin is loaded,
" like functions that help building a vim-menu for this plugin.
" Name transformations {{{2
let s:k_convertions = [
      \ ['upper_camel_case', 'lh#dev#naming#to_upper_camel_case'],
      \ ['lower_camel_case', 'lh#dev#naming#to_lower_camel_case'],
      \ ['underscore',       'lh#dev#naming#to_underscore'],
      \ ['snake',            'lh#dev#naming#to_underscore'],
      \ ['variable',         'lh#dev#naming#variable'],
      \ ['getter',           'lh#dev#naming#getter'],
      \ ['setter',           'lh#dev#naming#setter'],
      \ ['global',           'lh#dev#naming#global'],
      \ ['local',            'lh#dev#naming#local'],
      \ ['member',           'lh#dev#naming#member'],
      \ ['static',           'lh#dev#naming#static'],
      \ ['constant',         'lh#dev#naming#constant'],
      \ ['param',            'lh#dev#naming#param'],
      \ ['type',             'lh#dev#naming#type'],
      \ ['function',         'lh#dev#naming#function']
      \ ]

" from plugin/vim-tip-swap-word.vim
let s:k_entity_pattern = {}
let s:k_entity_pattern.in = '\w'
let s:k_entity_pattern.out = '\W'
let s:k_entity_pattern.prev_end = '\zs\w\W\+$'

" # Functions {{{2
" Function: s:ConvertNames(repl_arg) {{{3
" Syntax: ConvertNames/{regex}/{convertion_type}
function! s:ConvertNames(repl_arg) range abort
  let sep = a:repl_arg[0]
  let fields = split(a:repl_arg, sep)
  if len(fields) != 2 && len(fields) != 3
    throw ":NameConvert/{regex}/{convertion_type}/[{opt}] expects exactly two or three parameters"
  endif
  let convertion_type = fields[1]
  let i = lh#list#find_if(s:k_convertions, 'v:1_[0]=='.string(convertion_type))
  if i == -1
    throw "convertion (".convertion_type.") not found"
  endif
  " build the action to execute
  let ConvertFunc = function(s:k_convertions[i][1])
  let action = '\=(ConvertFunc(submatch(0)))'
  let cmd = a:firstline . ',' . a:lastline . 's'
        \. sep . fields[0]
        \. sep . action
        \. sep.(len(fields)>=3 ? fields[2] : '')
  " echomsg cmd
  exe cmd
endfunction

function! s:CompleteConvertNames(ArgLead, CmdLine, CursorPs)
  let sep = a:ArgLead[0]
  let fields = split(a:ArgLead, sep)
  " call confirm(a:ArgLead . ' --- ' . a:CmdLine . ' --- ' . a:CursorPs
        " \."\n".string(fields)
        " \."\n".(len(a:ArgLead)>2 && a:ArgLead[-1:] == sep)
        " \."\n".string(lh#list#transform(s:k_convertions, [], string(sep.fields[0].sep).'.v:1_[0]'))
        " \, '&Ok')
  if len(fields) == 2 || (len(a:ArgLead)>2 && a:ArgLead[-1:] == sep)
    return join(lh#list#transform(s:k_convertions, [], string(sep.fields[0].sep).'.v:1_[0]'), "\n")
  endif
  return ""
endfunction


" Function: s:NameConvert(convertion_type) {{{3
function! s:NameConvert(convertion_type) abort
  let i = lh#list#find_if(s:k_convertions, 'v:1_[0]=='.string(a:convertion_type))
  if i == -1
    throw "convertion not found"
  endif

  let s = getline('.')
  let l = line('.')
  let c = col('.')-1
  let in  = s:k_entity_pattern.in
  let out = s:k_entity_pattern.out

  let crt_word_start = match(s[:c], in.'\+$')
  let crt_word_end  = match(s, in.out, crt_word_start)
  let crt_word = s[crt_word_start : crt_word_end]

  let new_word = function(s:k_convertions[i][1])(crt_word)

  let s2 = s[:crt_word_start-1]
        \ . new_word
        \ . (crt_word_end==-1 ? '' : s[crt_word_end+1 : -1])
  call setline(l, s2)
endfunction

function! s:Convertions(ArgLead, CmdLine, CursorPs)
  return join(lh#list#transform(s:k_convertions, [], 'v:1_[0]'), "\n")
endfunction

" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
