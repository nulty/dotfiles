" Better splits (new windows appear below and to the right)
set splitbelow
set splitright
set showmatch
set ignorecase
set smartcase
set autoread "reread file when buffer is focussed
set noswapfile
set nobackup
set nowritebackup
set shiftwidth=2
set tabstop=2
set expandtab
set regexpengine=1
set inccommand=nosplit
set showbreak=\\\\

set list listchars=tab:\ \ ,trail:·

set diffopt=vertical

"set cursorline
set cmdheight=2
set updatetime=300

" runtime macros/matchit.vim
"set lazyredraw

"How many lines from the screen edge scrolling begins
set scrolloff=3

filetype plugin indent on
"syntax on
set number

set wildignore+=*.o,*.obj,.git,node_modules,tmp,tags,*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
