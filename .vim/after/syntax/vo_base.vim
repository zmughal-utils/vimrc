" Using syntax/vo_base.vim patch from
" <http://billpowellisalive.com/blog/vimoutliner-and-a-tweak-to-use-colorschemes>
" <http://billpowellisalive.com/pub/linux/vim/vo_base.txt>
"
" added ! to all highlight group so that the colors in the base install are
" overridden
"Colors linked {{{1

	hi! link OL1 Statement 
	hi! link OL2 Identifier
	hi! link OL3 Constant
	hi! link OL4 PreProc   
	hi! link OL5 Statement 
	hi! link OL6 Identifier
	hi! link OL7 Constant
	hi! link OL8 PreProc   
	hi! link OL9 Statement

	"colors for tags
	"hi! link outlTags Tag
	hi! link outlTags Todo

	"color for body text
	hi! link BT1 Comment
	hi! link BT2 Comment
	hi! link BT3 Comment
	hi! link BT4 Comment
	hi! link BT5 Comment
	hi! link BT6 Comment
	hi! link BT7 Comment
	hi! link BT8 Comment
	hi! link BT9 Comment

	"color for pre-formatted text
	hi! link PT1 Special
	hi! link PT2 Special
	hi! link PT3 Special
	hi! link PT4 Special
	hi! link PT5 Special
	hi! link PT6 Special
	hi! link PT7 Special
	hi! link PT8 Special
	hi! link PT9 Special

	"color for tables 
	hi! link TA1 Type
	hi! link TA2 Type
	hi! link TA3 Type
	hi! link TA4 Type
	hi! link TA5 Type
	hi! link TA6 Type
	hi! link TA7 Type
	hi! link TA8 Type
	hi! link TA9 Type

	"color for user text (wrapping)
	hi! link UT1 Debug
	hi! link UT2 Debug
	hi! link UT3 Debug
	hi! link UT4 Debug
	hi! link UT5 Debug
	hi! link UT6 Debug
	hi! link UT7 Debug
	hi! link UT8 Debug
	hi! link UT9 Debug

	"color for user text (non-wrapping)
	hi! link UB1 Underlined
	hi! link UB2 Underlined
	hi! link UB3 Underlined
	hi! link UB4 Underlined
	hi! link UB5 Underlined
	hi! link UB6 Underlined
	hi! link UB7 Underlined
	hi! link UB8 Underlined
	hi! link UB9 Underlined

	"colors for folded sections
	"hi! link Folded Special
	"hi! link FoldColumn Type

	"colors for experimental spelling error highlighting
	"this only works for spellfix.vim with will be cease to exist soon
	hi! link spellErr Error
	hi! link BadWord Todo

" vim600: set foldmethod=marker foldlevel=0:
