"                _             ____           _   __      _
"               (_)___  __  __/ / /___  __   / | / /   __(_)___ ___
"              / / __ \/ / / / / __/ / / /  /  |/ / | / / / __ `__ \
"             / / / / / /_/ / / /_/ /_/ /  / /|  /| |/ / / / / / / /
"            /_/_/ /_/\__,_/_/\__/\__, /  /_/ |_/ |___/_/_/ /_/ /_/
"                                /____/
runtime ./init/options.vim

if has("mac")
  let mapleader='`'
endif

runtime plugrc.vim

" Theme
" colorscheme onedark
colorscheme hybrid

runtime init/mappings.vim

command! -bang -nargs=* Find call fzf#vim#grep('
      \ rg
      \ --column
      \ --line-number
      \ --no-heading
      \ --fixed-strings
      \ --ignore-case
      \ --no-ignore
      \ --hidden
      \ --follow
      \ --glob "!.git/*"
      \ --color "always" '.shellescape(<q-args>), 1, <bang>0
      \ )
nnoremap <leader>f :Find<Space>

" type <leader>sf to run Ack with the word under the cursor as the arg
function! AckWord()
  exe 'normal! "syiw' | exe "Ack " . @s
endfunction
command! AckWord call AckWord()
nnoremap <leader>sf :AckWord<CR>

"" Ack (uses rg behind the scenes)
let g:ackprg = 'rg --vimgrep '

"" Airline (status line)
" let g:airline_powerline_fonts = 1
" let g:airline#extensions#syntastic#enabled = 1

" runtime syntasticrc.vim

let g:user_emmet_settings = {
      \  'eex' : {
        \  'extends' : 'html',
        \ },
        \}

"" Git gutter
let g:gitgutter_enabled = 1
let g:gitgutter_eager = 0
let g:gitgutter_sign_column_always = 1

" " Symbols in the gutter
" let g:gitgutter_sign_added = emoji#for('small_blue_diamond')
" let g:gitgutter_sign_modified = emoji#for('small_orange_diamond')
" let g:gitgutter_sign_removed = emoji#for('small_red_triangle')
" let g:gitgutter_sign_modified_removed = emoji#for('collision')

set signcolumn=yes
highlight clear SignColumn

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

"Vim Ruby
"let g:rubycomplete_load_gemfile = 1
"let g:rubycomplete_buffer_loading = 1
"let g:rubycomplete_classes_in_global = 1
"let g:rubycomplete_rails = 1

" Rubocop
let g:vimrubocop_keymap = 1
let g:vimrubocop_rubocop_cmd = "bundle exec rubocop"


" Surround
" ysiW= will wrap the current word with <%= %>
autocmd FileType eruby let g:surround_37 = "<% \r %>"
autocmd FileType eruby let g:surround_61 = "<%= \r %>"

" Vim cheating
nmap <C-c> :bw<cr>
nmap <C-s> :up<cr>

" Next tag
nnoremap <C-y> :tag<cr>

" splitjoin
"
nmap <Leader>j :SplitjoinJoin<cr>
nmap <Leader>l :SplitjoinSplit<cr>

" help with ultisnips and omni complete

" autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect

let g:python3_host_prog = '$HOME/.asdf/shims/python'
let g:python2_host_prog = '$HOME/.asdf/shims/python2'

" vim-emoji
" set completefunc=emoji#complete

map <leader>t :call fzf#run(fzf#wrap({'source': 'git ls-files --exclude-standard --others --cached'}))<cr>
nmap <leader>b :Buffers<cr>

" Searching the file system
map <leader>' :NvimTreeToggle<cr>
map <leader>F :NvimTreeFindFile<cr>

" Tabularize
map <Leader>e :Tabularize /=<cr>
"map <Leader>c :Tabularize /:<cr>
map <Leader>es :Tabularize /^[^=]*=<cr>
map <Leader>cs :Tabularize /^[^:]*:<cr>
map <Leader>ct :Tabularize /\|<cr>

" Camel Case Motion (for dealing with programming code)
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e

nnoremap gs :call "!./%"

nmap <silent> tn :TestNearest<CR>
nmap <silent> tf :TestFile<CR>
nmap <silent> ts :TestSuite<CR>
nmap <silent> tl :TestLast<CR>
nmap <silent> to :TestVisit<CR>
let test#strategy = "neovim"

" Vimux mappings
nmap <silent> <leader>rq :VimuxCloseRunner<CR>
" nmap <leader>re :call VimuxRunCommand("bin/rails c")<CR>
" nmap <silent> <leader>rt :new | terminal exec "!normal a"<CR>
nmap <leader>rw :call VimuxRunCommand("pry -r./".expand('%'))<CR>

vmap <leader>rr :call VimuxSendText("puts 1\n")

"function! RunInPry()
"call VimuxRunCommand("pry -r ./".expand("%"))
""call VimuxroomRunner()
""call VimuxTogglePane()
"endfunction

