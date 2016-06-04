syntax match gitcommitCIDirective "\[ci skip\]"
syntax match gitcommitCIDirectiveFirst "\[ci skip\]" contained containedin=gitcommitSummary

highlight link gitcommitCIDirective Special
highlight link gitcommitCIDirectiveFirst Special
