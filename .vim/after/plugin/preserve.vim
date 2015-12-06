" A wrapper function to restore the cursor position, window position,
" and last search after running a command.
"
" use like
"
"     nmap _$ :call Preserve("%s/\\s\\+$//e")<CR>
"
" from:
" - <https://technotales.wordpress.com/2010/03/31/preserve-a-vim-function-that-keeps-your-state/>
" - <https://docwhat.org/vim-preserve-your-cursor-and-window-state/>
function! Preserve(command)
	" Save the last search
	let last_search=@/
	" Save the current cursor position
	let save_cursor = getpos(".")
	" Save the window position
	normal H
	let save_window = getpos(".")
	call setpos('.', save_cursor)

	" Do the business:
	execute a:command

	" Restore the last_search
	let @/=last_search
	" Restore the window position
	call setpos('.', save_window)
	normal zt
	" Restore the cursor position
	call setpos('.', save_cursor)
endfunction
