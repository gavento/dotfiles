if (( $+commands[batcat] )); then
  alias bat="$(which batcat)"
  export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
elif (( $+commands[batcat] )); then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
else
  alias bat="$(which cat)"
fi