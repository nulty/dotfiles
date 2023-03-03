alias vim="/usr/local/bin/nvim"

# Generate Ctags for a project
#alias genctags="ctags -R --exclude=node_modules --exclude=public"
# alias genctags="ctags -R --exclude=public"

# Config files
alias ac="vim ~/.config/alacritty/alacritty.yml"
alias tc="vim ~/.tmux.conf"
alias vc="vim ~/.config/nvim/init.vim"
alias vimpkg="cd ~/.config/nvim/plugged"
alias sshconf="vim ~/.ssh/config"
# --exclude 52.56.189.136
# Source bashrc easily
alias s="source ~/.bashrc"
alias sb=". ~/.bashrc"

# use Less like tail with raw characters
alias llog="less +F -r "

# Edit .bashrc
alias bc="vim ~/.bashrc"

alias tt="echo $1 $2 $3"

alias gitprune="git br --merged | egrep -v 'master'|egrep -v \"\*\" | xargs -I \"%\" git br -d %"
alias g="git"

alias pg_conf="sudo su -c'vim /etc/postgresql/9.6/main/postgresql.conf'"
alias vimalias="vim ~/.bash_aliases"
alias copyvimconfig="cp ~/.config/nvim/init.vim ."

alias delete_merged="git co master && git br --merged | egrep -v '(master|staging)' | xargs -I% git br -d % && git co"

alias routes_filtered="bundle exec rails routes | grep '/api/' | awk '{if(\$1 ~ /[A-Z]/) { print \$1\"\t\"\$2 } else { print \$2 \"\t\" \$3 }}' | sort"
alias stop_containers="docker container stop "

alias dsize="du --max-depth=1 -h"
alias tailsp="tail -f ~/.cache/nvim/lsp.log"

# Source Python virtualenv
alias sp="source ./venv/bin/activate"
