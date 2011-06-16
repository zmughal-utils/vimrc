" Toggle {{{
command! -nargs=0 SpellToggle	setl spell! spell?
nnoremap <silent>	,ts	:SpellToggle<CR>
command! -nargs=0 PasteToggle	setl paste! paste?
nnoremap <silent>	,tp	:PasteToggle<CR>
command! -nargs=0 ListToggle	setl list! list?
nnoremap <silent>	,tl	:ListToggle<CR>
command! -nargs=0 NumberToggle	setl number! number?
nnoremap <silent>	,tn	:NumberToggle<CR>
command! -nargs=0 CursorLineToggle	setl cursorline! cursorline?
nnoremap <silent>	,tcl	:CursorLineToggle<CR>
command! -nargs=0 WrapToggle	setl wrap! wrap?
nnoremap <silent>	,tw	:WrapToggle<CR>
" }}}
