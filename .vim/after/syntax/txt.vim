syn region txtDelims matchgroup=txtOperator start=/\\/ skip=/[^\\]/ end=/\\/ contains=@txtContains,@txtAlwaysContains oneline
syn sync minlines=50
