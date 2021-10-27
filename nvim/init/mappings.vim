" Prefix regex searches with \v to make them like pcre
"nnoremap / /\v
"vnoremap / /\v

" map j to gj and k to gk, so line navigation ignores line wrap
nnoremap j gj
nnoremap k gk
" space sets up a visual selection vip, viw, vit, etc
nnoremap <space> vi
" Highlight the current line
nnoremap ; :

" Source current file
nnoremap <silent> <Leader>s. :source %<cr>
" Source/Edit vimrc
nnoremap <Leader>ev :vsplit $MYVIMRC<cr>
nnoremap <Leader>sv :source $MYVIMRC<cr>

" H to go to the start of a line
nnoremap H 0
nnoremap 0 <nop>
" L to got to the end of the line
nnoremap L $
nnoremap $ <nop>

" jk will escape from insert mode
"inoremap jk <esc>
imap Jk <esc>
imap jk <esc>
vmap jk <esc>
"vnoremap jk <esc>
" Noop the esc in insert mode
"inoremap <esc> <nop>
"

nnoremap <Leader>o :only<cr>
nmap <Leader>c :cclose<cr>

vnoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" this doesn't work reliably
" vnoremap > >gv
" vnoremap < <gv

