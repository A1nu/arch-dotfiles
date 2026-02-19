export EDITOR=nvim

if [[ -z "$SSH_CONNECTION" ]]; then
  if [[ "$SSH_AUTH_SOCK" == %h/* ]]; then
    export SSH_AUTH_SOCK="$HOME/${SSH_AUTH_SOCK#%h/}"
  fi

  if [[ -z "$SSH_AUTH_SOCK" ]] && [[ -S "$HOME/.1password/agent.sock" ]]; then
    export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"
  fi
fi
