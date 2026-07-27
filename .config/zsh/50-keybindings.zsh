### Key bindings (emacs-style line editing)

bindkey -e

# Bind literal escape sequences rather than terminfo capabilities.
#
# `bindkey ${terminfo[kLFT5]-} backward-word` looks tidy but fails silently:
# screen-256color carries no kLFT5/kRIT5 at all, and with the capability
# missing the expansion collapses to a single argument, turning the call into a
# *query* that prints "backward-word undefined-key" and binds nothing.
#
# Binding a sequence the terminal never sends is free -- it simply never fires
# -- so cover every common variant and stop caring what $TERM says.

# Ctrl+arrow, Alt+arrow, and the Alt+b/f fallbacks.
for _k in '^[[1;5D' '^[[1;3D' '^[[5D' '^[Od' '^[b'; do bindkey "$_k" backward-word; done
for _k in '^[[1;5C' '^[[1;3C' '^[[5C' '^[Oc' '^[f'; do bindkey "$_k" forward-word;  done

# Home / End. Terminals disagree, and application-keypad mode (smkx) switches
# between the ^[[ and ^[O forms mid-session, which is why these were flaky.
for _k in '^[[H' '^[[1~' '^[OH' '^[[7~'; do bindkey "$_k" beginning-of-line; done
for _k in '^[[F' '^[[4~' '^[OF' '^[[8~'; do bindkey "$_k" end-of-line;       done

bindkey '^[[3~'   delete-char
bindkey '^[[3;5~' kill-word          # Ctrl+Delete
unset _k

# TAB completes the prefix before the cursor and never opens a menu
# (see 20-completion.zsh).
bindkey '^I' expand-or-complete-prefix

# Up/Down search history for entries starting with what is already typed,
# leaving the cursor at the end of the line.
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end  history-search-end
for _k in '^[[A' '^[OA'; do bindkey "$_k" history-beginning-search-backward-end; done
for _k in '^[[B' '^[OB'; do bindkey "$_k" history-beginning-search-forward-end;  done
unset _k
