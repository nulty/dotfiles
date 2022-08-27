echo Running setup
sudo apt-get update
sudo apt-get install -y \
  git \
  curl \
  tmux \
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


# KeepassXC
# sudo add-apt-repository -y ppa:phoerious/keepassxc

### Install dotfiles for symlinking dotfiles repo ###
if ! hash dotfiles &> /dev/null; then
  curl -LJO https://github.com/rhysd/dotfiles/releases/download/v0.2.2/dotfiles_linux_amd64.zip
  sudo unzip dotfiles_linux_amd64.zip -d /usr/local/bin/ && rm dotfiles_linux_amd64.zip
  dotfiles clone https://github.com/nulty/dotfiles .
  mv ~/.bashrc ~/.bashrcBAK
  dotfiles link dotfiles
fi

# Install asdf
if ! hash asdf &> /dev/null; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
  # echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc
  # echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc

  . $HOME/.asdf/asdf.sh
fi

# Install Ruby
if ! hash ruby &> /dev/null; then
  sudo apt-get install -y libssl-dev zlib1g-dev

  asdf plugin add ruby
  asdf install ruby 2.7.4
  asdf global ruby 2.7.4
fi

# Install Python
if ! hash python &> /dev/null; then
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

# Install Rust
if ! hash rust &> /dev/null; then
  asdf plugin add rust
  asdf install rust 1.56.0
  asdf global rust 1.56.0
fi

# Install Node
if ! hash node &> /dev/null; then
  asdf plugin add nodejs
  asdf install nodejs 14.18.1
  asdf global nodejs 14.18.1
fi

### Install nvim ####
if ! hash nvim &> /dev/null; then
  sudo curl -LJO https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz && \
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

# # FZF
if ! hash fzf &> /dev/null; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --no-bash --no-fish --all
  sudo cp -r .fzf/bin .fzf/man /usr/local/
fi

# Install alaccritty dependencies
if ! hash alacritty &> /dev/null; then
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
