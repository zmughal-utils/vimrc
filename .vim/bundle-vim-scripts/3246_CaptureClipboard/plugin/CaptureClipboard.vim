" CaptureClipboard.vim: Append system clipboard changes to current buffer.

" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.
"   - CaptureClipboard.vim autoload script.

" Copyright: (C) 2010-2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Original Autor: Marian Csontos
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.11.010	28-Dec-2012	Minor: Correct lnum for no-modifiable buffer
"				check.
"   1.11.009	25-Nov-2012	Implement check for no-modifiable buffer via
"				noop-modification instead of checking for
"				'modifiable'; this also handles the read-only
"				warning.
"   1.10.008	29-Oct-2012	Add mapping to wait for and insert one capture.
"   1.00.007	20-Sep-2010	Changed end-of-capture marker from "EOF" to ".";
"				the former rarely exists in real life, so it's
"				mostly useless functionality. A single dot
"				character typically isn't contained in a
"				capture, much more frequent in capture sources,
"				and has some precedents, e.g. to end commit
"				messages.
"   1.00.006	18-Sep-2010	Moved functions from plugin to separate autoload
"				script.
"				Made clipboard register configurable, so that
"				either the X selection or the X clipboard is
"				used (this is irrelevant in Windows).
"				Made end-of-capture marker configurable.
"				Made auto-save feature configurable and turn it
"				off by default; I typcally trust Vim to take
"				care of my buffer contents.
"				Made default delimiter configurable.
"	005	17-Sep-2010	ENH: Insertion of newline is now entirely
"				controlled by {separator}, not by
"				:0CaptureClipboard.
"				ENH: [bang] now turns on trimming of whitespace,
"				(seldomly used) prepending is now separate
"				:CaptureClipboardReverse command.
"				ENH: {separator} is not inserted before first
"				capture, only between subsequent ones.
"				ENH: Can limit number of captures via [count].
"	004	26-Feb-2010	Now using correct plural for the title message.
"	003	24-Feb-2010	ENH: Showing capture status in 'titlestring' to
"				indicate the blocking polling mode and also any
"				successful capture even when Vim is minimized or
"				the messages are otherwise obscured by another
"				window.
"	002	23-Sep-2009	Renamed from TrackClipboard to CaptureClipboard.
"				ENH: Directly updating the window after each
"				capture, not every 5s.
"				ENH: Capture is inserted below current line, not
"				necessarily at the end of the buffer.
"				ENH: <bang> can be used to revert insertion, and
"				prepend instead of appending. (Analog to the
"				:put command.)
"				BUG: Remove the EOF marker, or else the capture
"				won't even start.
"				BUG: Silently ignoring autosave failures, the
"				user can deal with them after capturing is
"				finished.
"				ENH: Checking for 'nomodifiable' buffer.
"				ENH: Progress and end messages list number of
"				captures.
"				ENH: Allowing empty line delimiter by passing in
"				'' or "". Evaluating quoted arguments to allow
"				whitespace and other special stuff in delimiter.
"				ENH: Insertion without newlines, all in one
"				line.
"	001	26-Oct-2006	file creation from vimtip #1370

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_CaptureClipboard') || (v:version < 700)
    finish
endif
let g:loaded_CaptureClipboard = 1

"- configuration --------------------------------------------------------------

if ! exists('g:CaptureClipboard_DefaultDelimiter')
    let g:CaptureClipboard_DefaultDelimiter = "\n"
endif

if ! exists('g:CaptureClipboard_EndOfCaptureMarker')
    let g:CaptureClipboard_EndOfCaptureMarker = '.'
endif

if ! exists('g:CaptureClipboard_IsAutoSave')
    let g:CaptureClipboard_IsAutoSave = 0
endif

if ! exists('g:CaptureClipboard_Register')
    let g:CaptureClipboard_Register = '*'
endif


"- commands -------------------------------------------------------------------

command! -bang -count -nargs=? CaptureClipboard		call setline('.', getline('.')) | call CaptureClipboard#CaptureClipboard(0, <bang>0, <count>, <f-args>)
command! -bang -count -nargs=? CaptureClipboardReverse	call setline('.', getline('.')) | call CaptureClipboard#CaptureClipboard(1, <bang>0, <count>, <f-args>)


"- mappings --------------------------------------------------------------------

inoremap <silent> <Plug>(CaptureClipboardInsertOne) x<BS><C-\><C-n>:1CaptureClipboard ""<CR>a
if ! hasmapto('<Plug>(CaptureClipboardInsertOne)', 'i')
    imap <C-R>? <Plug>(CaptureClipboardInsertOne)
endif

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
