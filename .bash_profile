source ~/.profile

export EDITOR='vim'
export SHELL='/bin/bash'

export ES_CLASSPATH=/usr/local/elasticsearch/Current/lib

export NVM_DIR="/Users/anulman/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

alias blog="cd /Users/anulman/projects/anulman.github.io"
export PATH=./node_modules/.bin:/usr/local/bin:/usr/local/sbin:/Applications/Postgres.app/Contents/Versions/9.3/bin:$PATH
export LC_CTYPE="utf-8"

source ~/.bin/tmuxinator.bash

source /Users/anulman/.phpbrew/bashrc # same but for phpbrew yaaaay

# android bs
export STUDIO_JDK='/Library/Java/JavaVirtualMachines/jdk1.8.0_31.jdk'
export ANDROID_SDK_ROOT='/Users/anulman/Library/Android/sdk'
export ANDROID_HOME=$ANDROID_SDK_ROOT

# export PATH=$PATH:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools
# export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/22.0.1
export PATH=$PATH:$HOME/dev/dotfiles/.bin
export PATH=$PATH:$HOME/.asdf/installs/elixir/1.8.1/.mix/escripts
# add llvm & clangd to PATH
export PATH=/opt/homebrew/opt/llvm/bin:$PATH
export GOPATH=/Users/anulman/dev/gopath
export GOBIN=$GOPATH/bin

export PGDATA=/usr/local/var/postgres

# git
alias gc='git commit'
alias gco='git checkout'
alias gr='git reset'
alias grb='git rebase'
alias grh='git reset --hard'
alias gs='git status'

# git-flow
alias gf='git-flow'
alias gff='gf feature'
alias gfr='gf release'
alias gfh='gf hotfix'
alias gfs='gf support'

# rails
alias be='bundle exec'
alias ber='be rails'
alias berc='ber console'
alias bers='ber server'
alias bet='be rspec'
alias bep='be puma'
alias bepc='be puma -C config/puma.rb'
alias fs='foreman start'
alias fsw='foreman start web'

# js
alias nom='rm -rf node_modules && yarn'
alias nr='npm run'
alias y='yarn'
alias yr='y run'

# python
alias py="python3"
alias pyp="pip3"

# bash-completion -- `brew install bash-completion`
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# git prompt
source $(brew --prefix)/etc/bash_completion.d/git-prompt.sh
export PS1="\h:\W \u\$(__git_ps1 \" (%s) \")\$"

# hub -- `brew install hub`
# aliases hub commands to `git`
eval "$(hub alias -s)"

# serve wd as http on 8000
alias serve='python -m SimpleHTTPServer 8000'

test -e ${HOME}/.iterm2_shell_integration.bash && source ${HOME}/.iterm2_shell_integration.bash

# set locales for python
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

if [ -f ~/.bashrc ]; then
  alias notifyme=`echo osascript ${HOME}/.bin/terminal-notify.scpt `
  source ~/.bashrc
fi

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

. $HOME/.asdf/asdf.sh

. $HOME/.asdf/completions/asdf.bash

# alias git-restart="git rebase -i $(git rev-list --max-parents=0 HEAD)"

. $HOME/.asdf/asdf.sh

. $HOME/.asdf/completions/asdf.bash
export VOLTA_HOME="/Users/anulman/.volta"
grep --silent "$VOLTA_HOME/bin" <<< $PATH || export PATH="$VOLTA_HOME/bin:$PATH"

# Mighty config
# export CLOUDBOX_HOST="50.31.220.139"
# export CLOUDBOX_ELECTRON_HOST_IP="$CLOUDBOX_HOST"
# export CLOUDBOX_ELECTRON_HOST_PORT=4400

function tssh() {
  ssh $@ -t 'tmux -CC attach'
}

alias mp="ssh mp"
alias md="ssh md"
alias mc="ssh mc"
alias tmp="tssh mp"
alias tmd="tssh md"
alias tmc="tssh mc"

# gcloud autocompletion
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc"
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"
alias dotfiles="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"

# Hook up direnv
eval "$(direnv hook bash)"
