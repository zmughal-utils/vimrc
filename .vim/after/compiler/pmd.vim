" Vim compiler file
" Compiler:     pmd

if exists("current_compiler")
  finish
endif
let current_compiler = "pmd"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=pmd\ .\ text\ rulesets/favorites.xml

CompilerSet errorformat=%f:%l\	%m
