export ZSH_DIR=$HOME/.config/zsh

### Include configuration modules, in order

for script in $( ls "${ZSH_DIR}"/[0-9][0-9]-*.zsh | sort ); do
    [ -e "$script" ] && source "$script"
done

