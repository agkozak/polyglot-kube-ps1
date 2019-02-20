KUBE_PS1_SYMBOL_ENABLE='false'
KUBE_PS1_CTX_COLOR='yellow'

if [[ -n $ZSH_VERSION ]]; then

  # In ZSH, kube-ps1 must be sourced first or the Kubernetes prompt info will not
  # appear in the first prompt displayed.
  if ! whence -w kube_ps1 &> /dev/null; then
    print 'polyglot-kube-ps1: Source jonmosco/kube-ps1 first.' >&2
  fi

  _polyglot_kube_ps1_precmd() {
    local kube_ps1=$(kube_ps1)
    if [[ -n $kube_ps1 ]]; then
      print -P "%B$kube_ps1%b"
    fi
  }

  add-zsh-hook precmd _polyglot_kube_ps1_precmd

elif [[ -n $BASH_VERSION ]]; then

  _polyglot_kube_ps1_prompt_command() {
    _kube_ps1_update_cache
    PS1="\[\033[1m\]$(kube_ps1)\[\033[0m\]\n$PS1"
  }

  if [[ $PROMPT_COMMAND != *_polyglot_kube_ps1_prompt_command* ]]; then
    PROMPT_COMMAND="${PROMPT_COMMAND//_kube_ps1_update_cache\;/}"
    PROMPT_COMMAND+='; _polyglot_kube_ps1_prompt_command'
  fi

fi
