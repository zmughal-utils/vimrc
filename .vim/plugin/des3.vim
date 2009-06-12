" des3.vim
" version 1.1
" 2007 Noah Spurrier <noah@noah.org>
"
" == Edit des3 encrypted files ==
"
" This will allow editing of des3 encrypted files.
" The file must have .des3 extension
" The openssl command line tool must be in the path.
" This will turn off the swap file and .viminfo log.
"
" == Install ==
"
" Put this in your plugin directory and Vim will automatically load it:
"    ~/.vim/plugin/des3.vim
" You can also source it directly from your .vimrc file:
"    source des3.vim
"
" You can start by editing an empty unencrypted file with a .des3 extension.
" When you first write the file you will be asked to give it a password.
"
" == Simple password safe ==
"
" If you edit any file named .auth.des3 (full name, not just the extension)
" then this plugin will add folding features and an automatic quit timeout.
"
" Vim will quit automatically after 5 minutes of no typing activity
" (unless the file has been changed).
"
" This plugin will fold on wiki-style headlines with the following form:
"     == This is a headline ==
" Any notes under the headline will be inside the fold until
" the next headline is reached. 
" The SPACE key will toggle a fold open and closed. The q key will quit Vim.
" Create the following example file named ~/.auth.des3:
"     == Colo server ==
"     username: maryjane
"     password: esydpm
"     == Office server ==
"     username: peter
"     password: 4m4z1ng
" Then create a bash alias:
"     alias auth='view ~/.auth.des3'
" Now you can view your password safe by typing "auth".
" When Vim starts all the password information will be hidden under
" the headlines. To view the password information put the cursor on
" the headline and press SPACE.
"
" Thanks to Tom Purl for the des3 tip.
"
" I release all copyright claims. This code is in the public domain.
" Permission is granted to use, copy modify, distribute, and sell this software
" for any purpose. I make no guarantee about the suitability of this software
" for any purpose and I am not liable for any damages resulting from its use.
" Further, I am under no obligation to maintain or extend this software.
" It is provided on an "as is" basis without any expressed or implied warranty.
"
augroup des3_encrypted
autocmd!
" don't use swap file or ~/.viminfo while editing
autocmd BufReadPre,FileReadPre     *.des3 set viminfo=
autocmd BufReadPre,FileReadPre     *.des3 set noswapfile
" filter the encrypted file through openssl after reading
autocmd BufReadPre,FileReadPre     *.des3 set bin
autocmd BufReadPre,FileReadPre     *.des3 set cmdheight=2
autocmd BufReadPre,FileReadPre     *.des3 set shell=/bin/sh
autocmd BufReadPost,FileReadPost   *.des3 0,$!openssl enc -d -des3 2> /dev/null
" switch back to nobin mode for editing
autocmd BufReadPost,FileReadPost   *.des3 set nobin
autocmd BufReadPost,FileReadPost   *.des3 set cmdheight&
autocmd BufReadPost,FileReadPost   *.des3 set shell&
autocmd BufReadPost,FileReadPost   *.des3 execute ":doautocmd BufReadPost ".expand("%:r")
" filter plain text through openssl before writing 
autocmd BufWritePre,FileWritePre   *.des3 set bin
autocmd BufWritePre,FileWritePre   *.des3 set cmdheight=2
autocmd BufWritePre,FileWritePre   *.des3 set shell=/bin/sh
autocmd BufWritePre,FileWritePre   *.des3 0,$!openssl enc -e -des3 -salt 2>/dev/null
" undo the encrypt step so we can continue editing after writing
autocmd BufWritePost,FileWritePost *.des3 silent u
autocmd BufWritePost,FileWritePost *.des3 set nobin
autocmd BufWritePost,FileWritePost *.des3 set cmdheight&
autocmd BufWritePost,FileWritePost *.des3 set shell&

" The following implements a simple password safe for any file named .auth.des3
" folding support for == headlines ==
function! HeadlineDelimiterExpression(lnum)
    if a:lnum == 1
        return ">1"
    endif
    return (getline(a:lnum)=~"^\\s*==.*==\\s*$") ? ">1" : "="
endfunction
autocmd BufReadPost,FileReadPost   .auth.des3 set foldexpr=HeadlineDelimiterExpression(v:lnum)
autocmd BufReadPost,FileReadPost   .auth.des3 set foldlevel=0
autocmd BufReadPost,FileReadPost   .auth.des3 set foldcolumn=0
autocmd BufReadPost,FileReadPost   .auth.des3 set foldmethod=expr
autocmd BufReadPost,FileReadPost   .auth.des3 set foldtext=getline(v:foldstart)
autocmd BufReadPost,FileReadPost   .auth.des3 nnoremap <silent><space> :exe 'silent! normal! za'.(foldlevel('.')?'':'l')<CR>
autocmd BufReadPost,FileReadPost   .auth.des3 nnoremap <silent>q :q<CR>
autocmd BufReadPost,FileReadPost   .auth.des3 highlight Folded ctermbg=red ctermfg=black
autocmd BufReadPost,FileReadPost   .auth.des3 set updatetime=300000
autocmd CursorHold                 .auth.des3 quit

augroup END

