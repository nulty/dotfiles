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

nnoremap <Leader>o :only<cr>
nmap <Leader>c :cclose<cr>

vnoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

nnoremap <leader>gg :G<CR>
" this doesn't work reliably
" vnoremap > >gv
" vnoremap < <gv

" Return to normal mode in terminal
tnoremap <ESC> <C-\><C-n>
tnoremap <C-c> <C-\><C-n>:q!<CR>

nnoremap <leader>T :Terminal<CR>
" ========== Navigate windows, terminal, tmux ============
" Tmux Navigator mappings
" let g:tmux_navigator_no_mappings = 1

nnoremap <silent> {Left-Mapping} :TmuxNavigateLeft<cr>
nnoremap <silent> {Down-Mapping} :TmuxNavigateDown<cr>
nnoremap <silent> {Up-Mapping} :TmuxNavigateUp<cr>
nnoremap <silent> {Right-Mapping} :TmuxNavigateRight<cr>
nnoremap <silent> {Previous-Mapping} :TmuxNavigatePrevious<cr>


" Typical Ctrl-{hjkl} movements in terminal buffer
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l

" resize window
" nnoremap <c-a-l> :exe "vertical resize -5"<cr>
" nnoremap <c-a-h> :exe "vertical resize +5"<cr>
nnoremap <c-a-j> :exe "resize +5"<cr>
nnoremap <c-a-k> :exe "resize -5"<cr>

" use Alt-dir to move the current window in normal mode
nnoremap <A-h> <C-w><S-h>
nnoremap <A-j> <C-w><S-j>
nnoremap <A-k> <C-w><S-k>
nnoremap <A-l> <C-w><S-l>

nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>

" on<CR> with pairs, create new line

" Golden Ratio
" let g:loaded_golden_ratio = 0

