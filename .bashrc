
# helper functions

function c () { # Substitute for `cd`
    cd *${*}*
    pwd
    ls
}

function f () { # Find file in cwd
    find . -name "*$**"
}

function fcd() { # Find directory under cwd and cd into it
    target=$(find . -name "*$**" -type d | head -n1)
    if [ "$target" ]; then
        cd "$target"
    else
        echo "Directory not found: $*"; return
    fi
}

function p () { # Find process
    ps aux | grep "$*"
}

function g () { # Grep in cwd
    grep -Ir "$(echo $*)" .
}

function gg () { # Double-grep (grep with files resulting of the first grep)
    grep -Irl ${1} . | xargs grep -I ${2}
}

function greplace () { # Grep in cwd and replace $1 with $2 in-line
    grep -Irl "$1" . | while read i; do
        echo "Replacing: $i"
        perl -p -i -e "s/$1/$2/g" "$i"
    done
}

function random () { # Print a random number between two input values. (Default 1,n or 0,1)
    a="$1"
    b="$2"
    if [ ! "$a" ]; then
        a="0";
        b="1";
    elif [ ! "$b" ]; then
        b="$a";
        a="1";
    fi
    range="$[ $b - $a + 1]";
    echo "$[ ( $RANDOM % $range ) + $a ]";
}

# Workspace navigation functions

PROJECTS_DIR=~/dev
BIN_GO="$(which go)"
function go() { # Jump to a project (and activate environment)
    to=$1
    if [ ! "$to" ]; then
        # Go to the last go'ne destination
        to=$(grep "^go " ~/.bash_history | tail -n1 | cut -d ' ' -f2-)
    fi

    target=$PROJECTS_DIR/$to
    if [ -d $target ]; then
        cd "$target"

        # Load project profile (e.g. virtualenv)
        [ -e .profile ] && . .profile
    elif [ "$BIN_GO" ]; then
        $BIN_GO $*
        return
    fi
}

function _complete_go() { # Autocomplete function for go
    COMPREPLY=( $(compgen -W "$(ls $PROJECTS_DIR/)" -- "${COMP_WORDS[$COMP_CWORD]}") )
}
complete -F _complete_go go

BIN_GOV="$(which gov)"
function gov() { # Load a project in macvim
    to=$1
    if [ ! "$to" ]; then
        # GOV the last gov'ed destination
        to=$(grep "^gv " ~/.bash_history | tail -n1 | cut -d ' ' -f2-)
    fi

    target=$PROJECTS_DIR/$to
    if [ -d $target ]; then
        cd "$target" && mvim .
    elif [ "$BIN_GV" ]; then
        $BIN_GV $*
        return
    fi
}
complete -F _complete_go gov

function _complete_cheat() { # Autocomplet cheat sheets
    cheat = $(which cheat);
    if [ "$cheat" ]; then
        COMPREPLY=( $(cheat --list) )
    fi
}
complete -F _complete_cheat cheat

function up() { # cd to root of repository
    old_pwd="$PWD";
    while [ 1 ]; do
        cd ..
        if [ "$PWD" == "/" ]; then
            cd "$old_pwd"
            echo "No repository found, returned to $PWD"
            return 1
        fi
        for repo in ".git" ".hg"; do
            if [ -d "$repo" ]; then
                echo "Found $repo at $PWD"
                return 0;
            fi
        done
    done
}

function whois() { # whois but slightly less lame (parse domains out of urls)
    parts=(${1//\// });
    domain="${parts[1]}"

    if [ ! "$domain" ] || [[ "$domain" != *.* ]]; then
        domain="${parts[0]}"
    fi

    $(which whois) "${domain/www./}"
    return $?;
}

function chrome-unsafe() { # open chrome in unsafe mode, for ember OPTIONS etc
    open -a Google\ Chrome --args --disable-web-security;
}

function f_notifyme {
  LAST_EXIT_CODE=$?
  CMD=$(fc -ln -1)
  # No point in waiting for the command to complete
  notifyme "$CMD" "$LAST_EXIT_CODE" &
}

export PS1='$(f_notifyme)'$PS1

function indexof () {
  echo "$1" "$2" | awk '{print index($1,$2)}'
}

# tabtab source for electron-forge package
# uninstall by removing these lines or running `tabtab uninstall electron-forge`
[ -f /Users/anulman/dev/oss/ember-electron/node_modules/electron-forge/node_modules/tabtab/.completions/electron-forge.bash ] && . /Users/anulman/dev/oss/ember-electron/node_modules/electron-forge/node_modules/tabtab/.completions/electron-forge.bash

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# added by travis gem
[ -f /Users/anulman/.travis/travis.sh ] && source /Users/anulman/.travis/travis.sh
export VOLTA_HOME="/Users/anulman/.volta"
grep --silent "$VOLTA_HOME/bin" <<< $PATH || export PATH="$VOLTA_HOME/bin:$PATH"

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/__tabtab.bash ] && . ~/.config/tabtab/__tabtab.bash || true

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Get host logs for a given machine
function mg_hlog() {
  local local_fname=$1-host.log
  gsutil ls gs://host-logs/$1/logs/ | tail -n 1 | xargs -I@ gsutil cp @ ${local_fname}
  echo "Downloaded to ${local_fname}"
}

eval "$(direnv hook bash)"
