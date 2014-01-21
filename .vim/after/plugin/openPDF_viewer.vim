command! -nargs=0 PDFViewerEvince   let g:pdf_viewer="evince" | let g:utl_cfg_hdl_mt_application_pdf = g:utl_cfg_hdl_mt_application_pdf__evince
command! -nargs=0 PDFViewerXpdf     let g:pdf_viewer="xpdf" | let g:utl_cfg_hdl_mt_application_pdf = g:utl_cfg_hdl_mt_application_pdf__xpdf
command! -nargs=0 PDFViewerXpdfrv   let g:pdf_viewer="xpdf -rv" | let g:utl_cfg_hdl_mt_application_pdf = g:utl_cfg_hdl_mt_application_pdf__xpdf_rv
command! -nargs=0 PDFViewerMendeley let g:pdf_viewer="mendeleydesktop" | let g:utl_cfg_hdl_mt_application_pdf = g:utl_cfg_hdl_mt_application_pdf__mendeley

if executable('xpdf')
	autocmd VimEnter * PDFViewerXpdf
elseif executable('evince')
	autocmd VimEnter * PDFViewerEvince
end
