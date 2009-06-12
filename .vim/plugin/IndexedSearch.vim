" File:         IndexedSearch.vim
" Author:       Yakov Lerner <iler.ml@gmail.com>
" URL:          http://www.vim.org/scripts/script.php?script_id=1682
" Last change:  2006-11-14
"
" This script redefines 6 search commands (/,?,n,N,*,#). At each search,
" it shows at which match number you are, and the total number 
" of matches, like this: "At Nth match out of M". This is printed
" at the bottom line at every n,N,/,?,*,# search command, automatically.
"
" To try out the plugin, source it and play with N,n,*,#,/,? commands.
" At the bottom line, you'll see wha it shows. There are no new 
" commands and no new behavior to learn. Just additional info
" on the bottom line, whenever you perform search.
"
" Requires vim7. Won't work for vim6. On very large files,
" won't cause slowdown because it checks file size first.
" Don't use if you're sensitive to one of its components :-)
"
" I am posting this plugin because I find it useful.
" -----------------------------------------------------
" Checking Where You Are with respect to Search Matches
" .....................................................
" You can press \\ or \/ (that's backslach then slash), 
" or :ShowSearchIndex to show at which match index you are,
" without moving cursor.
"
" If cursor is exactly on the match, the message is: 
"     At Nth match of M
" If cursor is between matches, following messages are displayed:
"     Betwen matches 189-190 of 300
"     Before first match, of 300
"     After last match, of 300
" ------------------------------------------------------
" To disable colors for messages, set 'let g:indexed_search_colors=0'.
" ------------------------------------------------------
" Performance. Plugin bypasses match counting when it would take
" too much time (too many matches, too large file). You can
" tune performance limits below, after comment "Performance tuning limits"
" ------------------------------------------------------
" In case of bugs and wishes, please email: iler.ml at gmail.com
" ------------------------------------------------------

if version < 700 | finish | endif " we need vim7 at least. Won't work for vim6
"if &cp | echo "warning: IndexedSearch.vim need nocp" | finish | endif " we need &nocp mode

if exists("g:indexed_search_plugin") | finish | endif
let g:indexed_search_plugin = 1

if !exists('g:indexed_search_colors')
    let g:indexed_search_colors=1 " 1-use colors for messages, 0-no colors
endif


" ------------------ "Performance tuning limits" -------------------
if !exists('g:search_index_max')
  let g:search_index_max=30000 " max filesize(in lines) up to what
                               " ShowCurrentSearchIndex() works
endif
if !exists("g:search_index_maxhit")
  let g:search_index_maxhit=1000
endif
" -------------- End of Performance tuning limits ------------------

let s:save_cpo = &cpo
set cpo&vim


command! ShowSearchIndex :call s:ShowCurrentSearchIndex(1,'')

"four short forms below did not work right -- see "**#n direction problem 061114"
"                                             explained below
"[removed 061114] nnoremap <silent>n :call <SID>ShowCurrentSearchIndex(0,'n')<cr>
"[removed 061114] nnoremap <silent>N :call <SID>ShowCurrentSearchIndex(0,'N')<cr>
"[removed 061114] nnoremap <silent>* :call <SID>ShowCurrentSearchIndex(0,'*')<cr>
"[removed 061114] nnoremap <silent># :call <SID>ShowCurrentSearchIndex(0,'#')<cr>
"before 061114 with short [nN*#] mappings (single call to the function) this sequence
"              did not work right: **#n (direction of the n was forw instead of backw).
"              Also, hls did not turn on correctly after startup.
"after 061114 fixed the **#n direction problem of n by moving "silent! norm! OP" to the
"             toplevel of the mapping. I'd like to check source of n for
"             explanation of by doing it in the function makes a difference

nnoremap <silent>n :let v:errmsg=''<cr>:silent! norm! n<cr>:call <SID>ShowCurrentSearchIndex(0,'')<cr>
nnoremap <silent>N :let v:errmsg=''<cr>:silent! norm! N<cr>:call <SID>ShowCurrentSearchIndex(0,'')<cr>
nnoremap <silent>* :let v:errmsg=''<cr>:silent! norm! *<cr>:call <SID>ShowCurrentSearchIndex(0 ,'')<cr>
nnoremap <silent># :let v:errmsg=''<cr>:silent! norm! #<cr>:call <SID>ShowCurrentSearchIndex(0,'')<cr>


