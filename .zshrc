source $HOME/.zsh/env
source $HOME/.zsh/aliases
source $HOME/.zsh/functions

source $HOME/.zsh/git
source $HOME/.zsh/javascript
source $HOME/.zsh/python

# Hook up direnv
eval "$(direnv hook zsh)"

# Hook up asdf
. /opt/homebrew/opt/asdf/libexec/asdf.sh

# Turn on autocompletion, with select box
autoload -U compinit && compinit
zstyle ':completion:*' menu select

setopt autocd
hash -d go=$HOME/dev

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

# pnpm
export PNPM_HOME="/Users/anulman/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# emscripten
export EMSDK_QUIET=1
export EMSDK_DIR="/Users/anulman/dev/emscripten/emsdk"
source "${EMSDK_DIR}/emsdk_env.sh"