function! RunCrystalFile()
  " VimuxRunCommand("echo " . bufname("%"))
  VimuxRunCommand("clear; crystal run " . bufname("%"))
  " call VimuxZoomRunner()
  ear; crystal run getting_input.cr
  " call VimuxTogglePane()
endfunction

nmap <leader>cr :call RunCrystalFile()<CR>
onoremap if :<c-u>normal! F/def<cr>jd/end<cr>
nmap <leader>rp :call RunInPry()<CR>
let g:no_turbux_mappings = 1
"map <leader>rt <Plug>SendTestToTmux
"map <leader>rT <Plug>SendFocusedTestToTmux
"" LaTeX
"let g:tex_flavor='latex'

" Clear the register of the search
map <silent><leader>/ :call ClearSearch()<cr>
fu ClearSearch()
  let @/ = ''
endfu

" format json file inplace
fun! JsonPretty()
  :%! jq '.'
endfun
command JsonFormat call JsonPretty()<CR>

" Open Terminal bottom full width
command Terminal :bo split term://bash | resize 20 | exe "normal! a"

" javscript libraries vim
let g:used_javascript_libs = 'vue,react'
" jump to last cursor
augroup GoLastCursor
  autocmd!
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
augroup END

fun! StripTrailingWhitespace()
  " don't strip on these filetypes
  if &ft =~ 'markdown'
    return
  endif
  %s/\s\+$//e
endfun
augroup StripTrailWhiteSpace
  autocmd BufWritePre * call StripTrailingWhitespace()
augroup END

" augroup FormatBeforeSave
"   autocmd BufWritePre * normal gg=G
" augroup END

" file formats
augroup FileTypes
  autocmd Filetype gitcommit setlocal spell textwidth=72
  autocmd Filetype markdown setlocal wrap linebreak nolist textwidth=0 wrapmargin=0 " http://vim.wikia.com/wiki/Word_wrap_without_line_breaks
  autocmd FileType sh,cucumber,ruby,yaml,zsh,vim setlocal shiftwidth=2 tabstop=2 expandtab

  " Configure comments for jsonc files
  autocmd FileType json syntax match Comment +\/\/.\+$+
augroup END


fun! Stylelint()
  :!npx stylelint --fix %
endfun
command Stylelint call Stylelint()

" specify syntax highlighting for specific files
augroup SetBufFileTypes
  au!
  autocmd Bufread,BufNewFile *.html set filetype=html
  autocmd Bufread,BufNewFile *.spv set filetype=php
  autocmd Bufread,BufNewFile *.rbi set filetype=ruby
  " Give the Terminal type buffer a filetype so it can be managed
  autocmd BufWinEnter * if &l:buftype ==# 'terminal'
                     \|   set filetype=terminal
                     \| endif

  " autocmd BufWriteCmd *.scss call Stylelint()
  autocmd Bufread,BufNewFile _spec.rb set filetype=rspec
  autocmd Bufread,BufNewFile *.md set filetype=markdown " Vim interprets .md as 'modula2' otherwise, see :set filetype?
  " autocmd Bufread *.scss set lines=70
augroup END



" Rainbow parenthesis always on!
augroup RainbowParentheses
  if exists(':RainbowParenthesesToggle')
    autocmd VimEnter * RainbowParenthesesToggle
    autocmd Syntax * RainbowParenthesesLoadRound
    autocmd Syntax * RainbowParenthesesLoadSquare
    autocmd Syntax * RainbowParenthesesLoadBraces
  endif
augroup END
"fun! FixRubyBraces()
""command FRB call FixRubyBraces()
":%s/{\([^ ]\)/{ \1/g
"endfun
"command FRB call FixRubyBraces()<CR>



" Change colourscheme when diffing
fun! SetDiffColors()
  highlight DiffAdd    cterm=bold ctermfg=white ctermbg=DarkGreen
  highlight DiffDelete cterm=bold ctermfg=white ctermbg=DarkGrey
  highlight DiffChange cterm=bold ctermfg=white ctermbg=DarkBlue
  highlight DiffText   cterm=bold ctermfg=white ctermbg=DarkRed
endfun

augroup SetDiffCol
  autocmd!
  autocmd FilterWritePre * call SetDiffColors()
augroup END


" LivedownPreview
let g:livedown_browser = "chromium-browser"

" Show syntax Group for code under the cursor
nmap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif

" nvim-tree config disables netrw so for :GBrowse, vim-fugitive needs
" a :Browse command to define how to open a url
if has("mac")
  command! -nargs=1 Browse silent exe '!xdg-open ' . "<args>"
else
  command! -nargs=1 Browse silent exe '!open ' . "<args>"
endif

luafile ~/.config/nvim/lua/init.lua
command LspBufClients echo execute("lua print(vim.inspect(vim.lsp.buf_get_clients()))<CR>")