nnoremap \/        :call <SID>ShowCurrentSearchIndex(1,'')<cr>
nnoremap \\        :call <SID>ShowCurrentSearchIndex(1,'')<cr>
nnoremap g/        :call <SID>ShowCurrentSearchIndex(1,'')<cr>


cnoremap <silent><enter> <c-r>=<SID>IndexedSearchCmodeEnter()<cr><cr>
"cnoremap <silent><expr><enter> (<SID>IndexedSearchCmodeEnter()?"\n":"\n")
function! s:IndexedSearchCmodeEnter()

    " before 061109, we had problem here with i<c-o>/pat<cr> and c/pat<cr> (Markus Braun)
    " after  061109, we fixed the problem by ScheduledEcho

    let v:errmsg = ""
    if line('$') >= g:search_index_max
        " if file is too large, ShowSearchIndex will not give any meaningful feedback
        return ""
    elseif getcmdtype() == '/'
        " this is Enter pressed after /(search)
        " 061109 fixed problem with i<c-o>/pat<cr>+feedkeys by switching to ScheduledEcho
        call s:DelaySearchIndex(0,'')
        redraw
    elseif getcmdtype() == '?'
        " this is Enter pressed after ?(search)
        " 061109 fixed problem with i<c-o>/pat<cr>+feedkeys by switching to ScheduledEcho
        call s:DelaySearchIndex(0,'')
        redraw
    endif
    return ""
endfunction


let s:ScheduledEcho = ''
let s:DelaySearchIndex = 0
let g:IndSearchUT = &ut
func! s:ScheduleEcho(msg,highlight)

    " Bill McCarthy brought idea of self-destructed autocmd into ScheduleEcho

    " if more than 1 script uses the &ut-reducing technique, then
    " two restorations of &ut can run in either sequence. we want to make sure
    " that in whatever sequence to &ut restorations run, &ut is restored properly.
    " this is tricky but possible.
    " The solution is, at restoration, aviod decreasing value of &ut.

    if &ut > 50 | let g:IndSearchUT=&ut | let &ut=50 | endif
        " before 061113 &ut was not always restored. This could happen if
        "               ScheduleEcho() is called twice in a row. 
        " i tried 'set ut' vs 'let &ut'

    let s:ScheduledEcho      = a:msg
    let s:ScheduledHighlight = a:highlight

    aug IndSearchEcho

    " before 061113 [*#] changed @/, mysteriously

    au CursorHold * 
      \ if s:last_patt != '' | let @/=s:last_patt | endif |
      \ exe 'set ut='.g:IndSearchUT | 
      \ if s:DelaySearchIndex | call s:ShowCurrentSearchIndex(0,'') | 
      \    let s:ScheduledEcho = s:Msg | let s:ScheduledHighlight = s:Highlight |
      \    let s:DelaySearchIndex = 0 | endif |
      \ if s:ScheduledEcho != "" 
      \ | exe "echohl ".s:ScheduledHighlight | echo s:ScheduledEcho | echohl None
      \ | let s:ScheduledEcho='' | 
      \ endif | 
      \ aug IndSearchEcho | exe 'au!' | aug END | aug! IndSearchEcho

    aug END
endfun " s:ScheduleEcho


func! s:DelaySearchIndex(force,cmd)
    let s:DelaySearchIndex = 1
    let s:last_patt = ''
    call s:ScheduleEcho('','')
endfunc


func! s:ShowCurrentSearchIndex(force, cmd)
    call s:CountCurrentSearchIndex(a:force, a:cmd) " -> s:Msg, s:Highlight

    " 061113 somehow, @/ get screwd up on '*' cmd, somewhere between synchronous part
    "        and async part. I fixed it it by keeping s:last_patt but I 'd need to
    "        track down what modifies the @/
    let s:last_patt = ''
    if a:cmd == '*' || a:cmd == '#' | let s:last_patt = @/ | endif

    if s:Msg != ""
        call s:ScheduleEcho(s:Msg, s:Highlight )
    endif
endfun


