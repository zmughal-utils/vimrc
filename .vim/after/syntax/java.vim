" Vim syntax file
" Language:	Java

" TODO	make good foldtext
" 	fold inner classes
" :help fold-foldtext
syntax region javaFold start="{" end="}" transparent fold
"syntax region javaFold start="^\s\+\(\(public\|protected\|private\|static\|abstract\|final\|native\|synchronized\)\_s\+\)*\(\(class\|void\|boolean\|char\|byte\|short\|int\|long\|float\|double\|\([A-Za-z_][A-Za-z0-9_$]*\.\)*[A-Z][A-Za-z0-9_$]*\)\(<[^>]*>\)\=\(\[\]\)*\s\+[a-z][A-Za-z0-9_$]*\|[A-Z][A-Za-z0-9_$]*\)\_s*{" end="}" transparent fold
syntax region javaCommentFold start="/\*" end="\*/" transparent fold keepend

" TODO get this to work better
" from VIM tip #304
" "\<import\(\s\+static\>\)\?"
syntax keyword javaExternal native package
"syntax region javaImportFold start=/\(^\s*\n^import\)\@<= .\+;/ end=^\s*$+ transparent fold keepend
"syntax region javaImportFold start="^\s*\(import\)\s*.\+" skip="^\s*\(import\)\s*.\+\n" end="^\s*[^import]*" transparent fold
syntax region javaImportFold start=/\(^\s*import.*\n\)\@<!\zs\(\_^\s*import\s\+.*;\)/ end=/\ze\_^\(import.*\n\)\@!.*$/ transparent fold keepend
 "skip=/\(\_^\s*import\s\+.*;\)/
syntax region javaCommentLineFold start=+\(^\s*//.*\n\)\@<!\zs\(\_^\s*//.*\)+ end=+\ze\_^\(\s*//.*\n\)\@!.*$+ transparent fold

"syntax region texComment	start="^\zs\s*%.*\_s*%"	skip="^\s*%"	end='^\ze\s*[^%]' fold
"syntax region javaImportFold start="\s*\n\@<!\zs\(^\s*\(import\)\s\+.\+\s*\)" skip="\(^\s*\(import\)\s\+.\+\s*\)" end="\(^\s*\(import\)\s\+.\+\s*\n\)" fold transparent keepend
" syntax region javaImportFold start="\(^\s*\(import\)\s\+.\+\s*\)" end="\(^\s*\(import\)\s\+.\+\s*\n\)\@!" fold transparent keepend
"
"end='^\ze\s*[^\(import\)]*
"syntax region javaImportFold start="^\zs\(\s*\(import\)\s\+.\+\_s*\(import\)\@=\)" skip="^\s*\(import\)" end="\ze\(\s*\(import\).\+\)\@!" fold transparent keepend
"
"let s:importline="\\s*\\(import\\)\\s\\+.\\+"
"let s:importfold=""
"let s:importfold="syntax region javaImportFold start=\""."\\(".javaImportFold."\\)"
"			\ "skip=\""
"			\ " fold transparent keepend"
"let s:importfold="syntax region javaImportFold start=\""."\\(".s:importline."\\n\\)\\@<!\\zs".s:importline."\"".
"			\ " skip=\"".s:importline."\""." end=\""."\\ze\\(".s:importline."\\)\@!\"".
"			\ " fold transparent keepend"
"echo s:importfold
"execute s:importfold

" syn region texComment	start="^\zs\s*%.*\_s*%"	skip="^\s*%"	end='^\ze\s*[^%]' fold

" Same as the g:java_no_trail_space_error but the other way around.
syntax match javaSpaceError "\t \+"ms=s+1

syntax keyword javablack	black
syntax keyword javaBLACK	BLACK
syntax keyword javablue		blue
syntax keyword javaBLUE		BLUE
syntax keyword javacyan		cyan
syntax keyword javaCYAN		CYAN
syntax keyword javaDARK_GRAY	DARK_GRAY
syntax keyword javadarkGray	darkGray
syntax keyword javagray		gray
syntax keyword javaGRAY		GRAY
syntax keyword javagreen	green
syntax keyword javaGREEN	GREEN
syntax keyword javaLIGHT_GRAY	LIGHT_GRAY
syntax keyword javalightGray	lightGray
syntax keyword javamagenta	magenta
syntax keyword javaMAGENTA	MAGENTA
syntax keyword javaorange	orange
syntax keyword javaORANGE	ORANGE
syntax keyword javapink		pink
syntax keyword javaPINK		PINK
syntax keyword javared		red
syntax keyword javaRED		RED
syntax keyword javawhite	white
syntax keyword javaWHITE	WHITE
syntax keyword javayellow	yellow
syntax keyword javaYELLOW	YELLOW

syntax cluster javaTop add=javablack,javaBLACK
syntax cluster javaTop add=javablue,javaBLUE
syntax cluster javaTop add=javacyan,javaCYAN
syntax cluster javaTop add=javaDARK_GRAY,javadarkGray
syntax cluster javaTop add=javagray,javaGRAY
syntax cluster javaTop add=javagreen,javaGREEN
syntax cluster javaTop add=javaLIGHT_GRAY,javalightGray
syntax cluster javaTop add=javamagenta,javaMAGENTA
syntax cluster javaTop add=javaorange,javaORANGE
syntax cluster javaTop add=javapink,javaPINK
syntax cluster javaTop add=javared,javaRED
syntax cluster javaTop add=javawhite,javaWHITE
syntax cluster javaTop add=javayellow,javaYELLOW

" TODO make a guibg for every color so it contrasts well
highlight javablack								guifg=#000000
highlight javaBLACK								guifg=#000000
highlight javablue								guifg=#0000FF
highlight javaBLUE								guifg=#0000FF
highlight javacyan								guifg=#00FFFF
highlight javaCYAN								guifg=#00FFFF
highlight javaDARK_GRAY								guifg=#404040
highlight javadarkGray								guifg=#404040
highlight javagray								guifg=#808080
highlight javaGRAY								guifg=#808080
highlight javagreen								guifg=#00FF00
highlight javaGREEN								guifg=#00FF00
highlight javaLIGHT_GRAY							guifg=#C0C0C0
highlight javalightGray								guifg=#C0C0C0
highlight javamagenta								guifg=#FF00FF
highlight javaMAGENTA								guifg=#FF00FF
highlight javaorange								guifg=#FFC800
highlight javaORANGE								guifg=#FFC800
highlight javapink								guifg=#FFAFAF
highlight javaPINK								guifg=#FFAFAF
highlight javared								guifg=#FF0000
highlight javaRED								guifg=#FF0000
highlight javawhite								guifg=#FFFFFF
highlight javaWHITE								guifg=#FFFFFF
highlight javayellow								guifg=#FFFF00
highlight javaYELLOW								guifg=#FFFF00

" This should be added. V
highlight link javaC_ Class

syntax sync fromstart
