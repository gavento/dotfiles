# Completion config
mkdir -p ~/.cache/zsh
zstyle ':zim:completion' dumpfile ~/.cache/zsh/zsh_dumpfile
zstyle ':completion::complete:*' cache-path ~/.cache/zsh/zcompcache

# Initialize modules if init.zsh exists
[ -f ${ZIM_HOME}/init.zsh ] && source ${ZIM_HOME}/init.zsh || echo "No zimfw/init.zsh found (zimfw not initialized?)"


