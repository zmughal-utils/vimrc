" C++
autocmd QuickFixCmdPost <buffer> call AutoOpenQF(0)
compiler gcc
call PreviewMaps()

if !filereadable('Makefile')
if has("win32") | let exeext=".exe" | else | let exeext="" | endif
	exe 'setlocal makeprg=g++\ -o\ %:r'.exeext.'\ %\ -Wall'
endif
