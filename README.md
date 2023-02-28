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
     

## NeoVim plugins

See nvim [README.md](nvim/README.md)

## Testing 

Build and tag the docker container.
```shell
$ ./docker-test.sh
$ docker run -it dotfiles /bin/bash
$ ./dotfiles/setup.sh

```
