runtime ./init/options.vim

" vim-polyglot (set before plug loads)
let g:polyglot_disabled = ['sensible']
let g:polyglot_disabled = ['typescript']

runtime plugrc.vim

" Theme
" colorscheme onedark
colorscheme hybrid

runtime init/mappings.vim

" Filename helpers
fun! Filename()
  " call fzf#run(fzf#wrap({'source': 'ls'}))
  echom "1) Fullpath"
  echom "2) Filename"
  echom "3) Directory"
  let l:input = input("What you want\n\n")

  let l:opts = { 1: '%:p', 2: '%', 3: '%:p' }

  let l:choice = get(l:opts, l:input, 1)

  mode
  let l:text = expand(choice)
  let @e = l:text

  echom l:text
  " let l:filename = expand("%:p")
  " redir l:filename
  return ''
endfun
command Filename call Filename()


" let NERDTreeNaturalSort=1
" let NERDTreeIgnore=['tags$', '\~$']
" let NERDTreeWinSize=20
" Set built-in file system explorer to use layout similar to the NERDTree plugin
let g:netrw_liststyle=3

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
autocmd FileType nerdtree {Down-Mapping} :TmuxNavigateDown

" Vim cheating
nmap <C-c> :bw<cr>
nmap <C-s> :up<cr>

" Next tag
nnoremap <C-y> :tag<cr>

"ncm2
" inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')

" splitjoin
"
nmap <Leader>j :SplitjoinJoin<cr>
nmap <Leader>l :SplitjoinSplit<cr>

" help with ultisnips and omni complete

" ncm2 DISABLED FOR COC
" autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect


""" Use `[g` and `]g` to navigate diagnostics
" nmap <silent> [g <Plug>(coc-diagnostic-prev)
" nmap <silent> ]g <Plug>(coc-diagnostic-next)

" """ GoTo code navigation.
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)

" vmap <leader>p  <Plug>(coc-format-selected)
" nmap <leader>p  <Plug>(coc-format-selected)
" nmap <leader>qf  <Plug>(coc-fix-current)
" nmap <leader>ac  <Plug>(coc-codeaction)
" Use K to show documentation in preview window.
" nnoremap <silent> K :call <SID>show_documentation()<CR>


" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? coc#_select_confirm() :
"       \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()

" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~ '\s'
" endfunction

" inoremap <silent><expr> <TAB>
"   \ pumvisible() ? "\<C-n>" :
"   \ <SID>check_back_space() ? "\<TAB>" :
"   \ coc#refresh()


 let g:python3_host_prog = '/home/iain/.asdf/shims/python'
 let g:python2_host_prog = '/home/iain/.asdf/shims/python2'
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" let g:coc_snippet_next = '<tab>'


" Use <c-space> to trigger completion.
" inoremap <silent><expr> <c-space> coc#refresh()

" runtime compe.vim

""" coc-snippets start
" TAB used for coc completion
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? coc#_select_confirm() :
"       \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" let g:coc_snippet_next = '<tab>'

" nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" Use <C-l> for trigger snippet expand.
" imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
" vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
" let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
" let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
" imap <C-j> <Plug>(coc-snippets-expand-jump)

""" coc-snippets end

" " Ultisnips
let g:UltiSnipsExpandTrigger       = "<Plug>(ultisnips_expand)"
let g:UltiSnipsExpandTrigger       = "<Tab>"
let g:UltiSnipsJumpForwardTrigger  = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
let g:UltiSnipsListSnippets        = "<c-l>" " *** Insert Mode

" let g:UltiSnipsRemoveSelectModeMappings = 1
" let g:UltiSnipsSnippetDirectories       = ['UltiSnips']
" "let g:CommandTFileScanner              = 'watchman'


" vim-emoji
set completefunc=emoji#complete

"map <leader>t :call fzf#run({'source': 'ls'})<cr>
map <leader>t :call fzf#run(fzf#wrap({'source': 'git ls-files --exclude-standard --others --cached'}))<cr>
nmap <leader>b :Buffers<cr>
"map <leader>t :FZF<cr>
"let g:fzf_action = {
      "\ 'ctrl-q': function('s:build_quickfix_list'),
      "\ 'ctrl-t': 'tab split',
      "\ 'ctrl-x': 'split',
      "\ 'ctrl-v': 'vsplit' }

