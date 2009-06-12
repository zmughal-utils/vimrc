" Vim color file -- elda
" Maintainer: Luinnar
" Last Change: 12-May-2008

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name="elda"

let save_cpo = &cpo
set cpo&vim

" basic highlight groups (:help highlight-groups)

" text

hi Normal       guifg=#00ffff  guibg=#000000  ctermfg=cyan   ctermbg=black
hi Folded       guifg=#c2bfa5  guibg=#202020  gui=underline  ctermfg=lightgray  ctermbg=black  cterm=underline
hi LineNr       guifg=#928c75  ctermfg=darkgray
hi Directory    guifg=#00bbdd  ctermfg=cyan
hi NonText      guifg=#77ff22  gui=bold  ctermfg=yellow  cterm=bold
hi SpecialKey   guifg=#559933  ctermfg=green
hi SpellBad     guifg=NONE     ctermfg=white   ctermbg=darkred
hi SpellCap     guifg=NONE     ctermfg=white   ctermbg=darkblue
hi SpellLocal   guifg=NONE     ctermfg=black   ctermbg=cyan
hi SpellRare    guifg=NONE     ctermfg=white   ctermbg=darkmagenta
hi DiffAdd      guifg=#ffa000  guibg=#002830   ctermfg=black   ctermbg=darkblue
hi DiffChange   guibg=#002830  ctermfg=black   ctermbg=darkblue
hi DiffDelete   guifg=#b0b0b0  guibg=#202020   gui=bold   ctermfg=cyan     ctermbg=black    cterm=bold
hi DiffText     guifg=#ffa000  guibg=#002830   gui=NONE   ctermfg=blue     ctermbg=gray     cterm=NONE

" borders / separators / menus

hi FoldColumn   guifg=#c8bcb9       guibg=#786d65       gui=bold   ctermfg=lightgray   ctermbg=darkgray cterm=bold
hi SignColumn   guifg=#c8bcb9       guibg=#786d65       gui=bold   ctermfg=lightgray   ctermbg=darkgray cterm=bold
hi Pmenu        guifg=#000000       guibg=#a6a190       ctermfg=white       ctermbg=darkgray
hi PmenuSel     guifg=#ffffff       guibg=#133293       ctermfg=white       ctermbg=lightblue
hi PmenuSbar    guifg=NONE          guibg=#555555       ctermfg=black       ctermbg=black
hi PmenuThumb   guifg=NONE          guibg=#cccccc       ctermfg=gray        ctermbg=gray
hi StatusLine   guifg=#222222       guibg=#c2bfa5       ctermfg=darkgray         ctermbg=yellow
hi StatusLineNC guifg=#111111       guibg=#c2bfa5       ctermfg=darkgray         ctermbg=gray
hi WildMenu     guifg=#ffffff       guibg=#133293       gui=bold ctermfg=white       ctermbg=darkblue    cterm=bold
hi VertSplit    guifg=#c2bfa5       guibg=#c2bfa5       ctermfg=white       ctermbg=white
hi TabLine      guifg=#000000       guibg=#c2bfa5       ctermfg=black       ctermbg=white
hi TabLineFill  guifg=#000000       guibg=#c2bfa5       ctermfg=black       ctermbg=white
hi TabLineSel   guifg=#ffffff       guibg=#133293       ctermfg=white       ctermbg=black

"hi Menu
"hi Scrollbar
"hi Tooltip

" cursor / dynamic / other

hi Cursor       guifg=#000000       guibg=#ffff99       ctermfg=black       ctermbg=white
hi CursorIM     guifg=#000000       guibg=#aaccff       ctermfg=black       ctermbg=white       cterm=reverse
hi CursorLine   guifg=NONE          guibg=#1b1b1b
hi CursorColumn guifg=NONE          guibg=#1b1b1b
hi Visual       guibg=#003040       ctermbg=lightblue
hi Search       guibg=#0080ff       ctermbg=lightblue
"hi IncSearch
hi MatchParen   guifg=NONE          guibg=#3377aa       ctermfg=white       ctermbg=blue
"hi VisualNOS

" listings / messages

hi ModeMsg      guifg=#eecc18      ctermfg=yellow
hi Title        guifg=#dd4452      gui=bold   ctermfg=red                 cterm=bold
hi Question     guifg=#66d077      ctermfg=green
hi MoreMsg      guifg=#39d049      ctermfg=green
hi ErrorMsg     guifg=#ffffff      guibg=#ff0000       gui=bold   ctermfg=white       ctermbg=red         cterm=bold
hi WarningMsg   guifg=#ccae22      gui=bold    ctermfg=yellow              cterm=bold


" syntax highlighting groups (:help group-name)

hi Comment      guifg=#b0b010  ctermfg=brown
hi Constant     guifg=#00ff20  ctermfg=green
hi Number       guifg=#00ff20  ctermfg=green
hi Keyword      guifg=#ffffff  ctermfg=white
hi Statement    guifg=#ffffff  ctermfg=white  gui=bold  cterm=bold
hi StorageClass guifg=#b0ffb0  ctermfg=lightgreen  gui=bold  cterm=bold
hi Structure    guifg=#b0ffb0  ctermfg=lightgreen  gui=bold  cterm=bold
hi Type         guifg=#ffffff  ctermfg=white  gui=NONE cterm=NONE
hi Identifier   guifg=#ffffff  ctermfg=white  gui=NONE cterm=NONE
hi Operator     guifg=#ffffff  ctermfg=white
hi Delimiter    guifg=#ffffff  ctermfg=white
hi PreProc      guifg=#00b000  ctermfg=darkgreen
hi Macro        guifg=#00b000  ctermfg=darkgreen
hi Todo         guifg=#ffffff  ctermfg=black  guibg=#ee7700  ctermbg=yellow  gui=bold  cterm=bold
hi Error        guifg=#ffffff  ctermfg=white  guibg=#ff0000  ctermbg=red
hi Special      guifg=#ffff00  ctermfg=yellow
hi Function     guifg=#20c0ff  ctermfg=lightblue
hi Underlined   guifg=#80a0ff  cterm=underline  gui=underline  cterm=underline
hi Ignore       guifg=#888888  ctermfg=darkgray


let &cpo = save_cpo
