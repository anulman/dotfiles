source $HOME/.zsh/env
source $HOME/.zsh/aliases
source $HOME/.zsh/functions

source $HOME/.zsh/git
source $HOME/.zsh/javascript
source $HOME/.zsh/python

# Hook up direnv
eval "$(direnv hook zsh)"

# Turn on autocompletion, with select box
autoload -U compinit && compinit
zstyle ':completion:*' menu select

setopt autocd
hash -d go=$HOME/dev

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

