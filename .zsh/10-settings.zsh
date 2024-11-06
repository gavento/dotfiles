### General settings
###############################################################################

### Loacal path

PATH=$HOME/.local/bin:$PATH

### A simple prompt

PROMPT='%F{green}%n@%m%f %F{blue}%1~%f %# '

### History configuration

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
HISTDUP=erase
setopt append_history
setopt share_history
setopt inc_append_history
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

### Add local paths

export PATH=$HOME/.local/bin:$PATH

### Other settings

export VISUAL=nano
export EDITOR=nano

# Import files from functions/ dir (relative to this file)

for file in $( find $ZSH_DIR/functions/ -maxdepth 1 -name '*.zsh' ); do
  source $file
done
