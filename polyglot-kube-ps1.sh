# Polyglot integration with kube-ps1 (https://github.com/jonmosco/kube-ps1)

# Check to make sure that kube-ps1 has been loaded
if ! type kube_ps1 &> /dev/null; then
  echo 'polyglot-kube-ps1: Load jonmosco/kube-ps1.' >&2 && return 1
fi

KUBE_PS1_SYMBOL_ENABLE='false'
KUBE_PS1_CTX_COLOR='yellow'

if [[ -n $ZSH_VERSION ]]; then

  _polyglot_kube_ps1_precmd() {
    local kube_ps1=$(kube_ps1)
    if [[ -n $kube_ps1 ]]; then
      print -P "%B$kube_ps1%b"
    fi
  }

  add-zsh-hook precmd _polyglot_kube_ps1_precmd

elif [[ -n $BASH_VERSION ]]; then

  _polyglot_kube_ps1_prompt_command() {
    _kube_ps1_prompt_update
    local kube_ps1=$(kube_ps1)
    [[ -n $kube_ps1 ]] && PS1="\[\033[1m\]$kube_ps1\[\033[0m\]\n$PS1"
  }

  if [[ $PROMPT_COMMAND != *_polyglot_kube_ps1_prompt_command* ]]; then
    PROMPT_COMMAND="${PROMPT_COMMAND//_kube_ps1_prompt_update\;/}"
    [[ $PROMPT_COMMAND != *\; ]] && PROMPT_COMMAND+=';'
    PROMPT_COMMAND+='_polyglot_kube_ps1_prompt_command'
  fi

fi
