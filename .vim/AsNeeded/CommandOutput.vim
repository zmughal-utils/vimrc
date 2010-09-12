"   Copyright (c) 2007, Michael Shvarts <shvarts@akmosoft.com>
function! CommandOutput(cmd,...)
    redir => output
    silent exec a:cmd.' '.join(a:000,' ')
    redir END
    return output

endf
function! s:CommandOutputToBuffer(cmd,...)
    let output = call('CommandOutput',[a:cmd] + a:000)
    if a:cmd =~ '^syn'
        let hi = CommandOutput('hi')
    elseif a:cmd =~ '^hi'
        let hi = output
    endif
    exec 'new '.a:cmd
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    let clip = @"
    let @" = output
    normal Pgg
    if getline(1) =~ '^\s*$'
        normal dd
    endif
    let @"=clip
    if exists('hi')
        let b:hi = hi
    endif
    let b:cmd = a:cmd
    let b:args = copy(a:000)
    let b:[0] = a:0
    let &ft=a:cmd.'_cmd'
endf
function! ParseHi(hi)
    return filter(map(split(a:hi,'\n'), 'matchlist(v:val, ''\(^\w\+\)\s\+xxx\s\+\(cleared\)\?\(links to \)\?\(.*\)'')'), 'len(v:val) && v:val[2] == ""') 
endf
function! ApplyHi(hi)
    let hi = ParseHi(a:hi)
    execute join(map(copy(hi), '"hi ".(v:val[3] !=""?"link ":"").v:val[1]." ".v:val[4]'),"\n")
    execute join(map(copy(hi), "'syn match '.v:val[1].' contained ''\\<xxx\\>'' |  syn region '.v:val[1].'_region start=''^'.v:val[1].'\\s\\+'' end=''\\<xxx\\>'' contains='.v:val[1].' keepend'"),"\n")
endf
command! -nargs=* -complete=command     CommandOutput call s:CommandOutputToBuffer(<f-args>)
command! -nargs=* -complete=highlight   Syntax      CommandOutput syntax <args>
command! -nargs=* -complete=highlight   Highlight   CommandOutput hi <args>
command! -nargs=* -complete=menu        Menu        CommandOutput menu <args>
command! -nargs=* -complete=function    Function    CommandOutput function <args>
command! -nargs=* -complete=command     Command     CommandOutput command <args>
command!                                Changes     CommandOutput changes <args>
command!                                Messages    CommandOutput messages <args>
