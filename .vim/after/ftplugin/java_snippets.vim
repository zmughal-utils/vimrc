if !exists('loaded_snippet') || &cp
    finish
endif
	
let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

"exec "Snippet for for( ".st.et." ".st."i".et." = ".st.et."; ".st."i".et." < ".st."count".et."; ".st."i".et." += ".st.et.")<CR>{<CR>".st.et."<CR>}".st.et

exec "Snippet main public static void main(String[] args)<CR>{<CR>".st.et."<CR>}"

exec "Snippet fori for(".st.et." ".st."i".et."=".st.et.";".st."i".et."<".st."count".et.";".st."i".et."+=".st.et.")<CR>{<CR>".st.et."<CR>}".st.et
exec "Snippet forarr for(int ".st."i".et."=0;".st."i".et."<".st."arr".et.".length;".st."i".et."++)<CR>{<CR>".st.et."<CR>}".st.et
exec "Snippet forstr for(int ".st."i".et."=0;".st."i".et."<".st."str".et.".length();".st."i".et."++)<CR>{<CR>".st.et."<CR>}".st.et

"exec "Snippet forarr for(int ".st."i".et."=0;".st."i".et."<".st."arr".et.".length;".st."i".et."++)<CR>{<CR>".st.et."<CR>}".st.et
exec "Snippet sop System.out.println(".st.et.");".st.et
exec 'Snippet sopf System.out.printf("%'.st.'format'.et.'\n",'.st.'args'.et.');'.st.et
exec 'Snippet printarr for(int '.st.'i'.et.'=0;'.st.'i'.et.'<'.st.'arr'.et.'.length;'.st.'i'.et.'++)<CR>'.
				\'System.out.println('.st.'arr'.et.'['.st.'i'.et.']);<CR>'.
			\st.et
exec 'Snippet printarr2 for(int '.st.'i'.et.'=0;'.st.'i'.et.'<'.st.'arr'.et.'.length;'.st.'i'.et.'++)<CR>'.
			\'{<CR>'.
				\'for(int '.st.'j'.et.'=0;'.st.'j'.et.'<'.st.'arr'.et.'['.st.'i'.et.'].length;'.st.'j'.et.'++)<CR>'.
					\'System.out.printf("%'.st.'format'.et.'",'.st.'arr'.et.'['.st.'i'.et.']['.st.'j'.et.']);<CR>'.
				\'System.out.println();<CR>'.
			\'}'.st.et
