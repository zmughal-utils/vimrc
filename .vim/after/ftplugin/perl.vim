" Vim filetype plugin file
" Language:	Perl

call programming#Programming()
"call programming#CurlyBraces()
let perl_fold = 1
let perl_fold_blocks = 1
let perl_fold_anonymous_subs = 1
setlocal foldmethod=syntax

" From <http://stackoverflow.com/questions/2182164/is-there-a-vim-plugin-that-makes-moose-attributes-show-up-in-tag-list>
" and <http://stackoverflow.com/questions/979359/vim-and-custom-tagging/980051#980051>
let tlist_perl_settings='perl;u:use;p:package;r:role;e:extends;c:constant;a:attribute;s:subroutine;l:label;m:method;q:requires;o:POD'

function! PerlGetBasePath()
    let tmpname = expand( '%:p' )
    if (match(tmpname, '.pm$') != -1)
        let basepath = substitute(tmpname, '\/lib\/.\+', '', '' )
        return basepath
    endif
    if (match(tmpname, '.t$') != -1)
        let basepath = substitute(tmpname, '\/t\/.\+', '', '' )
        return basepath
    endif
    return ''
endfunction

let b:libdir = PerlGetBasePath() . "/lib"
let $PERL5LIB = $PERL5LIB . ":" . b:libdir
exe "set path+=" . b:libdir

compiler perl
let &l:makeprg = substitute(&l:makeprg, "\\s*%","","")

function! PerlRun()
	:if match(expand('%:p'), '\.t$') != -1
		!prove -lv "%:p"
	else
		!"%:p"
	endif
endfunction

nmap <buffer> <F6> :call PerlRun()<CR>
imap <buffer> <F6> <Esc><F6>

setlocal iskeyword+=:

" syntastic setting
let g:syntastic_perl_checkers = [ "perl", "perlcritic", "podchecker" ]
let g:syntastic_enable_perl_checker = 1 " security (maybe this should be disabled for any Perl outside certain directories)
let g:syntastic_perl_lib_path = [ './lib', './lib/auto' ]

" manpageview setting
let g:manpageview_options_pl= ";-f;-q"

" babycart operator (complex interpolation)
let b:surround_{char2nr("i")} = "@{[ \r ]}"

iabbr xrepl require Carp::REPL; Carp::REPL->import('repl'); repl();#DEBUG
