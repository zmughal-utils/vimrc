inoreabbr xid	<C-R>=system("perl -MData::UUID -E 'print \"<uuid:@{[Data::UUID->new->create_b64]}>\"'")<CR>
