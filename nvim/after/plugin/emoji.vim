fun s:Maxlen(list) abort
      let max = 0
      let max = len('asdf')
      for item in a:list
            let l:max = l:max < len(item) ? len(item) : l:max
      endfor
      echom max
      return max
endfun

fun s:EmojiMap() abort
      let max_len = Maxlen(emoji#list())
      " let list = []
      " for text in emoji#list()
      "       list.text =
      " endfor
      let spaces = repeat(' ', 52)
      map(emoji#list(), { key, val -> val .. copy(spaces)[:52 - len(val)] .. emoji#for(val) })
      let spaces = repeat(' ', 52) | echo map(emoji#list(), { key, val -> val .. copy(spaces)[:52 - len(val)] .. emoji#for(val) })
endfun

" echo Maxlen(emoji#list())
command Em let g:spaces = repeat(' ', 52) | echo map(emoji#list(), { key, val -> val .. copy(g:spaces)[:52 - len(val)] .. emoji#for(val) })
command EmojiList call fzf#run(fzf#wrap({'source': s:EmojiMap(), 'sink': 'echo'}))

