if exists("current_compiler")
  finish
endif
let current_compiler = "prove"

if exists(":CompilerSet") != 2
	" older Vim always used :setlocal
	command -nargs=* CompilerSet setlocal <args>
endif

let s:savecpo = &cpo
set cpo&vim

" Usage: :make - prove the current testfile
"        :make t - run prove and give arguments to prove ('t' in this case)
" prove is called with '-l -v'
" The /dev/stdout trick is to make sure vim only gets prove's STDERR
CompilerSet makeprg=prove\ -l\ -v\ \`if\ test\ -n\ \"$*\"\;\ then\ echo\ \"$*\"\;\ else\ echo\ \"%\"\;\ fi\`\ 2>/dev/stdout\ 1>/dev/null\\\|cat

"CompilerSet errorformat=
	"\%m\ at\ %f\ line\ %l.,
	"\%I#\ Looks\ like\ you\ %m%.%#,
	"\%Z\ %#,
	"\%I#\ \ \ \ \ Failed\ test\ (%f\ at\ line\ %l),
	"\%+Z#\ \ \ \ \ Tried\ to\ use%m,
	"\%E#\ \ \ \ \ Failed\ test\ (%f\ at\ line\ %l),
	"\%C#\ \ \ \ \ %m,
	"\%Z#\ %#%m,
	"\#\ %#Failed\ test\ (%f\ at\ line\ %l),
	"\%-G%.%#had\ compilation\ errors.,
	"\%-G%.%#syntax\ OK,
	"\%+A%.%#\ at\ %f\ line\ %l\\,%.%#,
	"\%+Z%.%#
" Explanation:
" 1  : General perl error
" 2-3: informational, number of failures
" 4-5: use_ok error. The error itself will come later (meta: how can we make vim ignore this muliline error?)
" 6-8: Failed test, has 2 info lines
" 9  : Failed test, single line, no info
" 10-11: noise
" 12-13: error with a 'near' (multiline)
" (Perl syntax errors copied from the vim perl compiler package)

"TAP errors
CompilerSet efm=%+I#\ Looks\ like\ you\ %m.
CompilerSet efm+=%+E\ %##\ %#Failed\ test\ '%m'
CompilerSet efm+=%Z\ %##\ %#at\ %f\ line\ %l.
CompilerSet efm+=%Z\ %##\ %#in\ %f\ at\ line\ %l.

"Perl syntax errors, etc, from perl compiler package
CompilerSet efm+=%-G%.%#had\ compilation\ errors.
CompilerSet efm+=%-G%.%#syntax\ OK
CompilerSet efm+=%m\ at\ %f\ line\ %l.
CompilerSet efm+=%+A%.%#\ at\ %f\ line\ %l\\,%.%#
CompilerSet efm+=%+C%.%#

let &cpo = s:savecpo
unlet s:savecpo
