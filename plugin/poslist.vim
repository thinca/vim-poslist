"=============================================================================
" FILE: poslist.vim
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
" Version: 1.02, for Vim 7.0
"-----------------------------------------------------------------------------
" ChangeLog: "{{{
"   1.03  2011-04-24
"       - autoload.
"
"   1.02  2010-07-21
"       - Added the jump unit that is the big movement.
"         - <Plug>(poslist-next-line)
"         - <Plug>(poslist-prev-line)
"         - g:poslist_lines
"
"   1.01  2010-05-10
"       - Fixed a bug that it moves to move of each buffer too much.
"       - Also jump to same buffer in move of each buffer.
"
"   1.00: Initial version.
" }}}
" TODO:
"  - Move in visual mode.
"=============================================================================

if exists('g:loaded_poslist')
  finish
endif
let g:loaded_poslist = 1

let s:save_cpo = &cpo
set cpo&vim

augroup plugin-poslist
  autocmd!
  autocmd WinEnter,CursorMoved * call poslist#save_current_pos()
augroup END

if !exists('g:poslist_histsize')
  let g:poslist_histsize = 50
endif

if !exists('g:poslist_lines')
  let g:poslist_lines = 2
endif

if !exists('g:poslist_min_save_unit')
  let g:poslist_min_save_unit = 5
endif


noremap <silent>
\ <Plug>(poslist-prev-pos)  :<C-u>call poslist#move_pos(v:count1)<CR>
noremap <silent>
\ <Plug>(poslist-next-pos)  :<C-u>call poslist#move_pos(-v:count1)<CR>
noremap <silent>
\ <Plug>(poslist-prev-line) :<C-u>call poslist#move_line(v:count1)<CR>
noremap <silent>
\ <Plug>(poslist-next-line) :<C-u>call poslist#move_line(-v:count1)<CR>
noremap <silent>
\ <Plug>(poslist-prev-buf)  :<C-u>call poslist#move_buf(v:count1)<CR>
noremap <silent>
\ <Plug>(poslist-next-buf)  :<C-u>call poslist#move_buf(-v:count1)<CR>


let &cpo = s:save_cpo
unlet s:save_cpo