func! s:CountCurrentSearchIndex(force, cmd)
" sets globals -> s:Msg , s:Highlight
    let s:Msg = '' | let s:Highlight = ''
    let builtin_errmsg = ""

    echo "" | " make sure old msg is erased
    if a:cmd != ''
        let v:errmsg = ""

        silent! exe "norm! ".a:cmd

        if v:errmsg != ""
            echohl Error
            echomsg v:errmsg
            echohl None
        endif
        
        if line('$') >= g:search_index_max
            " for large files, preserve original error messages and add nothing
            return ""
        endif
    endif

    if !a:force && line('$') >= g:search_index_max
        let too_slow=1
        " when too_slow, we'll want to switch the work over to CursorHold
        return ""
    endif
    if @/ == '' | return "" | endif
    let save = winsaveview()
    let line = line('.')
    let col = col('.')
    norm gg0
    let num = 0    " total # of matches in the buffer
    let exact = -1
    let after = 0
    let too_slow = 0 " if too_slow, we'll want to switch the work over to CursorHold
    let s_opt = 'Wc'
    while search(@/, s_opt) && ( num <= g:search_index_maxhit  || a:force)
        let num = num + 1
        if line('.') == line && col('.') == col
            let exact = num
        elseif line('.') < line || (line('.') == line && col('.') < col)
            let after = num
        endif
        let s_opt = 'W'
    endwh
    call winrestview(save)
"    exe line
"    exe "norm! ".col."|"
"    call getchar(1)
    if !a:force && num > g:search_index_maxhit
        if exact >= 0 
            let too_slow=1 "  if too_slow, we'll want to switch the work over to CursorHold
            let num=">".(num-1)
        else
            let s:Msg = ">".(num-1)." matches"
            if v:errmsg != ""
                let s:Msg = ""  " avoid overwriting builtin errmsg with our ">1000 matches"
            endif
            return ""
        endif
    endif

    let s:Highlight = "Directory"
    if num == "0"
        let s:Highlight = "Error"
        let prefix = "No matches "
    elseif exact == 1 && num==1
        " s:Highlight remains default
        let prefix = "At single match"
    elseif exact == 1
        let s:Highlight = "Search"
        let prefix = "At 1st  match, # 1 of " . num
    elseif exact == num
        let s:Highlight = "DiffChange"
        let prefix = "At last match, # ".num." of " . num
    elseif exact >= 0
        let prefix = "At      match, # ".exact." of " . num
        let prefix = "At # ".exact." match of " . num
    elseif after == 0
        let s:Highlight = "MoreMsg"
        let prefix = "Before first match, of ".num." matches "
        if num == 1
            let prefix = "Before single match"
        endif
    elseif after == num
        let s:Highlight = "WarningMsg"
        let prefix = "After last match of ".num." matches "
        if num == 1
            let prefix = "After single match"
        endif
    else
        let prefix = "Between matches ".after."-".(after+1)." of ".num
    endif
    let s:Msg = prefix . "  /".@/ . "/"
    return ""
endfunc

let &cpo = s:save_cpo

" Last changes
" 2006-10-20 added limitation by # of matches
" 061021 lerner fixed problem with cmap <enter> that screwed maps 
" 061021 colors added
" 061022 fixed g/ when too many matches
" 061106 got message to work with check for largefile right
" 061110 addition of DelayedEcho(ScheduledEcho) fixes and simplifies things
" 061110 mapping for nN*# greately simplifified by switching to ScheduledEcho
" 061110 fixed problem with i<c-o>/pat<cr> and c/PATTERN<CR> Markus Braun
" 061110 fixed bug in / and ?, Counting moved to Delayd
" 061110 fixed bug extra line+enter prompt in [/?] by addinf redraw
" 061110 fixed overwriting builtin errmsg with ">1000 matches"
" 061111 fixed bug with gg & 'set nosol' (gg->gg0)
" 061113 fixed mysterious eschewing of @/ wfte *,#
" 061113 fixed counting of match at the very beginning of file
" 061113 added msgs "Before single match", "After single match"
" 061113 fixed bug with &ut not always restored. This could happen if
"        ScheduleEcho() was called twice in a row.
" 061114 fixed problem with **#n. Direction of the last n is incorrect (must be backward
"              but was incorrectly forward)

" Wishlist
" -  using high-precision timer of vim7, count number of millisec
"    to run the counters, and base auto-disabling on time it takes.
"    very complex regexes can be terribly slow even of files like 'man bash'
"    which is mere 5k lines long. Also when there are >10k matches in the file
"    set limit to 200 millisec
" - implement CursorHold bg counting to which too_slow will resort
" - cuont correctly match which is at very 1st byte of the file

" bug 012 pattern is /./(>1000) and we press ?<cr> at bof or /<cr>, we don't see
"         the native errmsg. How it is erased ? It shall remains visible.
