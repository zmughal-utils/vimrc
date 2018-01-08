" see http://blogs.perl.org/users/ovid/2013/03/discoverable-tests-and-creating-testing-standards.html

function! perltest#GetTestFile()
    let b:tmpname = expand( '%:p' )
    if (match(b:tmpname, '.t$') != -1)
	    return b:tmpname
    end

    return perltest#GetCorresponding()
endfunction

function! perltest#GetCorresponding()
    let b:tmpname = expand( '%:p' )
    if (match(b:tmpname, '.pm$') != -1)
        let b:testfile = substitute(substitute(b:tmpname, '.\+\/lib\/', '', ''), '.pm$', '.t', '' )
        let b:basepath = substitute(b:tmpname, '\/lib\/.\+', '', '' )
        return b:basepath . '/t/' . b:testfile
    endif
    if (match(b:tmpname, '.t$') != -1)
        let b:module = substitute(substitute(b:tmpname, '.\+\/t\/', '', ''), '.t$', '.pm', '' )
        let b:basepath = substitute(b:tmpname, '\/t\/.\+', '', '' )
        return b:basepath . '/lib/' . b:module
    endif
    return ''
endfunction

function! perltest#GotoCorresponding()
    let file = perltest#GetCorresponding()
    let module = expand( '%:p' )
    let directory = fnamemodify(expand(file), ":p:h")
    if !isdirectory( directory )
	    call mkdir(directory, "p")
    end
    if !empty(file)
        let ignore = system("perl $HOME/.vim/scripts/perl_make_test_stub ".module." ".file)
	
        execute "edit " . file
    else
        echoerr("Cannot find corresponding file for: ".module)
    endif
endfunction
