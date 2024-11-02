export ZSH_DIR=$HOME/.zsh

### Include configuration modules, in order

for script in $( ls "${HOME}/.zsh"/[0-9][0-9]-*.zsh | sort ); do
    echo importing $script ...
    [ -e "$script" ] && source "$script"
done

