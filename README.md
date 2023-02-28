# Dotfiles


Repository for setting up dotfiles on a new machine. It is orchestrated by the [dotfiles](https://github.com/rhysd/dotfiles) program.

## Install

```
wget -q -O - https://raw.githubusercontent.com/nulty/dotfiles/master/setup.sh | bash
```

# Post Install
1. Install a patched font from https://www.nerdfonts.com/
  a. Currently using DejaVuSansMono
2. Ensure terminfo setup for alaritty
3. Set up tmux
  a. Set up tmux tpm
  b. Prefix + I (Prefix and then capital I to install the plugins


## Packages
  - git
  - curl
  - pass
  - autojump
  - gnupg
  - unzip
  - xclip
  - ripgrep
  - jp
  - bleachbit
  - fd-files

## Programs
 - nvim '0.8.1'
 - tmux '3.2'
 - asdf '0.10.2'
   * lua '5.1'
   * ruby '3.1.2'
   * node '18.12.1'
   * python '3.10.6'
   * rust '1.63.0'
 - alacritty '0.7.2'
     

## Vim plugins

```

Plug 'junegunn/vim-plug'
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby'}
Plug 'kana/vim-textobj-user'
Plug 'rhysd/vim-textobj-ruby', { 'for': 'ruby'}
Plug 'chiedo/vim-case-convert'
Plug 'bkad/CamelCaseMotion'
" FileSystem
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

"ColourScheme
Plug 'navarasu/onedark.nvim'

" Comment
Plug 'numToStr/Comment.nvim'

Plug 'elixir-editors/vim-elixir'
Plug 'airblade/vim-gitgutter'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
Plug 'tpope/vim-rails', { 'for': 'ruby'}
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-bundler', { 'for': 'ruby'}
Plug 'tpope/vim-repeat'
Plug 'dkarter/bullets.vim'

" Search
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'junegunn/vim-emoji'
Plug 'camspiers/lens.vim'
Plug 'leafOfTree/vim-vue-plugin' ", {'for': 'vue'}
" Plug 'othree/javascript-libraries-syntax.vim'
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
Plug 'rhysd/vim-crystal', {'for': 'crystal'}
Plug 'tpope/vim-fugitive'
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

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'mattn/emmet-vim'

" LSP and completion
Plug 'neovim/nvim-lspconfig'
" Plug 'williamboman/nvim-lsp-installer'
Plug 'williamboman/mason.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'psf/black', { 'branch': 'stable' }
Plug 'github/copilot.vim'
Plug 'nvim-lua/plenary.nvim'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

Plug 'neoclide/vim-jsx-improve'
Plug 'editorconfig/editorconfig-vim'
``` 
## Testing 

Build and tag the docker container.
```shell
$ ./docker-test.sh
$ docker run -it dotfiles /bin/bash
$ ./dotfiles/setup.sh

```
