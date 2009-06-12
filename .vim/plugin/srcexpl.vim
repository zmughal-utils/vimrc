
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                                              "
" File_Name__: srcexpl.vim                                                     "
" Abstract___: A (G)VIM plugin for exploring the source code based on 'tags'   "
"              and 'quickfix'. It works like the context window in the         "
"              Source Insight.                                                 "
" Author_____: CHE Wenlong <chewenlong AT buaa.edu.cn>                         "
" Version____: 3.6                                                             "
" Last_Change: December 28, 2008                                               "
"                                                                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NOTE: The graph below shows my work platform with some VIM plugins,          "
"       including 'Source Explorer', 'Taglist' and 'NERD tree'. And I usually  "
"       use the 'Trinity' plugin (trinity.vim) to manage all of them.          "
"                                                                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" +----------------------------------------------------------------------------+
" | File | Edit | Tools | Syntax | Buffers | Window | Help |                   |
" +----------------------------------------------------------------------------+
" |-demo.c-------- |-----------------------------------------|-/home/myprj/----|
" |function        | 1 void foo(void)     /* function 1 */   ||~ src/          |
" |  foo           | 2 {                                     || `-demo.c       |
" |  bar           | 3 }                                     |`-tags           |
" |                | 4 void bar(void)     /* function 2 */   |                 |
" |~ +----------+  | 5 {                                     |~ +-----------+  |
" |~ | Tag List |\ | 6 }                                     |~ | NERD Tree |\ |
" |~ +__________+ ||~        +-----------------+             |~ +___________+ ||
" |~ \___________\||~        | The Main Editor |\            |~ \____________\||
" |~               |~        +_________________+ |           |~                |
" |~               |~        \__________________\|           |~                |
" |~               |~                                        |~                |
" |-__Tag_List__---|-demo.c----------------------------------|-_NERD_tree_-----|
" |Source Explorer V3.6                                                        |
" |~                              +-----------------+                          |
" |~                              | Source Explorer |\                         |
" |~                              +_________________+ |                        |
" |~                              \__________________\|                        |
" |-Source_Explorer[Preview]---------------------------------------------------|
" |:TrinityToggleAll                                                           |
" +----------------------------------------------------------------------------+

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                                              "
" The_setting_example_in_my_vimrc_file:-)                                      "
"                                                                              "
" // The switch of the Source Explorer                                         "
" nmap <F8> :SrcExplToggle<CR>
"                                                                              "
" // Set the height of Source Explorer window                                  "
" let g:SrcExpl_winHeight = 8
"                                                                              "
" // Set 100 ms for refreshing the Source Explorer                             "
" let g:SrcExpl_refreshTime = 100
"                                                                              "
" // Set "Enter" key to jump into the exact definition context                 "
" let g:SrcExpl_jumpKey = "<ENTER>"
"                                                                              "
" // Set "Space" key for back from the definition context                      "
" let g:SrcExpl_goBackKey = "<SPACE>"
"                                                                              "
" // In order to Avoid conflicts, the Source Explorer should know what plugins "
" // are using buffers. And you need add their bufname into the list below     "
" // according to the command ":buffers!"                                      "
" let g:SrcExpl_pluginList = [
"         \ "__Tag_List__",
"         \ "_NERD_tree_",
"         \ "Source_Explorer"
"     \ ]
"                                                                              "
" // Enable or disable local definition searching, and note that this is not   "
" // guaranteed to work, the Source Explorer doesn't check the syntax for now. "
" // It only searches for a match with the keyword according to command 'gd'   "
" let g:SrcExpl_searchLocalDef = 1
"                                                                              "
" // Let the Source Explorer update the tags file when opening                 "
" let g:SrcExpl_isUpdateTags = 1
"                                                                              "
" // Use program 'ctags' with argument '-R *' to create or update a tags file  "
" let g:SrcExpl_updateTagsCmd = "ctags -R *"
"                                                                              "
" Just_change_above_of_them_by_yourself:-)                                     "
"                                                                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Avoid reloading {{{

if exists('loaded_srcexpl')
    finish
endif

let loaded_srcexpl = 1
let s:save_cpo = &cpoptions

" }}}

" VIM version control {{{

" The VIM version control for running the Source Explorer

if v:version < 700
    echohl ErrorMsg
        echo "SrcExpl: Require VIM 7.0 or above for running the Source Explorer."
    echohl None
    finish
endif

set cpoptions&vim

" }}}

" User interfaces {{{

" User interface for opening the Source Explorer

command! -nargs=0 -bar SrcExpl 
    \ call <SID>SrcExpl()

" User interface for closing the Source Explorer

command! -nargs=0 -bar SrcExplClose 
    \ call <SID>SrcExpl_Close()

" User interface for switching the Source Explorer

command! -nargs=0 -bar SrcExplToggle 
    \ call <SID>SrcExpl_Toggle()

" User interface for changing the height of 
" Source Explorer Window
if !exists('g:SrcExpl_winHeight')
    let g:SrcExpl_winHeight = 8
endif

" User interface for setting the update time interval 
" of each refreshing
if !exists('g:SrcExpl_refreshTime')
    let g:SrcExpl_refreshTime = 100
endif

" User interface to jump into the exact definition context
if !exists('g:SrcExpl_jumpKey')
    let g:SrcExpl_jumpKey = '<CR>'
