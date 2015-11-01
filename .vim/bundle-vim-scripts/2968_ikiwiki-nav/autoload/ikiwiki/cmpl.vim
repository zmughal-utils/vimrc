" vim: fdm=marker
" {{{1 LICENSE
" Copyright: 2010 Javier Rojas <jerojasro@devnull.li>
"
" License:
" This program is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 2 of the License, or
" (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program.  If not, see <http://www.gnu.org/licenses/>.
"
" ftplugin to navigate ikiwiki links from within vim
"
" Author: Javier Rojas <jerojasro@devnull.li>
" Version:  2.0
" Last Updated: 2010-09-12
" URL: http://git.devnull.li/ikiwiki-nav.git/
"
" }}}1

" TODO see how does ikiwiki handle spaces in links, to define the policy to
" handle them here

"{{{1 find the initial point of the completion
"
" in other words, the position from which the omni-completion is allowed to
" modify the current line
"
" TODO unify the link search with the navigation part; both of them use the link
" extraction functionality
"
"}}}1
function! s:FindCplStart() " {{{1
  let cc = col('.')
  let haystack = getline('.')[:cc-1]
  let linktext_sep = '|'
  let li_sep_loc = strridx(haystack, linktext_sep, cc-strlen(linktext_sep))
  let link_str = '[['
  let li_loc = strridx(haystack, link_str, cc-strlen(link_str))
  if li_loc < li_sep_loc
    let li_loc = li_sep_loc
    let offset = strlen(linktext_sep)
  else
    let offset = strlen(link_str)
  endif
  if li_loc < 0
    return -1
  endif
  let link_end = ']]'
  let li_endloc = strridx(haystack, link_end, cc-strlen(link_end))
  if li_endloc > li_loc
    return -1
  endif
  let dir_str = '[[!'
  let di_loc = strridx(haystack, dir_str, col('.')-strlen(dir_str))
  if di_loc == li_loc
    return -1
  endif
  return li_loc + offset
endfunction " }}}1

function! s:IntersectPaths(p1, p2) " {{{1
  let i = 0
  let maxlen = min([strlen(a:p1), strlen(a:p2)])
  while i < maxlen && a:p1[i] == a:p2[i]
    let i = i + 1
  endwhile
  return strpart(a:p1, 0, i)
endfunction " }}}1

" {{{1 format a filename with its full path for proper presentation in the
" omnicomp menu
"
" all the leading path components up to, and not including base/partialpage*$
" are removed from the filename string
"
" Besides of that:
"
"   * if the filename is a ikiwiki page (.mdwn) its extension is stripped
"   * if the filename is a directory, a '/' is added
"   * otherwise, it is left untouched
"
" }}}1
function! s:FormatCmpl(fsname, base, partialpage) " {{{1
  let base = fnameescape(a:base)
  let partialpage = fnameescape(a:partialpage)
  let pat = '\c' . base . '/' . partialpage . '[^/]*$'
  if strlen(base) == 0
    let pat = '\c' . partialpage . '[^/]*$'
  endif
  " TODO index.mdwn case
  " this match is killing all the page/index.mdwn pages, because of the
  " partialpage matching. see how to handle
  "
  " see also how to avoid duplicates. e.g., if we offered a link to
  " personal, based on the personal/index.mdwn file, once we are in personal/, we
  " can't offer personal nor index as completion options
  let rv = {'word': matchstr(a:fsname, pat)}
  if isdirectory(a:fsname)
    let rv.word = rv.word . '/'
    let rv.menu = 'dir '
  elseif a:fsname =~? '\.mdwn$'
    let rv.word = fnamemodify(rv.word, ':r')
    let rv.menu = 'page'
  else
    let rv.menu = 'file'
  endif
  let bufdir = expand('%:p:h')
  let cmpldir = fnamemodify(a:fsname, ':h')
  let common_dir = s:IntersectPaths(bufdir, cmpldir)
  let rv.menu = rv.menu . " " . pathshorten(a:fsname)
  return rv
endfunction " }}}1

" {{{1 checks a list of files, and adds <pathname>/index.mdwn
" Intended to check which items of a given list are directories, and which of
" them contain a 'index.mdwn' file, to add those to the received list
" }}}1
function! s:AddIdxLinks(path_list) " {{{1
  let scratch = copy(a:path_list)
  let path_list = copy(a:path_list)
  for path in filter(scratch, 'isdirectory(v:val)')
    let path_pr = fnamemodify(path, ':h')
    let path_pag = fnamemodify(path, ':t')
    let pospage = ikiwiki#nav#BestLink2FName(path_pr, path_pag)
    if len(pospage) == 1 && strlen(pospage[0][1]) == 0 && strlen(pospage[0][2]) == 0
     \ && pospage[0][0] =~? 'index\.mdwn$'
      call add(path_list, pospage[0][0])
    endif
  endfor
  return path_list
endfunction " }}}1

" TODO add limits to the completion list size
function! ikiwiki#cmpl#IkiOmniCpl(findstart, base) " {{{1
  if a:findstart == 1
    let s:r = s:FindCplStart()
    return s:r
  endif
  if s:r < 0
    return []
  endif
  let completions = []
  let mrl = matchlist(a:base, '^\(\([^/]*/\)*\)\([^/]*\)$')
  let baselink = mrl[1]
  let wk_partialpage = mrl[3]
  let dirs_tocheck = ikiwiki#nav#GenPosLinkLoc(expand('%:p:h').'/'
                                     \ .fnameescape(expand('%:p:t:r')))
  if strlen(baselink) == 0
    for _path in dirs_tocheck
      call extend(completions,
                \ map(s:AddIdxLinks(split(glob(_path . '/'.wk_partialpage.'*'), "\n")),
                    \ 's:FormatCmpl(v:val, baselink, wk_partialpage)'))
    endfor
    return completions
  endif
  let baselink = strpart(baselink, 0, strlen(baselink) - 1) " strip last /
  for _path in dirs_tocheck
    let plinkloc = ikiwiki#nav#BestLink2FName(_path, baselink.'/dummy')
    let exs_dir = plinkloc[0][0]
    if strlen(exs_dir) != strlen(_path) + strlen(baselink) + 1
      continue
    endif
    call extend(completions,
              \ map(s:AddIdxLinks(split(glob(exs_dir . '/'.wk_partialpage.'*'), "\n")),
                  \ 's:FormatCmpl(v:val, baselink, wk_partialpage)'))
  endfor
  return completions
endfunction " }}}1

