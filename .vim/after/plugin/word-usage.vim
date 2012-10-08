highlight link WordUsageHomophone Exception
highlight link WordUsageError Error
autocmd BufEnter,WinEnter * call WordUsage()
function! WordUsage()
	call matchadd('WordUsageHomophone', "\c\\<\\(affect\\|effect\\)\\>")

	call matchadd('WordUsageHomophone', "\\c\\<\\(they're\\|their\\|there\\)\\>")

	call matchadd('WordUsageHomophone', "\\c\\<\\(you're\\|your\\)\\>")

	call matchadd('WordUsageHomophone', "\\c\\<\\(it's\\|its\\)\\>")

	call matchadd('WordUsageHomophone', "\\c\\<\\(we're\\|were\\|where\\)\\>")

	call matchadd('WordUsageHomophone', "\\c\\<\\(loose\\|lose\\)\\>")

	call matchadd('WordUsageHomophone', "\\c\\<\\(then\\|than\\)\\>")

	"match WordUsage could've
	call matchadd('WordUsageError', "\\c\\<could\\s\\+of\\>")
endfunction
