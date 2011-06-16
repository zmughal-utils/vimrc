if exists("*strftime")
	if has("win32")
		let strftime_iso_fmt="%Y-%m-%d"
		let strftime_time_fmt="%H:%M:%S"
	else
		let strftime_iso_fmt="%F"
		let strftime_time_fmt="%T"
	endif
	let strftime_isotime_fmt=strftime_iso_fmt." ".strftime_time_fmt
	inoreabbr xdate	<C-R>=strftime("%a %Y %b %d")<CR>
	inoreabbr xiso	<C-R>=strftime(strftime_iso_fmt)<CR>
	inoreabbr xtime	<C-R>=strftime(strftime_time_fmt)<CR>
	inoreabbr xfulltd	<C-R>=strftime(strftime_isotime_fmt)<CR>
	inoreabbr xfiletd	<C-R>=strftime(strftime_isotime_fmt,getftime(expand('%')))<CR>
endif
