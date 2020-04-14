if exists("perl_inline_c")
	if exists("b:current_syntax")
		unlet b:current_syntax
	endif
	syn include @InlineC syntax/c.vim
	if exists("perl_fold")
		syn region perlInline start="^__C__$" skip="." end="." contains=@InlineC contained fold
	else
		syn region perlInline start="^__C__$" skip="." end="." contains=@InlineC contained
	endif

	if exists("b:current_syntax")
		unlet b:current_syntax
	endif
	syn include @InlineCPP syntax/cpp.vim
	if exists("perl_fold")
		syn region perlInline start="^__CPP__$" skip="." end="." contains=@InlineCPP contained fold
	else
		syn region perlInline start="^__CPP__$" skip="." end="." contains=@InlineCPP contained
	endif

	"==== modified from $VIMRUNTIME/syntax/perl.vim ====
	" __END__ and __DATA__ clauses
	if exists("perl_fold")
		syntax region perlDATA		start="^__DATA__$" skip="." end="." contains=perlInline,perlPOD,@perlDATA fold
		syntax region perlDATA		start="^__END__$" skip="." end="."  contains=perlInline,perlPOD,@perlDATA fold
	else
		syntax region perlDATA		start="^__DATA__$" skip="." end="." contains=perlInline,perlPOD,@perlDATA
		syntax region perlDATA		start="^__END__$" skip="." end="."  contains=perlInline,perlPOD,@perlDATA
	endif
	" ==== END ====
endif
