" immediate.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2010-11-05.
" @Last Change: 2010-11-19.
" @Revision:    37


let s:prototype = {} "{{{2

" Expand placeholders as the user types.
function! stakeholders#immediate#Init(ph_def) "{{{3
    call extend(a:ph_def, s:prototype)
    return a:ph_def
endf


" :nodoc:
function! s:prototype.Update(pos) dict "{{{3
    if a:pos[1] == line('.')
        let pos = a:pos
        for [lnum, line] in items(self.lines)
            if lnum == self.lnum
                let [pos, line1] = self.ReplacePlaceholderInCurrentLine(pos, self.line, getline(lnum))
            else
                let line1 = self.Replace(line)
            endif
            keepjumps call setline(lnum, line1)
        endfor
    endif
    return pos
endf


" " :nodoc:
" function! s:prototype.End(pos) dict "{{{3
"     unlet self.placeholder
"     return a:pos
" endf


