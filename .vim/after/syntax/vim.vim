" Vim syntax file
" Language:	Vim

" TODO breaks in silly cases [ironically this file as well]
"syntax case match
" Check if a cmdwin
if &buftype!="nofile"
	syntax region vimfunctionFold start="\C\<fu\%[nction]\>"
				\ end="\C\<endf\%[unction]\>"
				\ transparent fold keepend extend
	syntax region vimifFold start="\C\<if\>"
				\ end="\C\<en\%[dif]\>"
				\ transparent fold keepend extend
	syntax region vimwhileFold start="\C\<wh\%[ile]\>"
				\ end="\C\<endw\%[hile]\>"
				\ transparent fold keepend extend
	syntax region vimfunctionFold start="\C\<for\>"
				\ end="\C\<endfo\%[r]\>"
				\ transparent fold keepend extend

	syntax region vimcommentFold start=+\(^\s*".*\n\)\@<!\zs\(\_^\s*".*\)+
				\ end=+\ze\_^\(\s*".*\n\)\@!.*$+
				\ transparent fold
endif
