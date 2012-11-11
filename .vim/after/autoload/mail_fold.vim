function mail_fold#MailLevel()
	let q = matchstr(getline(v:lnum), '^\(>\s*\)\+')
	if !empty(q)
		let q_brak = substitute(q, '[^>]', '','g')
		let q_brak_n = len(q_brak)
		echo q_brak_n
		return q_brak_n
	endif
	return "="
endfunction