endif

" User interface to go back from the definition context
if !exists('g:SrcExpl_goBackKey')
    let g:SrcExpl_goBackKey = '<SPACE>'
endif

" User interface for handling the conflicts between the 
" Source Explorer and other plugins
if !exists('g:SrcExpl_pluginList')
    let g:SrcExpl_pluginList = [
            \ "__Tag_List__", 
            \ "_NERD_tree_", 
            \ "Source_Explorer"
        \ ]
endif

" User interface to enable local declaration searching 
" according to command 'gd'
if !exists('g:SrcExpl_searchLocalDef')
    let g:SrcExpl_searchLocalDef = 1
endif

" User interface to control if update the 'tags' file when loading 
" the Source Explorer, 0 for false, others for true
if !exists('g:SrcExpl_isUpdateTags')
    let g:SrcExpl_isUpdateTags = 1
endif

" User interface to create a 'tags' file using exact ctags
" utility, 'ctags -R *' as default
if !exists('g:SrcExpl_updateTagsCmd')
    let g:SrcExpl_updateTagsCmd = 'ctags -R *'
endif

" }}}

" Global variables {{{

" Mark list for tagging the flow when exploring the project
let s:SrcExpl_markList  = [
        \ "A", "B", "C", "D", "E", 
        \ "F", "G", "H", "I", "J", 
        \ "K", "L", "M", "N", "O", 
        \ "P", "Q", "R", "S", "T", 
        \ "U", "V", "W", "X", "Y", "Z"
    \ ]

" Buffer title for identifying myself among all the plugins
let s:SrcExpl_title     =   'Source_Explorer'

" The log file path for debugging the error
let s:SrcExpl_logPath   =   './srcexpl.log'

" Debug switch for logging the debug information
let s:SrcExpl_debug     =   0

" Plugin switch flag
let s:SrcExpl_opened    =   0

" }}}

" SrcExpl_Debug() {{{

" Record the supplied debug information log along with the time

function! <SID>SrcExpl_Debug(log)

    " Debug switch is on
    if s:SrcExpl_debug == 1
        " Log file path is valid
        if s:SrcExpl_logPath != ''
            " Output to the log file
            echo s:SrcExpl_logPath
            exe "redir >> " . s:SrcExpl_logPath
            " Add the current time
            silent echon strftime("%H:%M:%S") . ": " . a:log . "\n"
            redir END
        endif
    endif

endfunction " }}}

" SrcExpl_OutErrMsg() {{{

" Output the message when we get a error situation

function! <SID>SrcExpl_OutErrMsg(err)

    echohl ErrorMsg
        echo "SrcExpl: " . a:err
    echohl None

endfunction " }}}

" SrcExpl_EnterWin() {{{

" Operation when WinEnter Event happens

function! <SID>SrcExpl_EnterWin()

    " In the Source Explorer window
    if &previewwindow
        if has("gui_running")
            " Delete the SrcExplGoBack item in Popup menu
            silent! nunmenu 1.01 PopUp.&SrcExplGoBack
        endif
        " Unmap the go back key
        if maparg(g:SrcExpl_goBackKey, 'n') == 
            \ ":call g:SrcExpl_GoBack()<CR>"
            exe "nunmap " . g:SrcExpl_goBackKey
        endif
        " Do the mapping for 'double-click'
        if maparg('<2-LeftMouse>', 'n') == ''
            nnoremap <silent> <2-LeftMouse> 
                \ :call g:SrcExpl_Jump()<CR>
        endif
        " Map the user's key to jump into the exact definition context
        if g:SrcExpl_jumpKey != ""
            exe "nnoremap " . g:SrcExpl_jumpKey . 
                \ " :call g:SrcExpl_Jump()<CR>"
        endif
    " In other plugin windows
    elseif <SID>SrcExpl_AdaptPlugins()
        if has("gui_running")
            " Delete the SrcExplGoBack item in Popup menu
            silent! nunmenu 1.01 PopUp.&SrcExplGoBack
        endif
        " Unmap the go back key
        if maparg(g:SrcExpl_goBackKey, 'n') == 
            \ ":call g:SrcExpl_GoBack()<CR>"
            exe "nunmap " . g:SrcExpl_goBackKey
        endif
        " Unmap the exact mapping of 'double-click'
        if maparg("<2-LeftMouse>", "n") == 
                \ ":call g:SrcExpl_Jump()<CR>"
            nunmap <silent> <2-LeftMouse>
        endif
        " Unmap the jump key
        if maparg(g:SrcExpl_jumpKey, 'n') == 
            \ ":call g:SrcExpl_Jump()<CR>"
            exe "nunmap " . g:SrcExpl_jumpKey
        endif
    " In the edit window
    else
        if has("gui_running")
            " You can use SrcExplGoBack item in Popup menu
            " to go back from the definition
            silent! nnoremenu 1.01 PopUp.&SrcExplGoBack 
                \ :call g:SrcExpl_GoBack()<CR>
        endif
        " Map the user's key to go back from the 
        " definition context.
        if g:SrcExpl_goBackKey != ""
            exe "nnoremap " . g:SrcExpl_goBackKey . 
                \ " :call g:SrcExpl_GoBack()<CR>"
        endif
        " Unmap the exact mapping of 'double-click'
        if maparg("<2-LeftMouse>", "n") == 
                \ ":call g:SrcExpl_Jump()<CR>"
            nunmap <silent> <2-LeftMouse>
        endif
        " Unmap the jump key
        if maparg(g:SrcExpl_jumpKey, 'n') == 
            \ ":call g:SrcExpl_Jump()<CR>"
            exe "nunmap " . g:SrcExpl_jumpKey
        endif
    endif

