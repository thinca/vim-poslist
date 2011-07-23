" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" MODIFIED BY: thinca <thinca+vim@gmail.com>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}

let s:save_cpo = &cpo
set cpo&vim


function! poslist#save_current_pos()
  if !exists('w:poslist')
    let w:poslist = []
    let w:poslist_pos = 0
  endif

  let pos = getpos('.')
  let pos[0] = bufnr('%')
  if (empty(w:poslist) || (pos != w:poslist[w:poslist_pos] &&
        \ ((abs(pos[2] - w:poslist[w:poslist_pos][2]) >= g:poslist_min_save_unit
        \      && pos[1] == w:poslist[w:poslist_pos][1])
        \|| abs(pos[1] - w:poslist[w:poslist_pos][1]) >= g:poslist_min_save_unit)
        \ ))
    " Browser like history.
    if 0 < w:poslist_pos
      unlet w:poslist[: w:poslist_pos - 1]
    endif

    call insert(w:poslist, pos)
    if g:poslist_histsize < len(w:poslist)
      " Delete old pos.
      unlet w:poslist[g:poslist_histsize :]
    endif
    let w:poslist_pos = 0
  endif
endfunction

function! poslist#move_pos(c)
  call s:goto_pos(w:poslist_pos + a:c)
endfunction

function! poslist#move_line(c)
  " o o o o o o o o o o o  # cursor points
  "  s s l l s s s l l s   # s = short jump  l = long jump
  " .---.-.-.-----.-.-.-.  # stop points
  let c = abs(a:c)
  let sign = a:c < 0 ? -1 : 1
  let idx = w:poslist_pos
  let p = w:poslist[idx]
  let len = len(w:poslist)
  let short_jump = 0
  while 0 < c
    let prev = p
    let nidx = idx + sign
    if nidx < 0 || len <= nidx
      break
    endif
    let idx = nidx
    let p = w:poslist[idx]
    if p[0] != prev[0] || g:poslist_lines <= abs(p[1] - prev[1])
      if short_jump
        let short_jump = 0
        let c -= 1
      endif
      let c -= 1
    else
      let short_jump = 1
    endif
  endwhile
  call s:goto_pos(idx + (c * sign))
endfunction

function! poslist#move_buf(c)
  let c = abs(a:c)
  let sign = a:c < 0 ? -1 : 1
  let posn = w:poslist_pos
  let buf = w:poslist[posn][0]
  let len = len(w:poslist)
  while c && 0 <= posn && posn < len
    if w:poslist[posn][0] != buf
      let buf = w:poslist[posn][0]
      let c -= 1
    endif
    let posn += sign
  endwhile
  call s:goto_pos(posn - sign)
endfunction

function! s:goto_pos(posn)
  let posn = max([0, min([len(w:poslist) - 1, a:posn])])
  if w:poslist_pos == posn
    return
  endif
  let pos = w:poslist[posn]
  if bufnr('%') != pos[0]
    try
      execute pos[0] 'buffer'
    catch
      echohl ErrorMsg
      echomsg matchstr(v:exception, '^.\{-}:\zsE\d\+:.*$')
      echohl None
      return
    endtry
  endif
  let w:poslist_pos = posn
  call setpos('.', pos)
endfunction


let &cpo = s:save_cpo
