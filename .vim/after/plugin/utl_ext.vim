let g:utl_cfg_hdl_mt_application_pdf__xpdf="call Utl_if_hdl_mt_application_pdf_xpdf('%p', '%f')"
let g:utl_cfg_hdl_mt_application_pdf__xpdf_rv="call Utl_if_hdl_mt_application_pdf_xpdf('%p', '%f', '-rv')"
let g:utl_cfg_hdl_mt_application_pdf__evince="call Utl_if_hdl_mt_application_pdf_evince('%p', '%f')"
fu! Utl_if_hdl_mt_application_pdf_parse(path,fragment)
	let l:path = escape(a:path, '!')
	if !filereadable(l:path)
		redraw | echom "File '".l:path."' not found"
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
	let info = {}
	let info["path"] = l:path
	if !empty(page)
		let info["page"] = l:page
	endif
	return info
endfu

fu! Utl_if_hdl_mt_application_pdf_xpdf(path,fragment, ...)
	let info = Utl_if_hdl_mt_application_pdf_parse(a:path,a:fragment)
	let cmd = ':silent !xpdf -q '
	if exists("a:1")
		let cmd .= ' '.a:1.' '
	endif
	let cmd .= '"'.l:info["path"].'"'
	if has_key(info, 'page')
		let cmd .= ' '.info["page"]
	endif
	let cmd .= ' &'
	exe cmd
endfu

fu! Utl_if_hdl_mt_application_pdf_evince(path,fragment)
	let info = Utl_if_hdl_mt_application_pdf_parse(a:path,a:fragment)
	let cmd = ':silent !evince '
	if has_key(info, 'page')
		let cmd .= ' -p '.info["page"].' '
	endif
	let cmd .= '"'.l:info["path"].'"'
	let cmd .= ' &'
	exe cmd
endfu

func! Utl_Get_Browser_Arg(uri, frag)
	let l:uri = escape(a:uri, '!')
	if(a:frag != '<undef>')
		return l:uri."\\#".a:frag
	endif
	return l:uri
endfunc
if has("unix")
	if exists("$DISPLAY")
		let g:utl_cfg_hdl_scm_http__system = "exe 'silent !firefox \"'.Utl_Get_Browser_Arg('%u', '%f').'\" &'"
	else
		if executable("elinks")
			let g:utl_cfg_hdl_scm_http__system = "exe 'silent !elinks \"'.Utl_Get_Browser_Arg('%u','%f').'\"'"
		elseif executable("lynx")
			let g:utl_cfg_hdl_scm_http__system = "exe 'silent !lynx \"'.Utl_Get_Browser_Arg('%u','%f').'\"'"
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
