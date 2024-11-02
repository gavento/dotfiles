_EZA_OPTS="-bB --git --icons=never --hyperlink --time-style=relative"
_LSD_OPTS="--icon=never --size bytes"
_LS_OPTS="--color=auto"

if (( $+commands[lsd] )); then
  alias ll="lsd $_LSD_OPTS -l"
  alias la="lsd $_LSD_OPTS -la"
  alias lS="lsd $_LSD_OPTS -la -Sr"
  alias lU="lsd $_LSD_OPTS -la -Sr --total-size"
  alias lT="lsd $_LSD_OPTS -la -tr"
elif (( $+commands[eza] )); then
  alias ll="eza $_EZA_OPTS -l"
  alias la="eza $_EZA_OPTS -la"
  alias lS="eza $_EZA_OPTS -la -ssize"
  alias lU="eza $_EZA_OPTS -la -ssize --total-size"
  alias lT="eza $_EZA_OPTS -la -snewest"
else
  alias ll="ls $_LS_OPTS -l"
  alias la="ls $_LS_OPTS -la"
  alias lS="ls $_LS_OPTS -la -Sr"
  #alias lU="ls $_LS_OPTS -la -Sr --total-size"
  alias lT="ls $_LS_OPTS -la -tr"
fi

unset _EZA_OPTS
unset _LSD_OPTS
unset _LS_OPTS
