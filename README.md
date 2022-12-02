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

## Programs
 - nvim '0.8.1'
 - tmux '3.2'
 - asdf '0.10.2'
   * ruby '2.3.1'
   * python '3.10.6'
   * rust '1.63.0'
 - alacritty '0.7.2'
     

## Vim plugins

 - Plug 'junegunn/vim-plug'
 - Plug 'Shougo/deoppet.nvim', { 'do': ':UpdateRemotePlugins' }
 - Plug 'SirVer/ultisnips'
 - Plug 'honza/vim-snippets'
 - Plug 'vim-ruby/vim-ruby', { 'for': 'ruby'}
 - Plug 'kana/vim-textobj-user'
 - Plug 'rhysd/vim-textobj-ruby', { 'for': 'ruby'}
 - Plug 'mileszs/ack.vim'
 - Plug 'chiedo/vim-case-convert'
 - Plug 'bkad/CamelCaseMotion'
 - Plug 'mattn/emmet-vim'
 - Plug 'kyazdani42/nvim-web-devicons' " for file icons
 - Plug 'kyazdani42/nvim-tree.lua'
 - Plug 'scrooloose/nerdcommenter'
 - Plug 'flazz/vim-colorschemes'
 - Plug 'elixir-editors/vim-elixir'
 - Plug 'airblade/vim-gitgutter'
 - Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
 - Plug 'tpope/vim-rails', { 'for': 'ruby'}
 - Plug 'tpope/vim-unimpaired'
 - Plug 'tpope/vim-bundler', { 'for': 'ruby'}
 - Plug 'tpope/vim-repeat'
 - Plug 'dkarter/bullets.vim'
 - Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
 - Plug 'junegunn/fzf.vim'
 - Plug 'junegunn/vim-emoji'
 - Plug 'roman/golden-ratio'
 - Plug 'leafOfTree/vim-vue-plugin' ", {'for': 'vue'}
 - Plug 'rhysd/vim-crystal', {'for': 'crystal'}
 - Plug 'tpope/vim-fugitive'
 - Plug 'sheerun/vim-polyglot'
 - Plug 'tpope/vim-surround'
 - Plug 'godlygeek/tabular'
 - Plug 'benmills/vimux'
 - Plug 'christoomey/vim-tmux-navigator'
 - Plug 'tpope/vim-endwise'
 - Plug 'Asheq/close-buffers.vim'
 - Plug 'slim-template/vim-slim', { 'for': 'slim'}
 - Plug 'tpope/vim-scriptease'
 - Plug 'ngmy/vim-rubocop', { 'for': 'ruby'}
 - Plug 'tpope/vim-rhubarb', { 'for': 'ruby'}
 - Plug 'janko/vim-test'
 - Plug 'gcorne/vim-sass-lint', { 'for': 'scss'}
 - Plug 'ap/vim-css-color', { 'for': 'css \| scss'}
 - Plug 'AndrewRadev/splitjoin.vim'
 - Plug 'AndrewRadev/tagalong.vim'
 - Plug 'AndrewRadev/switch.vim'
 - Plug 'sunaku/vim-ruby-minitest', { 'for': 'ruby'}
 - Plug 'hrsh7th/nvim-compe'
 - Plug 'neovim/nvim-lspconfig'
 - Plug 'kabouzeid/nvim-lspinstall'
 - Plug 'neoclide/vim-jsx-improve'
 - Plug 'editorconfig/editorconfig-vim'
 
 ## Testing 

Build and tag the docker container.
```shell
$ ./docker-test.sh
$ docker run -it dotfiles /bin/bash
$ ./dotfiles/setup.sh

```
