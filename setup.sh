sudo apt-get install \
  git \
  curl

# KeePassXC
sudo add-apt-repository -y ppa:phoerious/keepassxc

curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
sudo sh -c 'echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com stable main" > /etc/apt/sources.list.d/brave.list'
sudo apt-get update && apt-get install -y

mkdir ~/bin/
ln -s ~/.default-gems ~
ln -s ~/.default-npm-packages ~
ln -s ~/.bashrc ~
ln -s ~/.bash_aliases ~
ln -s ~/.gitconfig ~
ln -s ~/.tmux.conf ~
ln -s ~/.gitignore ~
ln -s ~/bin/.git-prompt.sh ~


# Install ASDF
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc

asdf plugin add ruby
asdf install ruby 2.7.3
asdf global 2.7.3

asdf plugin add python

asdf plugin add nodejs
asdf install nodejs 14.17.3
asdf global nodejs 14.17.3


# FZF
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

sudo apt-get install \
  ripgrep \
  xclip \
  tmux \
  jq \
  autojump \
  bleachbit

#   timewarrior \
#   taskwarrior \
#   sqlformat \
#   redis \
#   peek \
#   pandoc \
#   slack-desktop \

# Install Nvim
curl https://github.com/neovim/neovim/releases/download/v0.5.0/nvim.appimage /usr/local/bin/neovim && sudo chmod u+x /usr/local/bin/neovim

