#!/bin/bash
set -Eeuo pipefail

# Variables
dotfile_dir=dotfiles
dotfile_branch=master

# if the script is piped in $0 will be "bash"
if [ "$0" == "bash" ];then
script_dir=$(pwd -P)
else
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}" )" &>/dev/null && pwd -P)
fi

# Setup
#  1) Install debian packages
#  2) Install dotfiles program
#  3) Install mise
#  4) Install mise-ruby
#  5) Install mise-python
#  6) Install mise-rust
#  7) Install mise-node
#  8) Install mise-lua
#  9) Install neovim and packages from GitHub
# 10) Install alacritty
# 11) Install fdfiles

interactive=${1:-}

alacritty_version=0.15.1
dotfiles_version=0.2.2
lua_version=5.1.5
node_version=20.10.0
nvim_version=0.10.1
python3_version=3.10.1
python2_version=2.7.18
ruby_version=3.4.5
rust_version=1.75.0
tmux_version=3.4
fd_version=9.0

echo Running setup
export MISE_CACHE_DIR=/usr/local/.cache/mise/
export MISE_CONFIG_DIR=/usr/local/.config/mise/
export MISE_DATA_DIR=/usr/local/.local/data/mise/
export MISE_STATE_DIR=/usr/local/.local/state/mise/
# mise needs shims to work in non-interactive setups
PATH=/usr/local/.local/data/mise/shims:$PATH


# Helper Functions
# Decide whether to install a program
already_installed?() {
  command=$1
  program=$2
  installed=0
  not_installed=1

  if [ $command == "python3" ]; then
    if [ $(mise list python | tr -d ' ' | grep "^3...") &> /dev/null ]; then
      echo $program is already installed
      return $installed
    fi
  elif ( hash $command ) &> /dev/null; then
    echo $program is already installed
    return $installed
  fi
  return $not_installed
}

install?() {
  program=$1
  command=
  install=

  # Source before checking if programme is installed
  . ~/.bashrc

  # Setup dictionary to map program name to test command
  declare -A progs
  # Only rust has a different exec than the package name, so far
  progs=([rust]=rustc)

  for i in ${!progs[*]}; do
    if [[ $program == $i ]]; then
      command=${progs[$program]}
      break
    fi
    command=$program
  done

  # Return if program is already installed
  already_installed? $command $program && return 1

  if [ -z "$interactive" ]; then
    echo "Installing $program"
    return 0
  else
    printf "Install %b (y/n)? " $program
    read install

    if [[ $install = 'y' ]]; then
      echo "Installing $program"
      return 0
    else
      echo Not installing $program
      return 1
    fi
  fi
}

sudo apt-get update -q
sudo apt-get install -q -y \
  git \
  curl \
  libpq \
  build-essential \
  unzip \
  fzf \
  acl \
  font-manager \
  desktop-file-utils \
  ripgrep \
  sqlformat \
  autojump \
  jq \
  gnupg \
  xclip \
  pass \
  flameshot \
  kazam \
  bleachbit
  # nvidia-driver-530

clear

git clone --progress -b $dotfile_branch https://github.com/nulty/dotfiles.git ~/dotfiles

### Install dotfiles for symlinking dotfiles repo ###
if install? 'dotfiles';
then
  curl -LJO https://github.com/rhysd/dotfiles/releases/download/v0.2.2/dotfiles_linux_amd64.zip
  sudo unzip dotfiles_linux_amd64.zip -d /usr/local/bin/ && rm dotfiles_linux_amd64.zip
  [ ! -d ~/dotfiles ] && dotfiles clone -b $dotfile_branch https://github.com/nulty/dotfiles .
  mv ~/.bashrc ~/.bashrc.original
  dotfiles link $dotfile_dir \
    .bashrc \
    .bash_aliases \
    git-prompt.sh \
    git-completion.bash \
    .gitignore \
    .gitconfig
fi

clear
# Install mise
if install? 'mise';
then

  echo Creating /usr/local directories

  sudo mkdir -p \
    /usr/local/.cache/mise/ \
    /usr/local/.config/mise/ \
    /usr/local/.local/data/mise/ \
    /usr/local/.local/state/mise/ \

  dirs="/usr/local/.cache/ /usr/local/.config/ /usr/local/.local"
  sudo chown :devs -R $dirs
  # set SGID
  sudo chmod -R g+ws $dirs
  # set acl
  sudo setfacl -R -d -m g:devs:rwx $dirs
  sudo setfacl -R -d -m g::rwx $dirs

  sudo curl https://mise.jdx.dev/install.sh | sh
  sudo mv ~/.local/bin/mise /usr/local/bin/
fi

clear
# Install Ruby
if install? 'ruby';
then
  sudo apt-get install -y libssl-dev zlib1g-dev
  sudo apt-get install -y libffi-dev libreadline-dev libedit-dev libyaml-dev # ruby 3.2

  dotfiles link $dotfile_dir \
    .default-gems \
    .rubocop.yml \
    .rubocop_todo.yml

  mise u -gy ruby@$ruby_version
fi

# Install Tmux
# https://github.com/tmux/tmux
if install? 'tmux';
then
  sudo apt-get install -y bison automake pkg-config libncurses-dev

  dotfiles link $dotfile_dir tmux.conf

  mkdir -p ~/.config/tmux/
  mise use -gy tmux@${tmux_version}

  # Install tmux-package-manager
  git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
