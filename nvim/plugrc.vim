call plug#begin()
" Plug 'ncm2/ncm2'
" Plug 'ncm2/ncm2-ultisnips'
" Plug 'ncm2/ncm2-path'
" Plug 'roxma/nvim-yarp'
Plug 'junegunn/vim-plug'
Plug 'Shougo/deoppet.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby'}
Plug 'kana/vim-textobj-user'
Plug 'rhysd/vim-textobj-ruby', { 'for': 'ruby'}
Plug 'mileszs/ack.vim'
Plug 'chiedo/vim-case-convert'
Plug 'bkad/CamelCaseMotion'
Plug 'mattn/emmet-vim'
" Plug 'scrooloose/nerdtree'
" FileSystem
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'

Plug 'scrooloose/nerdcommenter'
Plug 'flazz/vim-colorschemes'
Plug 'elixir-editors/vim-elixir'
Plug 'airblade/vim-gitgutter'
Plug 'shime/vim-livedown'
Plug 'tpope/vim-rails', { 'for': 'ruby'}
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-bundler', { 'for': 'ruby'}
Plug 'tpope/vim-repeat'
Plug 'dkarter/bullets.vim'
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-emoji'
"Plug 'wincent/command-t', {
    "\   'do': 'cd ruby/command-t/ext/command-t && ruby extconf.rb && make'
    "\ }
Plug 'roman/golden-ratio'
Plug 'leafOfTree/vim-vue-plugin' ", {'for': 'vue'}
" Plug 'othree/javascript-libraries-syntax.vim'
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
Plug 'rhysd/vim-crystal', {'for': 'crystal'}
Plug 'tpope/vim-fugitive'
" Plug 'vim-syntastic/syntastic'
Plug 'sheerun/vim-polyglot'
" Plug 'kchmck/vim-coffee-script'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'
Plug 'benmills/vimux'
"Plug 'jgdavey/vim-turbux'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-endwise'
Plug 'Asheq/close-buffers.vim'
Plug 'slim-template/vim-slim', { 'for': 'slim'}
Plug 'tpope/vim-scriptease'
Plug 'ngmy/vim-rubocop', { 'for': 'ruby'}
Plug 'tpope/vim-rhubarb'
Plug 'janko/vim-test'
Plug 'gcorne/vim-sass-lint', { 'for': 'scss'}
Plug 'ap/vim-css-color', { 'for': 'css \| scss'}

Plug 'AndrewRadev/splitjoin.vim'
Plug 'AndrewRadev/tagalong.vim'
Plug 'AndrewRadev/switch.vim'

Plug 'sunaku/vim-ruby-minitest', { 'for': 'ruby'}
Plug 'hrsh7th/nvim-compe'
Plug 'neovim/nvim-lspconfig'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'neoclide/vim-jsx-improve'
Plug 'editorconfig/editorconfig-vim'
call plug#end()
