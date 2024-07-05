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
  let g:poslist_min_save_unit = 0
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
