"=============================================================================
" FILE: poslist.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" Last Modified: 18 Dec 2009
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

let s:save_pos = [ getpos('.') ]
let s:current_pos_number = 0
function! s:save_current_pos()
    let l:pos = getpos('.')
    if l:pos != s:save_pos[s:current_pos_number]
        " Browser like history.
        if 0 < s:current_pos_number
            unlet s:save_pos[: s:current_pos_number - 1]
            let s:current_pos_number = 0
        endif

        call insert(s:save_pos, l:pos)
        if len(s:save_pos) > g:poslist_history
            " Delete old pos.
            unlet s:save_pos[g:poslist_history :]
        endif
        let s:current_pos_number = 0
    endif
endfunction
function! s:move_to_prev_pos()
    if s:current_pos_number+1 < len(s:save_pos)
        let s:current_pos_number += 1
        call setpos('.', s:save_pos[s:current_pos_number])
    endif
endfunction
function! s:move_to_next_pos()
    if s:current_pos_number > 0
        let s:current_pos_number -= 1
        call setpos('.', s:save_pos[s:current_pos_number])
    endif
endfunction

noremap <silent> <Plug>(poslist_prev) :<C-u>call <SID>move_to_prev_pos()<CR>
noremap <silent> <Plug>(poslist_next) :<C-u>call <SID>move_to_next_pos()<CR>

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_poslist = 1

" vim: foldmethod=marker
