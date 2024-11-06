# Zim config
export ZIM_HOME=$HOME/.config/zimfw
zstyle ':zim:zmodule' use 'degit'
zstyle ':zim' 'disable-version-check' 'true'

# Completion config
zstyle ':zim:completion' dumpfile ~/.cache/zsh/zsh_dumpfile
zstyle ':completion::complete:*' cache-path ~/.cache/zsh/zcompcache

# Initialize modules if init.zsh exists
[ -f ${ZIM_HOME}/init.zsh ] && source ${ZIM_HOME}/init.zsh || echo "No zimfw/init.zsh found (zimfw not initialized?)"

# To be called manually (no automatic initialization -- everything should be in the repo already)
alias zim-fw="source $ZIM_HOME/zimfw.zsh"
