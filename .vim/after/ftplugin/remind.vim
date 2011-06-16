setlocal isfname+=],[,(,),34
"setlocal include=\\c^\\s*include\\s\\+\\zs\\(\\f\\\|[()\\[\\]\"]\\)\\+
setlocal include=\\c^\\s*include
setlocal includeexpr=substitute(system(\"remind\ -k\'echo\ -n\ %s\'\ -\",v:fname),'\ $','','')
