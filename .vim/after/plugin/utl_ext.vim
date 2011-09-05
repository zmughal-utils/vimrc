let g:utl_cfg_hdl_mt_application_pdf__xpdf="call Utl_if_hdl_mt_application_pdf_xpdf('%p', '%f')"
fu! Utl_if_hdl_mt_application_pdf_xpdf(path,fragment)
	if !filereadable(a:path)
		redraw | echom "File '".a:path."' not found"
		return
	endif
	let page = ''
	if a:fragment != ''
		let ufrag = UtlUri_unescape(a:fragment)
		if ufrag =~ '^page='
			let page = substitute(ufrag, '^page=', '', '')
		else 
			echohl ErrorMsg
			echo "Unsupported fragment `#".ufrag."' Valid only `#page='"
			echohl None
			return
		endif
	endif

	let cmd = ':silent !xpdf -q '.'"'.a:path.'"'.' '.l:page.' &'
	exe cmd
endfu

func! Utl_Get_Browser_Arg(uri, frag)
	if(a:frag != '<undef>')
		return a:uri."\\#".a:frag
	endif
	return a:uri
endfunc
if has("unix")
	if exists("$DISPLAY")
		let g:utl_cfg_hdl_scm_http__system = "exe 'silent !firefox '.Utl_Get_Browser_Arg('%u', '%f').' &'"
	else
		if executable("elinks")
			let g:utl_cfg_hdl_scm_http__system = "exe 'silent !elinks '.Utl_Get_Browser_Arg('%u','%f')"
		elseif executable("lynx")
			let g:utl_cfg_hdl_scm_http__system = "exe 'silent !lynx '.Utl_Get_Browser_Arg('%u','%f')"
		else
			let g:utl_cfg_hdl_scm_http__system = "echoerr 'No browser found for terminal'"
		endif
	endif
	let g:utl_cfg_hdl_mt_application_pdf = g:utl_cfg_hdl_mt_application_pdf__xpdf
	let g:utl_cfg_hdl_mt_generic = "silent !see '%p'"
endif

func! Set_utl_system()
	let g:utl_cfg_hdl_scm_http = g:utl_cfg_hdl_scm_http__system
endfunc

func! Set_utl_vim()
	let g:utl_cfg_hdl_scm_http = g:utl_cfg_hdl_scm_http__wget
endfunc

" Use system to open
nmap <Leader>gu	:call Set_utl_system()<bar>Utl<CR>zv
vmap <Leader>gu	:call Set_utl_system()<bar>Utl o v<CR>zv

" Use vim to open
nmap <Leader>Gu	:call Set_utl_vim()<bar>Utl<CR>zv
vmap <Leader>Gu	:call Set_utl_vim()<bar>Utl o v<CR>zv

" Split and use vim to open
nmap <Leader>GU	:call Set_utl_vim()<bar>split<bar>Utl<CR>zv
vmap <Leader>GU	:call Set_utl_vim()<bar>split<bar>Utl o v<CR>zv

fu! Utl_AddressScheme_find(url, fragment, dispMode)
    let findId = UtlUri_unescape( UtlUri_opaque(a:url) )
    let findUrl = findfile(findId)
    return  Utl_AddressScheme_file(findUrl, a:fragment, a:dispMode)
endfu