endfunction " }}}

" SrcExpl_SetCurr() {{{

" Save the current buf-win file path, line number and column number

function! <SID>SrcExpl_SetCurr()

    " Get the whole file path of the buffer before tag
    let s:SrcExpl_currPath = expand("%:p")
    " Get the current line before tag
    let s:SrcExpl_currLine = line(".")
    " Get the current column before tag
    let s:SrcExpl_currCol = col(".")

endfunction " }}}

" SrcExpl_SetMark() {{{

" Set the mark for back to the previous position

function! <SID>SrcExpl_SetMark()

    " Get the line number of previous mark
    let l:line = line("'" . s:SrcExpl_markList[s:SrcExpl_markIndex])
    " Get the column number of previous mark
    let l:col = col("'" . s:SrcExpl_markList[s:SrcExpl_markIndex])

    " Avoid the same situation
    if l:line == line(".") && l:col == col(".")
        return -1
    endif

    " Update new mark position index
    let s:SrcExpl_markIndex += 1
    " Out of the list range
    if s:SrcExpl_markIndex == len(s:SrcExpl_markList)
        let s:SrcExpl_markIndex = 0
    endif
    " Record the next mark position
    exe "normal " . "m" . s:SrcExpl_markList[s:SrcExpl_markIndex]

    " Successfully
    return 0

endfunction " }}}

" SrcExpl_GetMark() {{{

" Get the mark for back to the previous position

function! <SID>SrcExpl_GetMark()

    if s:SrcExpl_markIndex == -1
        " Tell the user what has happened
        call <SID>SrcExpl_OutErrMsg("Mark stack is empty")
        return -1
    endif

    " Delete the current mark
    exe "delmarks " . s:SrcExpl_markList[s:SrcExpl_markIndex]
    " Back to the previous position index
    let s:SrcExpl_markIndex -= 1
    " Back to the top of the mark stack
    if s:SrcExpl_markIndex == -1
        " Reinitialize the index
        let s:SrcExpl_markIndex = len(s:SrcExpl_markList) - 1
    endif
    try
        " Back to the previous position immediately
        exe "normal " . "`" . s:SrcExpl_markList[s:SrcExpl_markIndex]
    catch
        " There is no mark on the previous cursor
        let s:SrcExpl_markIndex = -1
        " Tell the user what has happened
        call <SID>SrcExpl_OutErrMsg("Mark stack is empty")
        return -2
    endtry

    " Successfully
    return 0

endfunction " }}}

" SrcExpl_GoBack() {{{

" Move the cursor to the previous location in the mark history

function! g:SrcExpl_GoBack()

    " If or not the cursor is on the edit window
    if &previewwindow || <SID>SrcExpl_AdaptPlugins()
        return -1
    endif

    " Jump back to the previous position
    call <SID>SrcExpl_GetMark()

    " Successfully
    return 0

endfunction " }}}

" SrcExpl_SelToJump() {{{

" Select one of multi-definitions, and jump to there

function! <SID>SrcExpl_SelToJump()

    let l:index = 0
    let l:fname = ""
    let l:excmd = ""
    let l:expr  = ""

    " Must in the Source Explorer window
    if !&previewwindow
        silent! wincmd P
    endif

    " Get the item data that user selected
    let l:list = getline(".")
    " Traverse the prompt string until get the 
    " file path
    while !((l:list[l:index] == ']') && 
        \ (l:list[l:index + 1] == ':'))
        let l:index += 1
    endwhile
    " Done
    let l:index += 3
    " Get the whole file path of the exact definition
    while !((l:list[l:index] == ' ') && 
        \ (l:list[l:index + 1] == '['))
        let l:fname = l:fname . l:list[l:index]
        let l:index += 1
    endwhile
    " Done
    let l:index += 2
    " Traverse the prompt string until get the symbol
    while !((l:list[l:index] == ']') && 
        \ (l:list[l:index + 1] == ':'))
        let l:index += 1
    endwhile
    " Done
    let l:index += 3
    " Get the EX command string
    while l:list[l:index] != ''
        let l:excmd = l:excmd . l:list[l:index]
        let l:index += 1
    endwhile

    " Indeed go back to the edit window
    silent! exe s:SrcExpl_editWin . "wincmd w"
    " Open the file of definition context
    exe "edit " . s:SrcExpl_tagsPath . l:fname
 
    " Modify the EX Command to locate the tag exactly
    let l:expr = substitute(l:excmd, '/^', '/^\\C', 'g')
    let l:expr = substitute(l:expr,  '\*',  '\\\*', 'g')
    let l:expr = substitute(l:expr,  '\[',  '\\\[', 'g')
    let l:expr = substitute(l:expr,  '\]',  '\\\]', 'g')
    " Use EX Command to Jump to the exact position of the definition
    silent! exe l:expr

    " Match the symbol
    call <SID>SrcExpl_MatchExpr()

