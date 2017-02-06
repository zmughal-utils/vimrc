" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2010-11-02.
" @Last Change: 2012-10-23.
" @Revision:    782


if !exists('g:stakeholders#def')
    " The placeholder definition. A dictionary with the fields:
    "   rx ....... A |regexp| that matches placeholders.
    let g:stakeholders#def = {'rx': '<+\([[:alnum:]_]\+\)\(/.\{-}\)\?+>'}   "{{{2
endif


if !exists('g:stakeholders#expansion')
    " The type of placeholder expansion. Possible values:
    "   - delayed (see |stakeholders#delayed#Init()|)
    "   - immediate (see |stakeholders#immediate#Init()|)
    let g:stakeholders#expansion = 'immediate'   "{{{2
endif


if !exists('g:stakeholders#exclude_rx')
    " Ignore placeholders with labels matching this |regexp|.
    let g:stakeholders#exclude_rx = '^\(TODO\|\)$'   "{{{2
endif


if !exists('g:stakeholders#undo_breaks')
    " If non-null, break the undo sequence (see |i_CTRL-G_u|) before 
    " updating the replacement string.
    let g:stakeholders#undo_breaks = 0   "{{{2
endif




if !has_key(g:stakeholders#def, 'Replace')
    " :nodoc:
    function! g:stakeholders#def.Replace(text) dict "{{{3
        return substitute(a:text, self.placeholder_rx, escape(self.replacement, '\&~'), 'g')
    endf
endif


if !has_key(g:stakeholders#def, 'ReplacePlaceholderInCurrentLine')
    " :nodoc:
    function! g:stakeholders#def.ReplacePlaceholderInCurrentLine(pos, line, rline) dict "{{{3
        let m = matchlist(a:rline, printf(self.prepost_rx_fmt, self.replacement))
        " TLogVAR m
        if empty(m)
            let n1 = len(self.pre)
            echom "Internal error stakeholders#def.ReplacePlaceholderInCurrentLine:" a:rline self.prepost_rx_fmt
        else
            let n1 = len(m[1])
        endif
        let pre = self.Replace(self.pre)
        let n2 = len(pre)
        let post = self.Replace(self.post)
        let line1 = pre . self.replacement . post
        " echom "DBG End" n1 n2 pre
        let pos = copy(a:pos)
        if n1 != n2
            let delta = - n1 + n2
            let pos[2] += delta
        endif
        return [pos, line1]
    endf
endif


let s:enable_globally = 0

function! stakeholders#Disable() "{{{3
    if exists('#stakeholders')
        au! stakeholders
        aug! stakeholders
        let view = winsaveview()
        try
            silent windo unlet! w:stakeholders
            silent bufdo unlet! b:stakeholders
        finally
            call winrestview(view)
        endtry
    endif
    let s:enable_globally = 0
endf


function! stakeholders#Enable() "{{{3
    if !s:enable_globally
        if !exists('#stakeholders')
            augroup stakeholders
                autocmd!
            augroup END
        endif
        autocmd stakeholders BufNewFile,BufReadPost * call stakeholders#EnableBuffer()
        let view = winsaveview()
        try
            silent bufdo call stakeholders#EnableBuffer()
        finally
            call winrestview(view)
        endtry
        let s:enable_globally = 1
    endif
endf


" Enable stakeholders for a range of lines.
function! stakeholders#EnableInRange(line1, line2) "{{{3
    if !exists('b:stakeholders')
        let b:stakeholders_range = [a:line1, a:line2]
        " echom "DBG stakeholders#EnableInRange" string(b:stakeholders_range)
        call stakeholders#EnableBuffer()
    endif
endf


" Enable stakeholders for the current buffer.
function! stakeholders#EnableBuffer() "{{{3
    if !exists('#stakeholders')
        augroup stakeholders
            autocmd!
        augroup END
    endif
    if !exists('b:stakeholders')
        let b:stakeholders = exists('b:stakeholders_def') ? 
                    \ b:stakeholders_def : g:stakeholders#def
        " echom "DBG stakeholders#EnableBuffer" b:stakeholders
        autocmd stakeholders CursorMoved,CursorMovedI <buffer> call stakeholders#CursorMoved(mode())
        " autocmd stakeholders InsertEnter,InsertLeave <buffer> call stakeholders#CursorMoved(mode())
        call stakeholders#CursorMoved('n')
    endif
endf


" Disable stakeholders for the current buffer.
function! stakeholders#DisableBuffer() "{{{3
    if exists('b:stakeholders')
        unlet! b:stakeholders b:stakeholders_range w:stakeholders
        autocmd! stakeholders CursorMoved,CursorMovedI <buffer>
    endif
endf


function! s:SetContext(pos, mode) "{{{3
    if !exists('b:stakeholders')
        return a:pos
    endif
    let pos = a:pos
    if exists('w:stakeholders.End')
        let pos = w:stakeholders.End(pos)
    endif
    " TLogVAR pos
    let lnum = pos[1]
    if exists('b:stakeholders_range')
                \ && (lnum < b:stakeholders_range[0]
                \ || lnum > b:stakeholders_range[1])
        call stakeholders#DisableBuffer()
    else
        let w:stakeholders = copy(b:stakeholders)
        let w:stakeholders.lnum = lnum
        let line = getline(lnum)
        if line !~ w:stakeholders.rx
            let w:stakeholders.line = ''
        else
            let w:stakeholders.line = line
            " TLogVAR a:mode, mode()
            let col = s:Col(pos[2], a:mode)
            call s:SetParts(w:stakeholders, line, col)
        endif
        " TLogVAR w:stakeholders
    endif
    return pos
endf


function! s:SetParts(ph_def, line, col) "{{{3
    " function! stakeholders#SetParts(ph_def, line, col) "{{{3
    " TLogVAR a:col
    let a:ph_def.pre = ''
    let parts = split(a:line, w:stakeholders.rx .'\zs')
    let c = 0
    for i in range(len(parts))
        let part = parts[i]
        let plen = c + len(part)
        " TLogVAR plen
        if plen < a:col
            let a:ph_def.pre .= part
            let c = plen
        else
            let phbeg = match(part, w:stakeholders.rx .'$')
            if phbeg != -1
                let pre = strpart(part, 0, phbeg)
                let prelen = c + len(pre)
                " TLogVAR prelen
                if prelen <= a:col
                    let a:ph_def.pre .= pre
                    let placeholder = strpart(part, phbeg)
                    let placeholder = substitute(placeholder, '^<+[^/]*\zs/.\{-}\ze+>$', '', '')
                    let a:ph_def.placeholder = placeholder
                    let a:ph_def.post = join(parts[i + 1 : -1], '')
                    " TLogVAR a:ph_def
                    break
                endif
            endif
            " let a:ph_def.pre .= join(parts[i : -1], '')
            " TLogVAR a:ph_def
            break
        endif
    endfor
    return a:ph_def
endf


function! s:Col(col, mode) "{{{3
    " TLogVAR a:col, a:mode
    let col = a:col
    if a:mode == 'n' " && col < len(getline(a:pos[1]))
        let col -= 1
    elseif a:mode =~ '^[sv]' && &selection[0] == 'e'
        let col -= 1
    endif
    " TLogVAR col
    return col
endf


function! stakeholders#CursorMoved(mode) "{{{3
    let pos = getpos('.')
    " TLogVAR a:mode, pos
    try
        let lnum = pos[1]
        if exists('w:stakeholders.placeholder') && !empty(w:stakeholders.line) && w:stakeholders.lnum == lnum
            " TLogVAR w:stakeholders.placeholder
            let line = getline(lnum)
            " TLogVAR line
            if line != w:stakeholders.line
                let pre0 = w:stakeholders.pre
                let post0 = w:stakeholders.post
                let init = !has_key(w:stakeholders, 'replacement')
                if !init
                    let pre0 = w:stakeholders.Replace(pre0)
                    let post0 = w:stakeholders.Replace(post0)
                endif
                " TLogVAR pre0, post0
                let lpre = len(pre0)
                let lpost = len(line) - len(post0)
                let cpre = s:Col(lpre, a:mode) + 1
                let cpost = s:Col(lpost, a:mode) + 1
                let col = s:Col(pos[2], a:mode)
                " TLogVAR col, cpre, cpost
                if col >= cpre && col <= cpost
                    let spre = strpart(line, 0, lpre)
                    let spost = line[lpost : -1]
                    " TLogVAR pre0, post0
                    " TLogVAR spre, spost
                    if spre == pre0 && (empty(spost) || spost == post0)
                        let replacement = line[lpre : lpost - 1]
                        let placeholder = replacement[-len(w:stakeholders.placeholder) : -1]
                        " TLogVAR replacement, placeholder, w:stakeholders.placeholder
                        if !init || placeholder != w:stakeholders.placeholder
                            if init
                                call s:Init(w:stakeholders, pos)
                            endif
                            let w:stakeholders.replacement = replacement
                            if g:stakeholders#undo_breaks && a:mode == 'i'
                                call feedkeys("\<c-g>u")
                            endif
                            " TLogVAR w:stakeholders.replacement
                            if exists('w:stakeholders.Update')
                                let pos = w:stakeholders.Update(pos)
                            endif
                            return
                        endif
                    endif
                endif
            endif
        endif
        let pos = s:SetContext(pos, a:mode)
    finally
        call setpos('.', pos)
    endtry
endf


function! s:Init(ph_def, pos) "{{{3
    let a:ph_def.lnum = a:pos[1]
    " TLogVAR getline(a:ph_def.lnum)
    let a:ph_def.lines = {}
    let a:ph_def.placeholder_rx = '\V'. escape(a:ph_def.placeholder, '\')
    let pre_fmt = substitute(a:ph_def.pre, '%', '%%', 'g')
    let post_fmt = substitute(a:ph_def.post, '%', '%%', 'g')
    let a:ph_def.prepost_rx_fmt = '\V\^\('
                \ . substitute(pre_fmt, a:ph_def.placeholder_rx, '\\(\\.\\{-}\\)', 'g')
                \ .'\)%s\('
                \ . substitute(post_fmt, a:ph_def.placeholder_rx, '\\(\\.\\{-}\\)', 'g')
                \ .'\)\$'
    " TLogVAR a:ph_def
    if exists('b:stakeholders_range')
        let llnum = line('$')
        let range = join(map(copy(b:stakeholders_range), 'min([v:val, llnum])'), ',')
    else
        let range = ''
    endif
    try
        exec 'silent! keepjumps' range .'g/'. escape(a:ph_def.placeholder_rx, '/') .'/let a:ph_def.lines[line(".")] = getline(".")'
    finally
        keepjumps call setpos('.', a:pos)
    endtry
    call stakeholders#{g:stakeholders#expansion}#Init(a:ph_def)
endf


finish

n1: foo <+FOO+> bar
n2: foo <+FOO+> bar bla <+FOO+> bla
<+FOO+> bar bla <+FOO+>
foo <+FOO+> bar bla <+FOO+>

