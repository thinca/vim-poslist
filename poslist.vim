"=============================================================================
" FILE: poslist.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" MODIFIED BY: thinca <thinca@gmail.com>
" Last Modified: 21 Dec 2009
" Usage: Just source this file.
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
" Version: 1.00, for Vim 7.0
"-----------------------------------------------------------------------------
" ChangeLog: "{{{
"   1.00: Initial version.
" }}}
"=============================================================================

if exists('g:loaded_poslist')
    finish
endif

let s:save_cpo = &cpo
set cpo&vim

augroup poslist
    autocmd!
    autocmd CursorMoved * call s:save_current_pos()
augroup END

if !exists('g:poslist_history')
    let g:poslist_history = 50
endif

function! s:init()
    if !exists('w:poslist')
        let w:poslist = [ getpos('.') ]
        let w:poslist_pos = 0
    endif
endfunction

function! s:save_current_pos()
    call s:init()
    let l:pos = getpos('.')
    if l:pos != w:poslist[w:poslist_pos]
        " Browser like history.
        if 0 < w:poslist_pos
            unlet w:poslist[: w:poslist_pos - 1]
        endif

        call insert(w:poslist, l:pos)
        if len(w:poslist) > g:poslist_history
            " Delete old pos.
            unlet w:poslist[g:poslist_history :]
        endif
        let w:poslist_pos = 0
    endif
endfunction

function! s:move_pos(c)
    call s:init()
    let newpos = w:poslist_pos + a:c
    if newpos < 0
        let newpos = 0
    elseif len(w:poslist) <= newpos
        let newpos = len(w:poslist) - 1
    endif
    if w:poslist_pos != newpos
        let w:poslist_pos = newpos
        call setpos('.', w:poslist[w:poslist_pos])
    endif
endfunction

noremap <silent> <Plug>(poslist_prev) :<C-u>call <SID>move_pos(v:count1)<CR>
noremap <silent> <Plug>(poslist_next) :<C-u>call <SID>move_pos(-v:count1)<CR>

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_poslist = 1

" vim: foldmethod=marker