endfunction " }}}

" SrcExpl_Jump() {{{

" Jump to the edit window and point to the definition

function! g:SrcExpl_Jump()

    " Only do the operation on the Source Explorer 
    " window is valid
    if !&previewwindow
        return -1
    endif

    " Do we get the definition already?
    if bufname("%") == s:SrcExpl_title
        " No such definition
        if s:SrcExpl_status == 0
            return -2
        " Multiple definitions
        elseif s:SrcExpl_status == 2
            " If point to the jump list head, just avoid that
            if line(".") == 1
                return -3
            endif
        endif
    endif

    if g:SrcExpl_searchLocalDef != 0
        " We have already jumped to the edit window
        let s:SrcExpl_jumped = 1
    endif
    " Indeed go back to the edit window
    silent! exe s:SrcExpl_editWin . "wincmd w"
    " Set the mark for recording the current position
    call <SID>SrcExpl_SetMark()

    " We got multiple definitions
    if s:SrcExpl_status == 2
        " Select the exact one and jump to its context
        call <SID>SrcExpl_SelToJump()
        " Set the mark for recording the current position
        call <SID>SrcExpl_SetMark()
        return 0
    endif

    " Open the buffer using edit window
    exe "edit " . s:SrcExpl_currPath
    " Jump to the context line of that symbol
    call cursor(s:SrcExpl_currLine, s:SrcExpl_currCol)
    " Match the Symbol of definition
    call <SID>SrcExpl_MatchExpr()
    " Set the mark for recording the current position
    call <SID>SrcExpl_SetMark()

    " We got one local definition
    if s:SrcExpl_status == 3
        " Get the cursor line number
        let s:SrcExpl_csrLine = line(".")
        " Try to tag the symbol again
        let l:expr = '\C\<' . s:SrcExpl_symbol . '\>'
        call <SID>SrcExpl_TryToTag(l:expr)
        redraw
        silent! exe s:SrcExpl_editWin . "wincmd w"
    endif

    " Successfully
    return 0

endfunction " }}}

" SrcExpl_MatchExpr() {{{

" Match the Symbol of definition

function! <SID>SrcExpl_MatchExpr()

    " Match the symbol
    call search("$", "b")
    let s:SrcExpl_symbol = substitute(s:SrcExpl_symbol, 
        \ '\\', '\\\\', '')
    call search('\V\C\<' . s:SrcExpl_symbol . '\>')

endfunction " }}}

" SrcExpl_HltExpr() {{{

" Highlight the Symbol of definition

function! <SID>SrcExpl_HltExpr()

    " Set the highlight color
    hi SrcExpl_HighLight term=bold guifg=Black guibg=Magenta ctermfg=Black ctermbg=Magenta
    " Highlight
    exe 'match SrcExpl_HighLight "\%' . line(".") . 'l\%' . 
        \ col(".") . 'c\k*"'

endfunction " }}}

" SrcExpl_TryToGoDecl() {{{

" Search the local declaration

function! <SID>SrcExpl_TryToGoDecl(expr)

    " Get the original cursor position
    let l:oldline = line(".")
    let l:oldcol = col(".")

    " Try to search the local declaration
    if searchdecl(a:expr, 0, 1) != 0
        " Search failed
        return -1
    endif

    " Get the new cursor position
    let l:newline = line(".")
    let l:newcol = col(".")
    " Go back to the original cursor position
    call cursor(l:oldline, l:oldcol)

    " Preview the context
    exe "silent " . "pedit " . expand("%:p")
    " Go to the Preview window
    silent! wincmd P
    " Indeed in the Preview window
    if &previewwindow
        " Go to the new cursor position
        call cursor(l:newline, l:newcol)
        " Match the symbol
        call <SID>SrcExpl_MatchExpr()
        " Highlight the symbol
        call <SID>SrcExpl_HltExpr()
        " Set the current buf-win property
        call <SID>SrcExpl_SetCurr()
    endif

    " Search successfully
    return 0

endfunction " }}}

" SrcExpl_NoteNoDef() {{{

" The User Interface function to open the Source Explorer

function! <SID>SrcExpl_NoteNoDef()

    " Do the Source Explorer existed already?
    let l:bufnum = bufnr(s:SrcExpl_title)
    " Not existed, create a new buffer
    if l:bufnum == -1
        " Create a new buffer
        let l:wcmd = s:SrcExpl_title
    else
        " Edit the existing buffer
        let l:wcmd = '+buffer' . l:bufnum
    endif

    " Reopen the Source Explorer idle window
    exe "silent " . "pedit " . l:wcmd
    " Move to it
    silent! wincmd P
    " Done
    if &previewwindow
        " First make it modifiable
        setlocal modifiable
        " Not show its name on the buffer list
        setlocal nobuflisted
        " No exact file
        setlocal buftype=nofile
        " Report the reason why the Source Explorer
        " can not point to the definition
        " Delete all lines in buffer.
        1,$d _
        " Goto the end of the buffer put the buffer list
        $
        " Display the version of the Source Explorer
        put! ='Definition Not Found'
        " Cancel all the highlighted words
        match none
        " Delete the extra trailing blank line
        $ d _
        " Make it unmodifiable again
        setlocal nomodifiable
    endif

    " Successfully
    return 0

endfunction " }}}

