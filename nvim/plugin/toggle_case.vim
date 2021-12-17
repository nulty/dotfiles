" Plugin for converting identifiers format
" Last Change:	2021-12-16
" Maintainer:	Iain McNulty <iain@inulty.com>
" License:	MIT

" Known Bugs
"  - Doesn't work on last word of the line (off by one error)
"  - What happens when under the cursor doesn't match?

let s:save_cpo = &cpo
set cpo&vim

if exists("g:loaded_togglecase")
  finish
endif
let g:loaded_togglecase = 1

if !hasmapto('<Plug>Togglecase')
    map tc <Plug>Togglecase;
endif

noremap <unique> <script> <Plug>Togglecase; <SID>ToggleCase
noremap <SID>ToggleCase :call <SID>ToggleCase()<CR>

function! s:Snakify(str) abort
    return substitute(a:str, '\C\(\<\u[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)', '\l\1_\l\2', 'g')
endfunction

function! s:Camelify(str) abort
    return substitute(a:str, '\(\([a-z]\)\+\)_\=', '\u\1', 'g')
endfunction

function! s:ToggleCase() abort
    let save_cursor = getcurpos()
    exe 'normal! viw"yd'
    let str = @"

    if str =~# '[A-Z][a-z]*'
        echo 'Camelcase'
        let result = s:Snakify(str)
    elseif str =~# '[a-z_]\+'
        echo 'snake_case'
        let result = s:Camelify(str)
    else
        echo 'noop'
        " This is buggy
    endif
    let @" = result

    exe 'normal! ""Pb'
    call setpos('.', save_cursor)
endfunction

if !exists(":Togglecase")
    command Togglecase :call s:ToggleCase()
endif

let &cpo = s:save_cpo
unlet s:save_cpo