fi

clear
# Install Tmux
if install? 'fd';
then
  mise use -gy fd@${fd_version}
fi

clear
# Install Python
if install? 'python3';
then
  sudo apt-get install -y \
    libssl-dev \
    zlib1g-dev \
    libffi-dev \
    libreadline-dev \
    libncursesw5-dev \
    libsqlite3-dev \
    tk-dev \
    libgdbm-dev \
    libc6-dev \
    libbz2-dev

  mise u -gy python@${python3_version}
fi

if install? 'python2';
then
  sudo apt-get install -y \
    libssl-dev \
    zlib1g-dev \
    libffi-dev \
    libreadline-dev \
    libncursesw5-dev \
    libsqlite3-dev \
    tk-dev \
    libgdbm-dev \
    libc6-dev \
    libbz2-dev

  mise u -gy python@${python2_version}
fi

clear
# Install Rust
if install? 'rust';
then
  mise u -gy rust@${rust_version}
fi

clear

# Install Node
if install? 'node';
then
  dotfiles link $dotfile_dir \
    .eslintrc.yml \
    .scss-lint.yml #\
    # .default-npm-packages
  mise u -gy node@${node_version}
fi

clear

# if install? 'lua';
# then
#   mise u -gy lua@${lua_version}
# fi
#
clear

# # FZF
# if install? 'fzf';
# then
#   git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
#   ~/.fzf/install --no-bash --no-fish --all
#   sudo cp -r ~/.fzf/bin /usr/local
#   sudo cp -r --copy-contents ~/.fzf/man/man1 /usr/local/man/
# fi

### Install fonts ####
mkdir -p ~/fonts
mkdir -p ~/.local/share/fonts
cp ~/$dotfile_dir/fonts/* ~/.local/share/fonts/
fc-cache -f -v

### Install nvim ####
if install? 'nvim';
then
  sudo curl -LJO https://github.com/neovim/neovim/releases/download/v${nvim_version}/nvim-linux64.tar.gz && \
    sudo tar xf nvim-linux64.tar.gz && \
    sudo cp -rn nvim-linux64/* /usr/local/ && \
    sudo rm -rf nvim-linux64*

  # curl https://raw.githubusercontent.com/nulty/dotfiles/master/setup.sh | bash
  # curl https://raw.githubusercontent.com/nulty/dotfiles/testing-setup/setup.sh | bash
  # wget -q -O - https://raw.githubusercontent.com/nulty/dotfiles/testing-setup/setup.sh | bash

  # Install vim-plug for nvim
  # dotfiles link dotfiles nvim

  # Create symlink from XDG_CONFIG_HOME
  sudo ln -s $HOME/$dotfile_dir/nvim/ /usr/local/.config

  # Set permissions
  sudo chown :devs -R /usr/local/share/nvim
fi

clear
# Install Brave Browser
if install? 'brave-browser';
then
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
sudo sh -c 'echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com stable main" > /etc/apt/sources.list.d/brave.list'
sudo apt-get update && sudo apt-get install -y brave-browser
fi

clear
# Install alacritty
if install? 'alacritty';
then
   # reshim python
  sudo apt-get install -y \
    cmake \
    pkg-config \
    libfreetype6-dev \
    libfontconfig1-dev \
    libxcb-xfixes0-dev \
    libxkbcommon-dev \
    scdoc

  sudo mkdir -p /usr/local/alacritty/

  # Set user and group ownership
  sudo chown -R $USER:devs /usr/local/alacritty/
  sudo chmod -R g+ws /usr/local/alacritty/
  sudo setfacl -R -d -m g:devs:rwx /usr/local/alacritty/
  sudo setfacl -R -d -m g::rwx /usr/local/alacritty/

  # Fetch source
  git clone https://github.com/alacritty/alacritty.git ~/alacritty --branch v${alacritty_version}

  pushd ~/alacritty

  # Build
  cargo build --release

  sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg

  sudo cp target/release/alacritty /usr/local/bin

  # Manpage
  sudo mkdir -p /usr/local/share/man/man5
  scdoc < extra/man/alacritty.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
  scdoc < extra/man/alacritty-msg.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
  scdoc < extra/man/alacritty.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz > /dev/null

  # Install alacritty terminfo https://github.com/alacritty/alacritty/blob/master/INSTALL.md#terminfo
  sudo tic -xe alacritty,alacritty-direct extra/alacritty.info

  # Create symlink from XDG_CONFIG_HOME
  sudo ln -s  $HOME/$dotfile_dir/alacritty/alacritty.toml  /usr/local/alacritty/alacritty.toml

  # This is old, used when alacritty lived in the $HOME directory
  # mv alacritty.yml alacritty.yml.original
  # dotfiles link ~/dotfiles \
  #   alacritty/alacritty.yml \
  #   alacritty/Alacritty.desktop

  popd

  # Desktop file
  sudo desktop-file-install $dotfile_dir/alacritty/Alacritty.desktop
  sudo update-desktop-database
fi

# sudo apt-get install \
#   timewarrior \
#   taskwarrior \
#   sqlformat \
#   redis \
#   peek \
#   pandoc \
#   slack-desktop \
