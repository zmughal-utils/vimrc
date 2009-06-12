" Vim color scheme
"
" Name:        norwaytoday.vim
" Maintainer:  Josh O'Rourke <jorourke23@gmail.com> 
" Last Change: 12 Jan 2009 
" License:     public domain
" Version:     0.5
"
" This theme is based on the Netbeans "Norway Today" theme.

set background=dark
hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "norwaytoday"

if has("gui_running")
  hi link htmlTag                     xmlTag
  hi link htmlTagName                 xmlTagName
  hi link htmlEndTag                  xmlEndTag

  highlight Normal                    guifg=#FFFFFF guibg=#121E31
  highlight Comment                   guifg=#428BDD gui=italic
  highlight Constant                  guifg=#B53B3C 
  highlight Cursor                    guibg=#EDDD3D
  highlight Error                     guifg=#FFFFFF guibg=#990000
  highlight Function                  guifg=#FFFFFF gui=italic
  highlight LineNr                    guifg=#FFFFFF guibg=#121E31
  highlight Number                    guifg=#EDDD3D
  highlight PreProc                   guifg=#F8BB00
  highlight Statement                 guifg=#F8BB00 
  highlight String                    guifg=#E2CE00
  highlight Type                      guifg=#8AA6C1
  highlight Visual                    guibg=#EDDD3D

  highlight rubyInstanceVariable      guifg=#EDDD3D gui=bold

  "highlight Include                   guifg=#990000
  "highlight Keyword                   guifg=#990000
  "highlight Define                    guifg=#990000
  "highlight Identifier                guifg=#990000
  "highlight Search                    guibg=#990000
  "highlight Title                     guifg=#990000
  "highlight DiffAdd                   guifg=#990000
  "highlight DiffDelete                guifg=#990000
  
  "highlight rubyClass                 guifg=#990000  
  "highlight rubyConstant              guifg=#990000 
  "highlight rubyBlockParameter        guifg=#990000 
  "highlight rubyInterpolation         guifg=#990000 
  "highlight rubyLocalVariableOrMethod guifg=#990000 
  "highlight rubyPredefinedConstant    guifg=#990000 
  "highlight rubyPseudoVariable        guifg=#990000 
  "highlight rubyStringDelimiter       guifg=#990000 
  
  highlight xmlTag                    guifg=#F8BB00
  highlight xmlTagName                guifg=#F8BB00
  highlight xmlEndTag                 guifg=#F8BB00
endif
