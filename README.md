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
4. Install neovim LSPs



## Packages
  - git
  - curl
  - pass
  - acl
  - autojump
  - fontmanager
  - gnupg
  - unzip
  - xclip
  - ripgrep
  - jq
  - bleachbit
  - fd-files

## Programs
 - nvim '0.9.5'
 - tmux '3.2a'
 - mise '0.10.2'
   * lua '5.1'
   * ruby '3.2.3'
   * node '20.10.0'
   * python '3.10.6'
   * rust '1.75.0'
 - alacritty '0.12.3'
     

## NeoVim plugins

See nvim [README.md](nvim/README.md)

# Autoinstall

 1. Create a group devs and add your user to it
     a. `sudo groupadd devs && addgroup $USER devs`
 2. You need to restart to be added to the group

## Testing 


### Virtual Box
sudo apt-get install virtualbox virtualbox-guest-additions-iso

### Docker

Build and tag the docker container.
```shell
$ ./docker-test.sh
$ docker run -it dotfiles /bin/bash
$ ./dotfiles/setup.sh

```
