" nibble.vim -- Nibble (or snake) game for Vim
" Author: Hari Krishna (hari_vim at yahoo dot com)
" Last Change: 30-Jan-2007 @ 09:16
" Created: 06-Feb-2004
" Version: 2.0.0
" Acknowledgements:
"   - Thanks to Bram Moolenaar (Bram at moolenaar dot net) for reporting
"     problems and giving feedback.
" Licence: This program is free software; you can redistribute it and/or
"          modify it under the terms of the GNU General Public License.
"          See http://www.gnu.org/copyleft/gpl.txt 
" Download From:
"     http://www.vim.org/script.php?script_id=916
" Description:
"   This is just a quick-loader for the Nibble game, see autoload/nibble.vim
"   for the actual code.
"
"   Use hjkl keys to move the snake. Use <Space> to pause and resume the play.
"   Use <C-C> to stop the play at any time.

command! -nargs=? Nibble :call <SID>Nibble(<args>)

function! s:Nibble(...)
  call nibble#Nibble()
endfunction