" SrcExpl_ListMultiDefs() {{{

" List Multiple definitions into the preview window

function! <SID>SrcExpl_ListMultiDefs(list, len)

    "The Source Explorer existed already?
    let l:bufnum = bufnr(s:SrcExpl_title)
    " Not existed, create a new buffer
    if l:bufnum == -1
        " Create a new buffer
        let l:wcmd = s:SrcExpl_title
    else
        " Edit the existing buffer
        let l:wcmd = '+buffer' . l:bufnum
    endif

    " Reopen the Source Explorer idle window
    exe "silent " . "pedit " . l:wcmd
    " Return to the preview window
    silent! wincmd P
    " Done
    if &previewwindow
        " Reset the property of the Source Explorer
        setlocal modifiable
        " Not show its name on the buffer list
        setlocal nobuflisted
        " No exact file
        setlocal buftype=nofile
        " Delete all lines in buffer
        1,$d _
        " Get the tags dictionary array
        " Begin build the Jump List for exploring the tags
        put! = '[Jump List]: '. s:SrcExpl_symbol . ' (' . a:len . ') '
        " Match the symbol
        call <SID>SrcExpl_MatchExpr()
        " Highlight the symbol
        call <SID>SrcExpl_HltExpr()
        " Loop key & index
        let l:indx = 0
        " Loop for listing each tag from tags file
        while 1
            " First get each tag list
            let l:dict = get(a:list, l:indx, {})
            " There is one tag
            if l:dict != {}
                " Goto the end of the buffer put the buffer list
                $
                put! ='[File Name]: '. l:dict['filename']
                    \ . ' ' . '[EX Command]: ' . l:dict['cmd']
            else " Traversal finished
                break
            endif
            let l:indx += 1
        endwhile
    endif

    " Delete the extra trailing blank line
    $ d _
    " Move the cursor to the top of the Source Explorer window
    exe "normal! " . "gg"
    " Back to the first line
    setlocal nomodifiable

    " Successfully
    return 0

endfunction " }}}

" SrcExpl_ViewOneDef() {{{

" Display the definition of the symbol into the preview window

function! <SID>SrcExpl_ViewOneDef(fname, excmd)

    let l:expr = ""

    " Open the file first
    exe "silent " . "pedit " . a:fname
    " Go to the Source Explorer window
    silent! wincmd P
    " Indeed back to the preview window
    if &previewwindow
        " Modify the EX Command to locate the tag exactly
        let l:expr = substitute(a:excmd, '/^', '/^\\C', 'g')
        let l:expr = substitute(l:expr,  '\*',  '\\\*', 'g')
        let l:expr = substitute(l:expr,  '\[',  '\\\[', 'g')
        let l:expr = substitute(l:expr,  '\]',  '\\\]', 'g')
        " Execute EX command according to the parameter
        silent! exe l:expr
        " Just avoid highlight
        " silent! /\<\>
        " Match the symbol
        call <SID>SrcExpl_MatchExpr()
        " Highlight the symbol
        call <SID>SrcExpl_HltExpr()
        " Set the current buf-win property
        call <SID>SrcExpl_SetCurr()
    endif

    " Successfully
    return 0

endfunction " }}}

" SrcExpl_TryToTag() {{{

" Just try to find the tag under the cursor

function! <SID>SrcExpl_TryToTag(expr)

    " Function calling result
    let l:rslt = -1

    " We get the tag list of the expression
    let l:list = taglist(a:expr)
    " Then get the length of taglist
    let l:len = len(l:list)

    " No tag
    if l:len <= 0
        " No definition
        let s:SrcExpl_status = 0
        let l:rslt = <SID>SrcExpl_NoteNoDef()
    " One tag
    elseif l:len == 1
        " One definition
        let s:SrcExpl_status = 1
        " Get dictionary to load tag's file name and ex command
        let l:dict = get(l:list, 0, {})
        let l:rslt = <SID>SrcExpl_ViewOneDef(l:dict['filename'], l:dict['cmd'])
    " Multiple tags list
    else
        " Multiple definitions
        let s:SrcExpl_status = 2
        let l:rslt = <SID>SrcExpl_ListMultiDefs(l:list, l:len)
    endif

    " Got the result for the caller
    return l:rslt

endfunction " }}}

" SrcExpl_GetSymbol() {{{

" Get the valid symbol under the current cursor

function! <SID>SrcExpl_GetSymbol()

    " Get the current character under the cursor
    let l:cchar = getline(".")[col(".") - 1]
    " Get the current word under the cursor
    let l:cword = expand("<cword>")

    " Judge that if or not the character is invalid,
    " because only 0-9, a-z, A-Z, and '_' are valid
    if l:cchar =~ '\w' && l:cword =~ '\w'
        " If the key word symbol has been explored
        " just now, we will not explore that again
        if s:SrcExpl_symbol ==# l:cword
            " Not in Local definition searching mode
            if g:SrcExpl_searchLocalDef == 0
                return -1
            else
                " Do not refresh when jumping to the edit window
                if s:SrcExpl_jumped == 1
                    " Get the cursor line number
                    let s:SrcExpl_csrLine = line(".")
                    " Reset the jump flag
                    let s:SrcExpl_jumped = 0
                    return -2
                endif
                " The cursor is not moved actually
                if s:SrcExpl_csrLine == line(".")
                    return -3
                endif
            endif
        endif
        " Get the cursor line number
        let s:SrcExpl_csrLine = line(".")
        " Get the symbol word under the cursor
        let s:SrcExpl_symbol = l:cword
    " Invalid character
    else
        if s:SrcExpl_symbol == ''
            return -4 " Second, third ...
        else " First
            let s:SrcExpl_symbol = ''
        endif
    endif

    " Successfully
    return 0

