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
#
# These, and not the history-search-end pair the zsh manual suggests: that one
# derives the widget to call from its own name (`zle .${WIDGET%-end}`) and
# recognises a repeat by pattern-matching $LASTWIDGET. zsh-autosuggestions
# wraps every widget and re-registers the original under a generated name, so
# in the rich class both assumptions fail -- the search restarted from the
# whole recalled line instead of the typed prefix, which is why a third Up
# stuck, Down never came back to what you were typing, and a plain history
# walk with an empty prefix jumped around. These widgets name the builtin they
# call outright and compare $LASTWIDGET against the value they saved, so the
# wrapper is invisible to them. They also step through a multi-line buffer
# before leaving it.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
for _k in '^[[A' '^[OA'; do bindkey "$_k" up-line-or-beginning-search;   done
for _k in '^[[B' '^[OB'; do bindkey "$_k" down-line-or-beginning-search; done
unset _k
