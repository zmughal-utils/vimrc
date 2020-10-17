" Vim syntax file
" Language:	Changelog

" RFC 3339
syntax match changelogDate "\%(\d\+\)-\%(0[1-9]\|1[012]\)-\%(0[1-9]\|[12]\d\|3[01]\)\s\%([01]\d\|2[0-3]\):\%([0-5]\d\):\%([0-5]\d\|60\)\%(\.\d\+\)\?\%(\%([Zz]\)\|\%([+-]\%([01]\d\|2[0-3]\)00\)\)" containedin=ALL extend

highlight link changelogDate Special
