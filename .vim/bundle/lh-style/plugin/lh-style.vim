"=============================================================================
" File:         plugin/lh-style.vim                                    {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"               <URL:http://github.com/LucHermitte>
" License:      GPLv3 with exceptions
"               <URL:http://github.com/LucHermitte/lh-style/License.md>
" Version:      1.0.0
let s:k_version = 100
" Created:      31st May 2010
" Last Update:  17th Oct 2017
"------------------------------------------------------------------------
" Description:
"       Global commands and definitions of lh-style
" }}}1
"=============================================================================

" Avoid global reinclusion {{{1
if &cp || (exists("g:loaded_lh_style")
      \ && (g:loaded_lh_style >= s:k_version)
      \ && !exists('g:force_reload_lh_style'))
  finish
endif
let g:loaded_lh_style = s:k_version
let s:cpo_save=&cpo
set cpo&vim
" Avoid global reinclusion }}}1
"------------------------------------------------------------------------
" ## Commands and Mappings {{{1
command! -nargs=1 -complete=custom,s:Convertions
      \ NameConvert call s:NameConvert(<f-args>)
command! -nargs=1 -range -complete=custom,s:CompleteConvertNames
      \ ConvertNames <line1>,<line2>call s:ConvertNames(<f-args>)

command! -nargs=+
      \ AddStyle call lh#style#_add(<f-args>)

command! -nargs=+
      \ -complete=customlist,lh#style#_use_complete
      \ UseStyle call lh#style#_use_cmd(<f-args>)
"------------------------------------------------------------------------
" ## Register to editorconfig if found {{{1
if !empty(globpath(&rtp, 'autoload/editorconfig.vim'))
  call editorconfig#AddNewHook(function('lh#style#__editorconfig#hook'))
endif

"------------------------------------------------------------------------
" ## Functions {{{1
" Note: most functions are best placed into
" autoload/«your-initials»/«style».vim
" Keep here only the functions are are required when the plugin is loaded,
" like functions that help building a vim-menu for this plugin.
" Name transformations {{{2
let s:k_convertions = [
      \ ['upper_camel_case', 'lh#naming#to_upper_camel_case'],
      \ ['lower_camel_case', 'lh#naming#to_lower_camel_case'],
      \ ['underscore',       'lh#naming#to_underscore'],
      \ ['snake',            'lh#naming#to_underscore'],
      \ ['variable',         'lh#naming#variable'],
      \ ['getter',           'lh#naming#getter'],
      \ ['setter',           'lh#naming#setter'],
      \ ['global',           'lh#naming#global'],
      \ ['local',            'lh#naming#local'],
      \ ['member',           'lh#naming#member'],
      \ ['static',           'lh#naming#static'],
      \ ['constant',         'lh#naming#constant'],
      \ ['param',            'lh#naming#param'],
      \ ['type',             'lh#naming#type'],
      \ ['function',         'lh#naming#function']
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
