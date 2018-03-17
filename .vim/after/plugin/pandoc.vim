command! -nargs=0 -range=% PandocMtoL <line1>,<line2>!pandoc -t latex -f markdown <Bar> grep -v '\\itemsep1pt\\parskip0pt\\parsep0pt'
command! -nargs=0 -range=% PandocLtoM <line1>,<line2>!pandoc -t markdown -f latex
