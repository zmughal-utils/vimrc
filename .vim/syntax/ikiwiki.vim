" Vim syntax file
" Language:     Ikiwiki (links and directives)
" Maintainer:   Javier Rojas <jerojasro@devnull.li>
" Last Change:  July 18, 2010

" Instructions:
"               - make sure to use the relevant syntax file which can be found
"                 at vim.org; below are the syntax files for markdown and reST,
"                 respectively:
"                 	http://www.vim.org/scripts/script.php?script_id=1242
"			http://www.vim.org/scripts/script.php?script_id=973
"               - if you use a different markup other than markdown (e.g. reST)
"                 make sure to setup 'g:ikiwiki_render_filetype' properly in
"                 your startup file (skip this step for mkd.vim, it should work
"                 out of the box)
" Former Maintainer: Recai Oktaş (roktasATdebian.org)

let s:cpo_save = &cpo
set cpo&vim

"{{{1 Load the base syntax (default to markdown) if nothing was loaded.
if !exists("b:current_syntax")
	let s:ikiwiki_render_filetype = "mkd"
	if exists("g:ikiwiki_render_filetype")
		let s:ikiwiki_render_filetype = g:ikiwiki_render_filetype
	endif
	exe 'runtime! syntax/' . s:ikiwiki_render_filetype . '.vim'
endif " }}}1

if exists("b:current_syntax")
	unlet b:current_syntax
endif

syn case match

" {{{1 wikilink definition.
" {{{2 docs:
" it takes into account:
"
" named links
"   [[link|link text]]
"
" multiline links
"   [[link|text
"     that expands over
"     multiple lines]]
"
"  and not-links
"    \[[not a link]]
" {{{2
syn region ikiBla matchgroup=ikiLinkDelim start=+\[\[\ze[^!]+ end=+\]\]+ 
	 \ contains=ikiLinkVName,ikiLinkText,ikiLinkNameSep
syn region ikiNoLink start=+\\\[\[+ end=+\]\]+ 

syn match ikiLinkNameSep !|! contained nextgroup=ikiLinkText
syn match ikiLinkText !\(\w\|[ -/#.]\)\+! contained
syn match ikiLinkVName !\_[^\]|]\+\ze|! contained nextgroup=ikiLinkNameSep
" }}}1

" {{{1 ikiwiki directives

syn cluster ikiDirContents contains=ikiDirName
syn cluster ikiDirVal contains=ikiDirParamValSimple,ikiDirParamValQuoted,ikiDirParamVal3Q
syn region ikiDirDelim start=+\[\[\!+ end=+\]\]+ contains=@ikiDirContents fold

syn match ikiDirName !\w\+! contained nextgroup=ikiDirParamName skipwhite
syn match ikiDirParamName !\(\w\|[/:.-]\)\+! contained nextgroup=ikiDirAssign,ikiDirParamName skipwhite
syn match ikiDirAssign !=! contained nextgroup=@ikiDirVal skipwhite
syn match ikiDirParamValSimple ![^" \]]\+! contained nextgroup=ikiDirParamName skipwhite skipnl
syn region ikiDirParamValQuoted start=!"! skip=!\\"! end=!"! contained nextgroup=ikiDirParamName skipwhite skipnl
syn region ikiDirParamVal3Q start=!"""! end=!"""! contained nextgroup=ikiDirParamName skipwhite

" }}}1 ikiwiki directives

" {{{1 association to standard syntax groups
"{{{2 wikilinks
hi def link ikiLinkDelim Operator

hi def link ikiLinkText Underlined
hi def link ikiLinkNameSep Operator
hi def link ikiLinkVName Identifier

"{{{2 directives
hi def link ikiDirDelim PreProc
hi def link ikiDirName Type
hi def link ikiDirParamName Identifier
hi def link ikiDirAssign Operator
hi def link ikiDirParamValSimple Constant
hi def link ikiDirParamValQuoted Constant
hi def link ikiDirParamVal3Q Constant
" }}}1

syn sync minlines=50

let b:current_syntax = "ikiwiki"
unlet s:cpo_save

" vim:ts=8:sts=8:noet:fdm=marker
