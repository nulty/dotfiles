# KeePassXC
sudo add-apt-repository ppa:phoerious/keepassxc
sudo sh -c 'echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com stable main" >> /etc/apt/sources.list.d/brave.list'

sudo apt-get install \
  git \
  curl \
  timewarrior \
  taskwarrior \
  sqlformat \
  ripgrep \
  redis \
  peek \
  pandoc \
  slack-desktop \
  xclip \
  tmux \
  brave-browser \
  jq \
  autojump \
  bleachbit

# Install Nvim
curl https://github.com/neovim/neovim/releases/download/v0.5.0/nvim.appimage /usr/local/bin/neovim && sudo chmod u+x /usr/local/bin/neovim

