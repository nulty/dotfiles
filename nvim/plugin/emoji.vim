fun s:Maxlen(list) abort
  let l:max = 0
  for item in a:list
    let l:max = l:max < len(item) ? len(item) : l:max
  endfor
  return l:max
endfun

fun s:EmojiMap() abort
  let l:max_len = s:Maxlen(emoji#list())
  let l:spaces = repeat(' ', l:max_len)
  return map(emoji#list(), { key, val -> val .. copy(l:spaces)[: (l:max_len - len(val))] .. emoji#for(val) })
endfun

fun s:PrintEmoji(emoji) abort
  let l:key = matchstr(a:emoji, '[a-z_]*')
  call feedkeys('i'. emoji#for(l:key))
endfun

command Emoji call fzf#run(fzf#wrap({'source': s:EmojiMap(), 'sink': function('s:PrintEmoji')}))

