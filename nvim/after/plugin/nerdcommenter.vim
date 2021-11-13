" NerdComment
" Keep one space between the comment char and the comment
let g:NERDSpaceDelims = 1
" Align comments to the left, not indent
let g:NERDDefaultAlign = 'both'
let g:NERDCustomDelimiters = {
      \ 'mason': { 'left': '<!--', 'right': '-->','leftAlt': 'FOO', 'rightAlt': 'BAR' },
      \ 'json': { 'left': '//' },
      \ 'grondle': { 'left': '{{', 'right': '}}' }
      \ }