endfunction " }}}

" SrcExpl_AdaptPlugins() {{{

" The Source Explorer window will not work when the cursor on the 

" window of other plugins, such as 'Taglist', 'NERD tree' etc.

function! <SID>SrcExpl_AdaptPlugins()

    " Traversal the list of other plugins
    for item in g:SrcExpl_pluginList
        " If they acted as a split window
        if bufname("%") ==# item
            " Just avoid this operation
            return 1
        endif
    endfor

    " Safe
    return 0

endfunction " }}}

" SrcExpl_Refresh() {{{

" Refresh the Source Explorer window and update the status

function! g:SrcExpl_Refresh()

    " Tab page must be invalid
    if s:SrcExpl_tabPage != tabpagenr()
        return -1
    endif

    " If or not the cursor is on the edit window
    if &previewwindow || <SID>SrcExpl_AdaptPlugins()
        return -2
    endif

    " Avoid errors of multi-buffers
    if &modified
        call <SID>SrcExpl_OutErrMsg("This modified file is not saved")
        return -3
    endif

    " Get the edit window position
    let s:SrcExpl_editWin = winnr()

    " Get the symbol under the cursor
    if <SID>SrcExpl_GetSymbol()
        return -4
    endif

    " call <SID>SrcExpl_Debug('s:SrcExpl_symbol is (' . s:SrcExpl_symbol . ')')
    let l:expr = '\C\<' . s:SrcExpl_symbol . '\>'
    " Try to Go to local declaration
    if g:SrcExpl_searchLocalDef != 0
        let l:rslt = <SID>SrcExpl_TryToGoDecl(l:expr)
    else
        let l:rslt = -1
    endif

    if l:rslt >= 0
        " We got a local definition
        let s:SrcExpl_status = 3
    else
        " Try to tag
        call <SID>SrcExpl_TryToTag(l:expr)
    endif

    " Refresh all the screen
    redraw
    " Go back to the main edit window
    silent! exe s:SrcExpl_editWin . "wincmd w"

    " Successfully
    return 0

endfunction " }}}

" SrcExpl_GetInput() {{{

" Get the word inputed by user on the command line window

function! <SID>SrcExpl_GetInput(note)

    " Be sure synchronize
    call inputsave()
    " Get the input content
    let l:input = input(a:note)
    " Save the content
    call inputrestore()
    " Tell the Source Explorer
    return l:input

endfunction " }}}

" SrcExpl_ProbeTags() {{{

" Probe if or not there is a 'tags' file under the project PATH

function! <SID>SrcExpl_ProbeTags()

    " Then get the new current-work-directory
    let l:tmp = getcwd()

    " Get the raw work path
    if l:tmp != s:SrcExpl_workPath
        " Load the Source Explorer at first
        if s:SrcExpl_workPath == ""
            " Save that
            let s:SrcExpl_workPath = l:tmp
        endif
        " Go to the raw work path
        exe "cd " . s:SrcExpl_workPath
    endif

    let l:tmp = ""

    " Loop to probe the tags in CWD
    while !filereadable("tags")
        " First save
        let l:tmp = getcwd()
        " Up to my parent directory
        cd ..
        " Have been up to the system root directory
        if l:tmp == getcwd()
            " So break out
            break
        endif
    endwhile

    " Indeed in the system root directory
    if l:tmp == getcwd()
        " Clean the buffer
        let s:SrcExpl_tagsPath = ""
    " Have found a 'tags' file already
    else
        " UNIXs OS or MAC OS-X
        if has("unix") || has("macunix")
            if getcwd()[strlen(getcwd()) - 1] != '/'
                let s:SrcExpl_tagsPath = 
                    \ getcwd() . '/'
            endif
        " WINDOWS 95/98/ME/NT/2000/XP
        elseif has("win32")
            if getcwd()[strlen(getcwd()) - 1] != '\'
                let s:SrcExpl_tagsPath = 
                    \ getcwd() . '\'
            endif
        else
            " Other operating system
            call <SID>SrcExpl_OutErrMsg("Not support on this OS platform for now")
        endif
    endif

    call <SID>SrcExpl_Debug("s:SrcExpl_tagsPath is (" . s:SrcExpl_tagsPath . ")")

endfunction " }}}

" SrcExpl_GetEditWin() {{{

" Get the main edit window index

function! <SID>SrcExpl_GetEditWin()

    let l:i = 1
    let l:j = 1

    " Loop for searching the edit window
    while 1
        " Traverse the plugin list for each sub-window
        for item in g:SrcExpl_pluginList
            if bufname(winbufnr(l:i)) ==# item
                \ || getwinvar(l:i, '&previewwindow')
                break
            else
                let l:j += 1
            endif
        endfor
        " We've found one
        if j >= len(g:SrcExpl_pluginList)
            return l:i
        else
            let l:i += 1
            let l:j = 0
        endif
        " Not found finally
        if l:i > winnr("$")
            return -1
        endif
    endwhile

