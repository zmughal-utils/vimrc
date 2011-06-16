" Close Buffers {{{
function! CloseWastedBuffers(method)
	let last_buffer=bufnr("$")
	let cur_buffer=bufnr("%")
	let i=1
	while i<=last_buffer
		if i!=cur_buffer && bufexists(i) && bufname(i) == "" && !getbufvar(i, "&modified")
			call CloseBuff(a:method,i)
		endif
		let i=i+1
	endwhile
endfunction
command! -nargs=0 CloseBuffersDel	call CloseWastedBuffers(0)
command! -nargs=0 CloseBuffersWipe	call CloseWastedBuffers(1)
function! CloseOtherBuffers(method)
	let cur_buffer=bufnr("%")
	bufdo	if bufnr("%")!=cur_buffer |try|call CloseBuff(a:method,-1)|catch|echo "Could not close ".bufname("%")|endtry|endif
endfunction

function! CloseBuff(method,number)
	let num=string(a:number)
	if !bufexists(a:number)
		if a:number==-1
			let num=""
		else
			return
		endif
	endif

	let meth=""
	if a:method==0
		let meth="bdelete"
	elseif a:method==1
		let meth="bwipeout"
	endif
	if meth!=""
		try
			exe num.meth
		catch
		endtry
	endif
endfunction
"}}}
