setl foldlevel=0
if executable("boxes")
	command! -nargs=0 -range VOobj		<line1>,<line2>!boxes -d vo-cmt -t 4k
	command! -nargs=0 -range VOobjRM	<line1>,<line2>!boxes -r -d vo-cmt -t 4u
else
	command! -nargs=0 -range VOobj		<line1>,<line2>!sed 's/^\(\s*\)\(\S\)/\1: \2/'| sed 's/^$/:/'
	command! -nargs=0 -range VOobjRM	<line1>,<line2>!sed 's/^\(\s*\):/\1/' | sed 's/^:$//'
endif
