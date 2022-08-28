# Setup
#  1) Install debian packages
#  2) Install dotfiles program
#  3) Install asdf
#  4) Install asdf-ruby
#  5) Install asdf-python
#  6) Install asdf-rust
#  7) Install asdf-node
#  8) Install neovim and packages from GitHub
#  9) Install fzf
# 10) Install alacritty
set -e

if [ "$1" = '-y' ]
then
  INSTALL_ALL=1
fi

echo Running setup
# Helper Functions
# Decide whether to install a program
install?() {
  # Return if program is already installed
  if ( hash $1 ) &> /dev/null; then
    echo $1 is already installed
    return 1
  fi

  if [ -n "$INSTALL_ALL" ]; then
    echo "Installing $1"
    return 0
  else
    printf "Install %b? " $1
    read install

    if [[ $install = 'y' ]]; then
      echo "Installing $1"
      return 0
    else
      echo Not installing $1
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
  curl -LJO https://github.com/rhysd/dotfiles/releases/download/v0.2.2/dotfiles_linux_amd64.zip
  sudo unzip dotfiles_linux_amd64.zip -d /usr/local/bin/ && rm dotfiles_linux_amd64.zip
  dotfiles clone https://github.com/nulty/dotfiles .
  mv ~/.bashrc ~/.bashrcBAK
  dotfiles link dotfiles
fi

clear
# Install asdf
if install? 'asdf';
then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
  # echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc
  # echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc

  . $HOME/.asdf/asdf.sh
fi

clear
# Install Ruby
if install? 'ruby';
then
  sudo apt-get install -y libssl-dev zlib1g-dev

  asdf plugin add ruby
  asdf install ruby 2.7.4
  asdf global ruby 2.7.4
fi

clear
# Install Tmux
if install? 'tmux';
then
  sudo apt-get install -y bison

  asdf plugin add tmux
  asdf install tmux 3.2
  asdf global tmux 3.2
fi

clear
# Install Python
if install? 'python';
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

  asdf plugin add python
  asdf install python 3.7.3
  asdf global python 3.7.3

  asdf install python 2.7.18
  # asdf global python 2.7.18
fi

clear
# Install Rust
if install? 'rust';
then
  asdf plugin add rust
  asdf install rust 1.56.0
  asdf global rust 1.56.0
fi

clear
# Install Node
if install? 'node';
then
  asdf plugin add nodejs
  asdf install nodejs 14.18.1
  asdf global nodejs 14.18.1
fi

clear
### Install nvim ####
if install? 'nvim';
then
  sudo curl -LJO https://github.com/neovim/neovim/releases/download/v0.7.2/nvim-linux64.tar.gz && \
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

# curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
# sudo sh -c 'echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com stable main" > /etc/apt/sources.list.d/brave.list'
# sudo apt-get update && sudo apt-get install brave-browser

clear
# # FZF
if install? 'fzf';
then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --no-bash --no-fish --all
  sudo cp -r .fzf/bin .fzf/man /usr/local/
fi

clear
# Install alaccritty dependencies
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
  git clone https://github.com/alacritty/alacritty.git --branch v0.7.2
  cd alacritty

  # Build
  cargo build --release

  sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
  sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
  sudo desktop-file-install alacritty/Alacritty.desktop
  sudo update-desktop-database

  # Manpage
  sudo mkdir -p /usr/local/share/man/man1
  gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null

  # Completion
  mv alacritty/extra/completions/alacritty.bash alacritty/

  # Use my config
  rm alacritty/alacritty.yml
  dotfiles link dotfiles alacritty/alacritty.yml
fi

# sudo apt-get install \
# #   timewarrior \
# #   taskwarrior \
# #   sqlformat \
# #   redis \
# #   peek \
# #   pandoc \
# #   slack-desktop \

