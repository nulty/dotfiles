" Filename helpers
fun! Filename(type = 0) abort
  " call fzf#run(fzf#wrap({'source': 'ls'}))

  let l:opts = { 1: '%:p', 2: '%:t', 3: '%:p:h' }
  if a:n == 0
    echom "1) Fullpath"
    echom "2) Filename"
    echom "3) Directory"
    let l:input = input("What you want?\n\n")
  else
    let l:input = a:n
  endif

  mode
  let l:choice = get(l:opts, l:input, 1)
  let l:text = expand(l:choice)

  echo l:text
  " insert the result
  exe "normal i" .. l:text
endfun
command! -nargs=? Filename :call Filename(<args>)
map <Leader>pp :Filename 1<CR>
map <Leader>pf :Filename 2<CR>
map <Leader>pd :Filename 3<CR>

