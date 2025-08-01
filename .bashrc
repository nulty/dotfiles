# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

reset_path() {
	. /etc/environment
}

reset_path

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

txtblk='\[\e[0;30m\]' # Black - Regular
txtred='\[\e[0;31m\]' # Red
txtgrn='\[\e[0;32m\]' # Green
txtylw='\[\e[0;33m\]' # Yellow
txtblu='\[\e[0;34m\]' # Blue
txtpur='\[\e[0;35m\]' # Purple
txtcyn='\[\e[0;36m\]' # Cyan
txtwht='\[\e[0;37m\]' # White
bldblk='\[\e[1;30m\]' # Black - Bold
bldred='\[\e[1;31m\]' # Red
bldgrn='\[\e[1;32m\]' # Green
bldylw='\[\e[1;33m\]' # Yellow
bldblu='\[\e[1;34m\]' # Blue
bldpur='\[\e[1;35m\]' # Purple
bldcyn='\[\e[1;36m\]' # Cyan
bldwht='\[\e[1;37m\]' # White
unkblk='\[\e[4;30m\]' # Black - Underline
undred='\[\e[4;31m\]' # Red
undgrn='\[\e[4;32m\]' # Green
undylw='\[\e[4;33m\]' # Yellow
undblu='\[\e[4;34m\]' # Blue
undpur='\[\e[4;35m\]' # Purple
undcyn='\[\e[4;36m\]' # Cyan
undwht='\[\e[4;37m\]' # White
bakblk='\[\e[40m\]'   # Black - Background
bakred='\[\e[41m\]'   # Red
bakgrn='\[\e[42m\]'   # Green
bakylw='\[\e[43m\]'   # Yellow
bakblu='\[\e[44m\]'   # Blue
bakpur='\[\e[45m\]'   # Purple
bakcyn='\[\e[46m\]'   # Cyan
bakwht='\[\e[47m\]'   # White
txtrst='\[\e[0m\]'    # Text Reset

### Git PS1 prompt options ###
# See git-prompt.sh line 38 

GIT_PS1_SHOWUPSTREAM="auto"

source ~/git-prompt.sh
source ~/git-completion.bash

update_ps1() {
  # PS1="${debian_chroot:+($debian_chroot)}$txtgrn\u$txtrst $bldblu\w$bldylw$(__git_ps1 " (%s)")\[\033[00m\] $bldred\$$txtrst "
  PS1="$CONDA_PROMPT_MODIFIER$VIRTUAL_ENV_PROMPT${debian_chroot:+($debian_chroot)}$txtgrn\u$txtrst $bldblu\w$bldylw$(__git_ps1 " ( %s)") $bldred\$$txtrst "
}
PROMPT_COMMAND=update_ps1

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
if [ -f ~/.private_aliases ]; then
    . ~/.private_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


#### Custom rc starts here ###

# Set EDITOR
export EDITOR=nvim

### autojump ###
[ -f /usr/share/autojump/autojump.bash ] && source /usr/share/autojump/autojump.bash

### alacritty ###
[ -f ~/alacritty/alacritty.bash ] && source ~/alacritty/extra/completion/alacritty.bash

### Fzf ###
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/fzf-git.sh ] && source ~/fzf-git.sh
[ -f ~/.privaterc ] && source ~/.privaterc


### conda ###
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$("$HOME/anaconda3/bin/conda" 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


### kubectl ###
if command -v kubectl &> /dev/null; then
  source <(kubectl completion bash)
  alias k=kubectl
  complete -o default -F __start_kubectl k
fi

### PATH ###

ppath() {
  echo $PATH | tr ':' '\n'
}

export PATH=$PATH:/usr/local/android-studio/bin
export PATH=$PATH:~/bin

### RuactNative requirements for Android development ###
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

### Mason ###
export PATH=$PATH:/usr/local/.local/data/nvim/mason/bin/


### fzf ###
# export FZF_DEFAULT_COMMAND=$PATH:/usr/local/.local/data/nvim/mason/bin/
# export FZF_DEFAULT_COMMAND=$PATH:/usr/local/.local/data/nvim/mason/bin/
# export FZF_CTRL_T_COMMAND=JK
# export FZF_CTRL_T_COMMAND=JK
# export FZF_DEFAULT_OPTS="--no-mouse --height=50% --multi --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --olor=always {} || cat {}) 2> /dev/null | head -300' --preview-window='right:hidden:wrap'"
export FZF_DEFAULT_OPTS="--no-mouse --height=50% --preview='head {}' --preview-window='right:hidden:wrap'"

## Mise config
export MISE_CACHE_DIR=/usr/local/.cache/mise/
export MISE_CONFIG_DIR=/usr/local/.config/mise/
export MISE_DATA_DIR=/usr/local/.local/data/mise/
export MISE_STATE_DIR=/usr/local/.local/state/mise/
export MISE_GLOBAL_CONFIG_FILE=/usr/local/.config/mise/config.toml
eval "$(/usr/local/bin/mise activate bash)"
eval "$(mise env)"
