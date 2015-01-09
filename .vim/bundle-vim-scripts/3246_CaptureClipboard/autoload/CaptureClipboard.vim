" CaptureClipboard.vim: Append system clipboard changes to current buffer.
"
" DEPENDENCIES:
"   - ingocmdargs.vim autoload script
"
" Copyright: (C) 2010-2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.11.002	25-Nov-2012	Implement check for no-modifiable buffer via
"				noop-modification instead of checking for
"				'modifiable'; this also handles the read-only
"				warning.
"				Factor out s:GetDelimiter() as
"				ingocmdargs#GetStringExpr() for re-use in other
"				plugins.
"   1.00.001	18-Sep-2010	file creation
let s:save_cpo = &cpo
set cpo&vim

function! s:PreCapture()
    " Disable folding; it may obscure what's being captured.
    let s:save_foldenable = &foldenable
    set nofoldenable

    " Save original title.
    if &title
	let s:save_titlestring = &titlestring
    endif

    " Set up autocmd to restore settings in case the capturing is not stopped
    " via the end-of-capture marker, but by aborting the command.
    augroup CaptureClipboard
	autocmd!
	" Note: The CursorMoved event is triggered immediately after a CTRL-C if
	" text has been inserted; the other events are not triggered inside the
	" loop. If no text has been captured, we try to restore the settings
	" when the cursor moves or the window changes.
	autocmd CursorHold,CursorMoved,WinLeave * call s:PostCapture() | autocmd! CaptureClipboard
    augroup END
endfunction
function! s:PostCapture()
    if exists('s:save_titlestring')
	let &titlestring = s:save_titlestring
	unlet s:save_titlestring
    endif

    if exists('s:save_foldenable')
	let &foldenable = s:save_foldenable
	unlet s:save_foldenable
    endif
endfunction

function! s:Message( ... )
    if &title
	let &titlestring = (a:0 ? a:1 . printf(' clip%s...', (a:1 == 1 ? '' : 's')) : 'Capturing...') . ' - %{v:servername}'
	redraw  " This is necessary to update the title.
    endif

    echo printf('Capturing clipboard changes %sto current buffer. To stop, press <CTRL-C> or copy "%s". ',
    \	(a:0 ? '(' . a:1 . ') ' : ''),
    \	strtrans(g:CaptureClipboard_EndOfCaptureMarker)
    \)
endfunction
function! s:EndMessage( count )
    redraw
    echo printf('Captured %s clipboard changes. ', (a:count > 0 ? a:count : 'no'))
endfunction

function! s:GetClipboard()
    execute 'return @' . g:CaptureClipboard_Register
endfunction
function! s:ClearClipboard()
    execute 'let @' . g:CaptureClipboard_Register . ' = ""'
endfunction

function! s:Insert( text, delimiter, isPrepend )
    let l:insertText = (a:isPrepend ? a:text . a:delimiter : a:delimiter . a:text)
    if l:insertText =~# (a:isPrepend ? '\n$' : '^\n')
	let l:insertText = (a:isPrepend ? strpart(l:insertText, 0, strlen(l:insertText) - 1) : strpart(l:insertText, 1))
	execute 'put' . (a:isPrepend ? '!' : '') '=l:insertText'
    else
	execute "normal! \"=l:insertText\<CR>" . (a:isPrepend ? 'Pg`[' : 'pg`]')
    endif
endfunction
function! CaptureClipboard#CaptureClipboard( isPrepend, isTrim, count, ... )
    let l:delimiter = (a:0 ? ingocmdargs#GetStringExpr(a:1) : g:CaptureClipboard_DefaultDelimiter)
    let l:firstDelimiter = (l:delimiter =~# '\n' ? "\n" : '')

    call s:PreCapture()
    call s:Message()
    let l:captureCount = 0

    if s:GetClipboard() ==# g:CaptureClipboard_EndOfCaptureMarker
	" Remove the end-of-capture marker (from a previous :CaptureClipboard run) from the
	" clipboard, or else the capture won't even start.
	call s:ClearClipboard()
    endif

    let l:temp = s:GetClipboard()
    while ! (s:GetClipboard() ==# g:CaptureClipboard_EndOfCaptureMarker || (a:count && l:captureCount == a:count))
	if l:temp !=# s:GetClipboard()
	    let l:temp = s:GetClipboard()
	    call s:Insert(
	    \	(a:isTrim ? substitute(l:temp, '^\_s*\(.\{-}\)\_s*$', '\1', 'g') : l:temp),
	    \	(l:captureCount == 0 ? l:firstDelimiter : l:delimiter),
	    \	a:isPrepend
	    \)
	    let l:captureCount += 1

	    if g:CaptureClipboard_IsAutoSave
		silent! noautocmd write
	    endif

	    redraw
	    call s:Message(l:captureCount)
	else
	    sleep 50ms
	endif
    endwhile

    call s:EndMessage(l:captureCount)
    autocmd! CaptureClipboard
    call s:PostCapture()
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