" Searching the file system
" map <leader>' :NERDTreeToggle<cr>
map <leader>' :NvimTreeToggle<cr>
map <leader>F :NvimTreeFindFile<cr>
"let g:NERDTreeWinSize=25

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
"function! SearchAndAck()
"normal! g*
"AckFromSearch
"endfunction
"nnoremap gs :call SearchAndAck()<CR>

nmap <silent> <leader>rn :TestNearest<CR>
nmap <silent> <leader>rf :TestFile<CR>
nmap <silent> <leader>rs :TestSuite<CR>
nmap <silent> <leader>rl :TestLast<CR>
nmap <silent> <leader>ro :TestVisit<CR>
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

" convert Camle case to Snake case with a range selection
function! Snakify()
  execute a:firstline . "," . a:lastline . 's#\C\(\<\u[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g'
endfunction
command! -range ToSnake call Snakify()
vmap <leader>sn :call Snakify()<CR>


" Regex to capitalize first characters after space or >
" s/>\@<=\(\a\)\| \@<=\(\a\)/\u\1/g

nmap <leader>cr :call RunCrystalFile()<CR>
onoremap if :<c-u>normal! F/def<cr>jd/end<cr>
nmap <leader>rp :call RunInPry()<CR>
let g:no_turbux_mappings = 1
"map <leader>rt <Plug>SendTestToTmux
"map <leader>rT <Plug>SendFocusedTestToTmux
"" LaTeX
"let g:tex_flavor='latex'

" Clear search buffer
" map <leader>/ :nohlsearch<cr>

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


" command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')
" let g:LanguageClient_serverCommands = {
"     \ 'vue': ['vls']
"     \ }

" javscript libraries vim
let g:used_javascript_libs = 'vue,react'
" Tmux Navigator mappings
" let g:tmux_navigator_no_mappings = 1

nnoremap <silent> {Left-Mapping} :TmuxNavigateLeft<cr>
nnoremap <silent> {Down-Mapping} :TmuxNavigateDown<cr>
nnoremap <silent> {Up-Mapping} :TmuxNavigateUp<cr>
nnoremap <silent> {Right-Mapping} :TmuxNavigateRight<cr>
nnoremap <silent> {Previous-Mapping} :TmuxNavigatePrevious<cr>


" Typical Ctrl-{hjkl} movements in terminal mode
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l

" resize window
" nnoremap <c-a-l> :exe "vertical resize -5"<cr>
" nnoremap <c-a-h> :exe "vertical resize +5"<cr>
" nnoremap <c-a-j> :exe "resize +5"<cr>
" nnoremap <c-a-k> :exe "resize -5"<cr>
" use Alt-dir to move the current window in normal mode
nnoremap <A-h> <C-w><S-h>
nnoremap <A-j> <C-w><S-j>
nnoremap <A-k> <C-w><S-k>
nnoremap <A-l> <C-w><S-l>

nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>

" on<CR> with pairs, create new line

" inoremap <silent><expr> <cr>pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Golden Ratio
" let g:loaded_golden_ratio = 0

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
  autocmd Bufread,BufNewFile *.html set filetype=html
  autocmd Bufread,BufNewFile *.spv set filetype=php
  autocmd Bufread,BufNewFile *.rbi set filetype=ruby
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

"autocmd VimEnter * call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
" autocmd FileType * <leader>F :NvimTreeFindFile<CR>

" Show syntax Group for code under the cursor
nmap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" let g:WebDevIconsUnicodeDecorateFolderNodes = 1
" let g:WebDevIconsNerdTreeAfterGlyphPadding = '  '
" let g:DevIconsEnableFoldersOpenClose = 1

" Match the filename exactly
" let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols = {} " needed
" let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols['rakefile'] = 'פּ'
" let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols['gemfile'] = ''
" let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols['config.ru'] = ''

" Create custom symbols for filetypes
" let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols = {} " needed
" let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['.*\.lock'] = ''
" let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['\.gitignore'] = ''


"" NERDTrees File highlighting
" function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
"   exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
"   exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
" endfunction

" These are available to specify colour of the filenames
"call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
"call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
"call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
"call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
"call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
"call NERDTreeHighlightFile('ruby', 'Red', 'none', 'red', '#151515')
"call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
"call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')
"call NERDTreeHighlightFile('ds_store', 'Gray', 'none', '#686868', '#151515')
"call NERDTreeHighlightFile('gitconfig', 'Gray', 'none', '#686868', '#151515')
"call NERDTreeHighlightFile('gitignore', 'Gray', 'none', '#686868', '#151515')
"call NERDTreeHighlightFile('bashrc', 'Gray', 'none', '#686868', '#151515')
"call NERDTreeHighlightFile('bashprofile', 'Gray', 'none', '#686868', '#151515')


