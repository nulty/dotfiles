echo Running setup
sudo apt-get update
sudo apt-get install -y \
  git \
  curl \
  tmux \
  autojump \
  build-essential \
  unzip \
  gnupg

# KeepassXC
# sudo add-apt-repository -y ppa:phoerious/keepassxc

### Install nvim ####
sudo curl -LJO https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz && \
  sudo tar xf nvim-linux64.tar.gz && \
  sudo cp -rn nvim-linux64/* /usr/local/ && \
  sudo rm -rf nvim-linux64*

### Install dotfiles for symlinking dotfiles repo ###
curl -LJO https://github.com/rhysd/dotfiles/releases/download/v0.2.2/dotfiles_linux_amd64.zip
sudo unzip dotfiles_linux_amd64.zip -d /usr/local/bin/
dotfiles clone https://github.com/nulty/dotfiles .
mv ~/.bashrc ~/.bashrcBAK

# Install vim-plug for nvim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

## Run install of plugins
nvim --headless +PlugInstall +qall

dotfiles link dotfiles

# curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
# sudo sh -c 'echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com stable main" > /etc/apt/sources.list.d/brave.list'
# sudo apt-get update && apt-get install -y

# Install ASDF
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
# echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc
# echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc

. $HOME/.asdf/asdf.sh

asdf plugin add ruby
asdf install ruby 2.7.4
asdf global ruby 2.7.4

asdf plugin add python
sudo apt-get install -y \
  zlib1g-dev \
  libffi-dev \
  libreadline-gplv2-dev \
  libncursesw5-dev \
  libssl-dev \
  libsqlite3-dev \
  tk-dev \
  libgdbm-dev \
  libc6-dev \
  libbz2-dev

asdf install python 3.7.3
asdf global python 3.7.3

asdf plugin add nodejs
asdf install nodejs 14.17.3
asdf global nodejs 14.17.3


# # FZF
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --no-bash --no-fish --all


# sudo apt-get install \
#   ripgrep \
#   xclip \
#   jq \
#   autojump \
#   pass \
#   bleachbit

# #   timewarrior \
# #   taskwarrior \
# #   sqlformat \
# #   redis \
# #   peek \
# #   pandoc \
# #   slack-desktop \

# # Install Nvim
# curl https://github.com/neovim/neovim/releases/download/v0.5.0/nvim.appimage /usr/local/bin/neovim && sudo chmod u+x /usr/local/bin/neovim

