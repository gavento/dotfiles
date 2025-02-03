### General settings
###############################################################################

### Init completions
# Loaded later by zimfw
#autoload -U compinit && compinit

### A simple prompt

PROMPT='%F{yellow}%n@%m%f %F{blue}%1~%f %# '

### My own functions

local functions_dir=$HOME/.config/zsh/functions
FPATH=$functions_dir:$HOME/.local/share/zsh/functions:$FPATH

local functions_list=($functions_dir/[^._]*(N:t))
if [[ -n $functions_list ]] then
    autoload -U $functions_list
fi

### History configuration

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
HISTDUP=erase
setopt append_history
#setopt share_history
setopt inc_append_history
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

### Add local paths
# Already added in .zshenv
#export PATH=$HOME/.local/bin:$PATH

### Other settings

export VISUAL=nano
export EDITOR=nano

### Zim config

export ZIM_HOME=$HOME/.config/zimfw
zstyle ':zim:zmodule' use 'degit'
zstyle ':zim' 'disable-version-check' 'true'
# Zim is only ever called manually (no automatic initialization -- everything should be in the repo already)
alias zim-fw="source $ZIM_HOME/zimfw.zsh"
# Plugins are configured and loaded later

### ZSH configuration

# Only match tab completion on the preceding characters
bindkey '\CI' expand-or-complete-prefix

setopt globdots

# ignore case
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# # set descriptions format to enable group support
# # NOTE: don't use escape sequences here, fzf-tab will ignore them
# zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
# zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# # switch group using `<` and `>`
# zstyle ':fzf-tab:*' switch-group '<' '>'

