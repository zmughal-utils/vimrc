" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @GIT:         http://github.com/tomtom/stakeholders_vim
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2010-11-19.
" @Last Change: 2012-10-23.
" @Revision:    11
" GetLatestVimScripts: 3326 0 :AutoInstall: stakeholders.vim

if &cp || exists("loaded_stakeholders")
    finish
endif
let loaded_stakeholders = 3

let s:save_cpo = &cpo
set cpo&vim


" :display: :StakeholdersEnable[!]
" Enable stakeholders for the current buffer.
" With the optional '!', enable stakeholders globally.
command! -bang StakeholdersEnable
            \ if empty("<bang>")
            \ | call stakeholders#EnableBuffer()
            \ | else
            \ | call stakeholders#Enable()
            \ | endif


" :display: :StakeholdersDisable[!]
" Disable stakeholders for the current buffer.
" With the optional '!', disable stakeholders globally.
command! -bang StakeholdersDisable
            \ if empty("<bang>")
            \ | call stakeholders#DisableBuffer()
            \ | else
            \ | call stakeholders#Disable()
            \ | endif


let &cpo = s:save_cpo
unlet s:save_cpo
