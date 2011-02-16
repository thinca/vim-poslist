" unite source: poslist
" Version: 0.1.0
" Author : thinca <thinca+vim@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

let s:save_cpo = &cpo
set cpo&vim

let s:source = {
\   'name': 'poslist',
\   'hooks': {},
\}

function! s:source.hooks.on_init(args, context)
  let a:context.source__poslist = exists('w:poslist') ? w:poslist : []
endfunction

function! s:source.gather_candidates(args, context)
  return map(copy(a:context.source__poslist), '{
  \   "word": printf("%s:%d-%d  %s", bufname(v:val[0]), v:val[1], v:val[2],
  \           get(getbufline(v:val[0], v:val[1]), 0, "[buffer unloaded]")),
  \   "kind": "jump_list",
  \   "source": "poslist",
  \   "action__path": expand(printf("#%d:p", v:val[0])),
  \   "action__line": v:val[1],
  \ }')
endfunction


function! unite#sources#poslist#define()
  return s:source
endfunction



let &cpo = s:save_cpo