endfunction " }}}

" SrcExpl_InitGlbVals() {{{

" Initialize global variables

function! <SID>SrcExpl_InitGlbVals()

    " The whole path of 'tags' file
    let s:SrcExpl_tagsPath = ''
    " The key word symbol for exploring
    let s:SrcExpl_symbol = ''
    " Original work path when initializing
    let s:SrcExpl_workPath = ''
    " The whole file path being explored now
    let s:SrcExpl_currPath = ''
    " Line number of the current word under the cursor
    let s:SrcExpl_currLine = 0
    " Column number of the current word under the cursor
    let s:SrcExpl_currCol = 0
    " Line number of the current cursor
    let s:SrcExpl_csrLine = 0
    " The edit window number
    let s:SrcExpl_editWin = 0
    " The tab page number
    let s:SrcExpl_tabPage = 0
    " If jump to the edit window
    let s:SrcExpl_jumped = 0
    " Source Explorer status:
    " 0: No such tag definition
    " 1: One definition
    " 2: Multiple definitions
    " 3: Local definition
    let s:SrcExpl_status = 0
    " Mark index to get the real item
    let s:SrcExpl_markIndex = -1

endfunction " }}}

" SrcExpl_CloseWin() {{{

" Close the Source Explorer window and delete its buffer

function! <SID>SrcExpl_CloseWin()

    " Just close the preview window
    pclose

endfunction " }}}

" SrcExpl_OpenWin() {{{

" Open the Source Explorer window under the bottom of (G)Vim,
" and set the buffer's property of the Source Explorer

function! <SID>SrcExpl_OpenWin()

    " Get the edit window position
    let s:SrcExpl_editWin = winnr()
    " Get the tab page number
    let s:SrcExpl_tabPage = tabpagenr()

    " Has the Source Explorer existed already?
    let l:bufnum = bufnr(s:SrcExpl_title)
    " Not existed, create a new buffer
    if l:bufnum == -1
        " Create a new buffer
        let l:wcmd = s:SrcExpl_title
    else
        " Edit the existing buffer
        let l:wcmd = '+buffer' . l:bufnum
    endif

    " Reopen the Source Explorer idle window
    exe "silent " . "pedit " . l:wcmd
    " Jump to the Source Explorer
    silent! wincmd P
    " Open successfully and jump to it indeed
    if &previewwindow
        " First make it modifiable
        setlocal modifiable
        " Not show its name on the buffer list
        setlocal nobuflisted
        " No exact file
        setlocal buftype=nofile
        " Delete all lines in buffer
        1,$d _
        " Goto the end of the buffer
        $
        " Display the version of the Source Explorer
        put! ='Source Explorer V3.6'
        " Delete the extra trailing blank line
        $ d _
        " Make it no modifiable
        setlocal nomodifiable
        " Put it on the bottom of (G)Vim
        silent! wincmd J
    endif

    " Indeed go back to the edit window
    silent! exe s:SrcExpl_editWin . "wincmd w"

endfunction " }}}

" SrcExpl_Cleanup() {{{

" Clean up the rubbish and free the mapping resources

function! <SID>SrcExpl_Cleanup()

    " GUI Version
    if has("gui_running")
        " Delete the SrcExplGoBack item in Popup menu
        silent! nunmenu 1.01 PopUp.&SrcExplGoBack
    endif

    " Make the 'double-click' for nothing
    if maparg('<2-LeftMouse>', 'n') != ''
        nunmap <silent> <2-LeftMouse>
    endif

    " Unmap the jump key
    if maparg(g:SrcExpl_jumpKey, 'n') == 
        \ ":call g:SrcExpl_Jump()<CR>"
        exe "nunmap " . g:SrcExpl_jumpKey
    endif

    " Unmap the go back key
    if maparg(g:SrcExpl_goBackKey, 'n') == 
        \ ":call g:SrcExpl_GoBack()<CR>"
        exe "nunmap " . g:SrcExpl_goBackKey
    endif

    " Unload the autocmd group
    silent! autocmd! SrcExpl_AutoCmd

endfunction " }}}

" SrcExpl_Init() {{{

" Initialize the Source Explorer properties

