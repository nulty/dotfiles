#!/bin/bash
set -Eeuo pipefail

# if the script is piped in $0 will be "bash"
if [ "$0" -eq "bash" ];then
script_dir=$(pwd -P)
else
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
fi

# Setup
#  1) Install debian packages
#  2) Install dotfiles program
#  3) Install asdf
#  4) Install asdf-ruby
#  5) Install asdf-python
#  6) Install asdf-rust
#  7) Install asdf-node
#  8) Install fzf
#  9) Install neovim and packages from GitHub
# 10) Install alacritty

install_all=${1:-}

alacritty_version=0.7.2
asdf_version=0.10.2
dotfiles_version=0.2.2
node_version=14.18.1
nvim_version=0.7.2
python3_version=3.10.1
python2_version=2.7.18
ruby_version=3.1.2
rust_version=1.63.0
tmux_version=3.2

echo Running setup
# Helper Functions
# Decide whether to install a program
already_installed?() {
  command=$1
  program=$2
  installed=0
  not_installed=1

  if [ $command == "python3" ];then
    if [ $(asdf list python | tr -d ' ' | grep "^3...") &> /dev/null ]; then
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

  if [ -n "$install_all" ]; then
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
  autojump \
  build-essential \
  unzip \
  gnupg \
  ripgrep \
  xclip \
  jq \
  pass \
  desktop-file-utils \
  bleachbit

clear
# KeepassXC
# sudo add-apt-repository -y ppa:phoerious/keepassxc

### Install dotfiles for symlinking dotfiles repo ###
if install? 'dotfiles';
then
  curl -LJO https://github.com/rhysd/dotfiles/releases/download/v${dotfiles_version}/dotfiles_linux_amd64.zip
  sudo unzip dotfiles_linux_amd64.zip -d /usr/local/bin/ && rm dotfiles_linux_amd64.zip
  dotfiles clone https://github.com/nulty/dotfiles .
  mv ~/.bashrc ~/.bashrcBAK
  dotfiles link dotfiles
fi

clear
# Install asdf
if install? 'asdf';
then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v${asdf_version}

  . $HOME/.asdf/asdf.sh
fi

clear
# Install Ruby
if install? 'ruby';
then
  sudo apt-get install -y libssl-dev zlib1g-dev

  [ -z $(asdf plugin list | grep ruby) ] && asdf plugin add ruby
  asdf install ruby ${ruby_version}
  asdf global ruby ${ruby_version}
fi

clear
# Install Tmux
# https://github.com/tmux/tmux
if install? 'tmux';
then
  sudo apt-get install -y bison automake pkg-config libncurses-dev

  [ -z $(asdf plugin list | grep tmux) ] && asdf plugin add tmux
  asdf install tmux ${tmux_version}
  asdf global tmux ${tmux_version}
fi

clear
# Install Python
if install? 'python3';
then
  sudo apt-get install -y \
    libssl-dev \
    zlib1g-dev \
    libffi-dev \
    libreadline-gplv2-dev \
    libncursesw5-dev \
    libsqlite3-dev \
    tk-dev \
    libgdbm-dev \
    libc6-dev \
    libbz2-dev

  [ -z $(asdf plugin list | grep python) ] && asdf plugin add python
  asdf install python ${python3_version}
  asdf global python ${python3_version}
fi
if install? 'python2';
then
  sudo apt-get install -y \
    libssl-dev \
    zlib1g-dev \
    libffi-dev \
    libreadline-gplv2-dev \
    libncursesw5-dev \
    libsqlite3-dev \
    tk-dev \
    libgdbm-dev \
    libc6-dev \
    libbz2-dev

  [ -z $(asdf plugin list | grep python) ] && asdf plugin add python
  asdf install python ${python2_version}
  asdf global python ${python2_version}
fi

clear
# Install Rust
if install? 'rust';
then
  [ -z $(asdf plugin list | grep rust) ] && asdf plugin add rust
  asdf install rust ${rust_version}
  asdf global rust ${rust_version}
fi

clear
# Install Node
if install? 'node';
then
  [ -z $(asdf plugin list | grep nodejs) ] && asdf plugin add nodejs
  asdf install nodejs ${node_version}
  asdf global nodejs ${node_version}
fi

clear
# FZF
if install? 'fzf';
then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --no-bash --no-fish --all
  sudo cp -r ~/.fzf/bin /usr/local
  sudo cp -r --copy-contents ~/.fzf/man/man1 /usr/local/man/
fi

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
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

  ## Run install of plugins
  nvim --headless -u - --cmd "runtime plugrc.vim" +PlugInstall +qall
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
  sudo apt-get install -y \
    cmake \
    pkg-config \
    libfreetype6-dev \
    libfontconfig1-dev \
    libxcb-xfixes0-dev \
    libxkbcommon-dev

  # Fetch source
  git clone https://github.com/alacritty/alacritty.git ~/alacritty --branch v${alacritty_version}
  cd ~/alacritty

  # Build
  cargo build --release

  sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
  sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
  # Manpage
  sudo mkdir -p /usr/local/share/man/man1
  gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null

  # Use my config
  mv alacritty.yml alacritty.yml.original
  dotfiles link ~/dotfiles alacritty/alacritty.yml

  cd $script_dir

  # Desktop file
  sudo desktop-file-install alacritty/Alacritty.desktop
  sudo update-desktop-database
fi

# sudo apt-get install \
# #   timewarrior \
# #   taskwarrior \
# #   sqlformat \
# #   redis \
# #   peek \
# #   pandoc \
# #   slack-desktop \