"" NERDTrees File highlighting only the glyph/icon
"" test highlight just the glyph (icons) in nerdtree:

augroup NerdTreeIconColours
  autocmd!
  "autocmd filetype nerdtree highlight haskell_icon ctermbg=none ctermfg=Red guifg=#ffa500
  autocmd FileType nerdtree highlight HTMLIcon ctermbg=none ctermfg=Red guifg=#ffa500
  autocmd FileType nerdtree highlight RubyIcon ctermbg=none ctermfg=Red guifg=#ffa500
  autocmd FileType nerdtree highlight JSIcon ctermbg=none ctermfg=Yellow guifg=yellow
  autocmd FileType nerdtree highlight CSSIcon ctermbg=none ctermfg=Red guifg=#ffa500



  " if you are using another syn highlight for a given line (e.g.
  " NERDTreeHighlightFile) need to give that name in the 'containedin' for this
  " other highlight to work with it
  autocmd FileType nerdtree syn match HTMLIcon ## containedin=NERDTreeFile,html
  autocmd FileType nerdtree syn match RubyIcon ## containedin=NERDTreeFile,ruby
  autocmd FileType nerdtree syn match JSIcon ## containedin=NERDTreeFile,javascript
  autocmd FileType nerdtree syn match CSSIcon ## containedin=NERDTreeFile,css
augroup END


if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif


inoremap <F5> <C-R>=ListMonths()<CR>
func! ListMonths()
  <silent> call complete(col('.'), ['January', 'February', 'March',
                      \ 'April', 'May', 'June', 'July', 'August', 'September',
                      \ 'October', 'November', 'December'])
  return ''
endfunc

highlight link CompeDocumentation NormalFloat

lua << EOF
  local tree_cb = require'nvim-tree.config'.nvim_tree_callback

  -- default mappings
  vim.g.nvim_tree_bindings = {
    { key = {"<CR>", "<2-LeftMouse>"},           cb = tree_cb("edit") },
    { key = {"<2-RightMouse>", "<C-]>", "+"},    cb = tree_cb("cd") },
    { key = {"s"},                               cb = tree_cb("vsplit") },
    { key = "<C-x>",                             cb = tree_cb("split") },
    { key = "<C-t>",                             cb = tree_cb("tabnew") },
    { key = "<",                                 cb = tree_cb("prev_sibling") },
    { key = ">",                                 cb = tree_cb("next_sibling") },
    { key = "P",                                 cb = tree_cb("parent_node") },
    { key = "<BS>",                              cb = tree_cb("close_node") },
    { key = "<S-CR>",                            cb = tree_cb("close_node") },
    { key = "<Tab>",                             cb = tree_cb("preview") },
    { key = "K",                                 cb = tree_cb("first_sibling") },
    { key = "J",                                 cb = tree_cb("last_sibling") },
    { key = "I",                                 cb = tree_cb("toggle_ignored") },
    { key = "H",                                 cb = tree_cb("toggle_dotfiles") },
    { key = "R",                                 cb = tree_cb("refresh") },
    { key = "a",                                 cb = tree_cb("create") },
    { key = "d",                                 cb = tree_cb("remove") },
    { key = "r",                                 cb = tree_cb("rename") },
    { key = "<C-r>",                             cb = tree_cb("full_rename") },
    { key = "x",                                 cb = tree_cb("cut") },
    { key = "c",                                 cb = tree_cb("copy") },
    { key = "p",                                 cb = tree_cb("paste") },
    { key = "y",                                 cb = tree_cb("copy_name") },
    { key = "Y",                                 cb = tree_cb("copy_path") },
    { key = "gy",                                cb = tree_cb("copy_absolute_path") },
    { key = "[c",                                cb = tree_cb("prev_git_item") },
    { key = "]c",                                cb = tree_cb("next_git_item") },
    { key = "-",                                 cb = tree_cb("dir_up") },
    { key = "q",                                 cb = tree_cb("close") },
    { key = "?",                                 cb = tree_cb("toggle_help") },
  }

EOF

luafile ~/.config/nvim/lua/init.lua
command LspLog echo execute("lua print(vim.inspect(vim.lsp.buf_get_clients()))<CR>")