function! <SID>SrcExpl_Init()

    " Open all the folds
    if has("folding")
        " Open this file at first
        exe "normal " . "zR"
        " Let it works during the editing period
        set foldlevelstart=99
    endif
    " Not highlight the word which had been searched
    " Because execute EX command will active a search event
    set nohlsearch
    " Not change the current working directory
    set noautochdir
    " Delete all the marks
    delmarks A-Z a-z 0-9
    " Initialize script global variables
    call <SID>SrcExpl_InitGlbVals()

    " We must get a valid edit window
    let l:tmp = <SID>SrcExpl_GetEditWin()
    " Not found one valid edit window
    if l:tmp < 0
        " Can not find main edit window
        call <SID>SrcExpl_OutErrMsg("Can not Found the edit window")
        return -1
    endif
    " Jump to that
    silent! exe l:tmp . "wincmd w"

    " Firstly, we move to the whole path of the file you editing on
    exe "cd " . expand('%:p:h')
    " Access the Tags file
    call <SID>SrcExpl_ProbeTags()

    " Found one Tags file
    if s:SrcExpl_tagsPath != ""
        " Compiled with 'Quickfix' feature
        if !has("quickfix")
            " Can not create preview window without quickfix feature
            call <SID>SrcExpl_OutErrMsg("Not support without 'Quickfix'")
            return -2
        endif
        " Have found 'tags' file and update that
        if g:SrcExpl_isUpdateTags != 0
            " We tell user where we update the tags file
            echohl Question
                echo "\nSrcExpl: Updating 'tags' file in (". s:SrcExpl_tagsPath . ")"
            echohl None
            " Execute 'ctags' utility program externally
            exe "!" . g:SrcExpl_updateTagsCmd
        endif
    else
        " Ask user if or not create a tags file
        echohl Question
            \ | let l:tmp = <SID>SrcExpl_GetInput("\nSrcExpl: "
                \ . "The 'tags' file was not found in your PATH.\n"
            \ . "Create one in the current directory now? (y)es/(n)o?") | 
        echohl None
        " They do
        if l:tmp == "y" || l:tmp == "yes"
            " Back from the root directory
            exe "cd " . s:SrcExpl_workPath
            " We tell user where we create a tags file
            echohl Question
                echo "SrcExpl: Creating 'tags' file in (". s:SrcExpl_workPath . ")"
            echohl None
            " Call the external 'ctags' utility program
            exe "!" . g:SrcExpl_updateTagsCmd
            " Rejudge the tags file if existed
            call <SID>SrcExpl_ProbeTags()
            " Maybe there is no 'ctags' utility program in user's system
            if s:SrcExpl_tagsPath == ""
                " Tell them what happened
                call <SID>SrcExpl_OutErrMsg("Execute 'ctags' utility program failed")
                return -3
            endif
        else
            " They don't
            echo ""
            return -4
        endif
    endif

    " First set the height of preview window
    exe "set previewheight=". string(g:SrcExpl_winHeight)
    " Set the actual update time according to user's requestion
    " 100 milliseconds by default
    exe "set updatetime=" . string(g:SrcExpl_refreshTime)
    " Then form an autocmd group
    augroup SrcExpl_AutoCmd
        " Delete the autocmd group first
        autocmd!
        au! CursorHold * nested call g:SrcExpl_Refresh()
        au! WinEnter * nested call <SID>SrcExpl_EnterWin()
    augroup end

    " Initialize successfully
    return 0

endfunction " }}}

" SrcExpl_Toggle() {{{

" The User Interface function to open / close the Source Explorer

function! <SID>SrcExpl_Toggle()

    call <SID>SrcExpl_Debug("s:SrcExpl_opened is (" . s:SrcExpl_opened . ")")

    " Already closed
    if s:SrcExpl_opened == 0
        " Initialize the properties
        let l:rtn = <SID>SrcExpl_Init()
        " Initialize failed
        if l:rtn != 0
            return -1
        endif
        " Create the window
        call <SID>SrcExpl_OpenWin()
        " Set the switch flag on
        let s:SrcExpl_opened = 1
    " Already Opened
    else
        " Not in the exact tab page
        if s:SrcExpl_tabPage != tabpagenr()
            call <SID>SrcExpl_OutErrMsg("Not support multiple tab pages for now")
            return -2
        endif
        " Set the switch flag off
        let  s:SrcExpl_opened = 0
        " Close the window
        call <SID>SrcExpl_CloseWin()
        " Do the cleaning work
        call <SID>SrcExpl_Cleanup()
    endif

    " Successfully
    return 0

endfunction " }}}

" SrcExpl_Close() {{{

" The User Interface function to close the Source Explorer

function! <SID>SrcExpl_Close()

    if s:SrcExpl_opened == 1
        " Not in the exact tab page
        if s:SrcExpl_tabPage != tabpagenr()
            call <SID>SrcExpl_OutErrMsg("Not support multiple tab pages for now")
            return -1
        endif
        " Set the switch flag off
        let s:SrcExpl_opened = 0
        " Close the window
        call <SID>SrcExpl_CloseWin()
        " Do the cleaning work
        call <SID>SrcExpl_Cleanup()
    else
        " Tell users the reason
        call <SID>SrcExpl_OutErrMsg("Source Explorer is close")
        return -2
    endif

    " Successfully
    return 0

endfunction " }}}

" SrcExpl() {{{

" The User Interface function to open the Source Explorer

function! <SID>SrcExpl()

    if s:SrcExpl_opened == 0
        " Initialize the properties
        let l:rtn = <SID>SrcExpl_Init()
        " Initialize failed
        if l:rtn != 0
            return -1
        endif
        " Create the window
        call <SID>SrcExpl_OpenWin()
        " Set the switch flag on
        let s:SrcExpl_opened = 1
    else
        " Not in the exact tab page
        if s:SrcExpl_tabPage != tabpagenr()
            call <SID>SrcExpl_OutErrMsg("Not support multiple tab pages for now")
            return -2
        endif
        " Already running
        call <SID>SrcExpl_OutErrMsg("Source Explorer is running")
        return -3
    endif

    " Successfully
    return 0

endfunction " }}}

" Avoid side effects {{{

set cpoptions&
let &cpoptions = s:save_cpo
unlet s:save_cpo

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                                              "
" vim:foldmethod=marker:tabstop=4
"                                                                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

