fu! MendeleyKeys(keys)
	let l:m_call = "export ORIG_WIN=`xdotool getactivewindow`; xdotool getactivewindow getactivewindow search --onlyvisible Mendeley  windowactivate key "
	let l:m_call .= " " . a:keys " "
	let l:m_call .= " windowactivate $ORIG_WIN"
	let l:m_call .= " windowactivate $ORIG_WIN"
	let l:m_call .= " windowactivate $ORIG_WIN"
	let l:m_call .= " windowactivate $ORIG_WIN"
	call system(l:m_call)
endfun

command! MendeleyDown call MendeleyKeys("Down Down Down")
command! MendeleyUp   call MendeleyKeys("Up Up Up")
command! MendeleyPgDn call MendeleyKeys("Next Next Next")
command! MendeleyPgUp   call MendeleyKeys("Prior Prior Prior")

nnoremap <buffer> <PageUp> :silent MendeleyPgUp<Return>
nnoremap <buffer> <C-b> :silent MendeleyPgUp<Return>
nnoremap <buffer> k :silent MendeleyUp<Return>
nnoremap <buffer> <PageDown> :silent MendeleyPgDn<Return>
nnoremap <buffer> <C-f> :silent MendeleyPgDn<Return>
nnoremap <buffer> j :silent MendeleyDown<Return>


