export EDITOR=nvim

if [[ -z "$SSH_CONNECTION" ]] && [[ -z "$SSH_AUTH_SOCK" ]] && [[ -S "$HOME/.1password/agent.sock" ]]; then
  export SSH_AUTH_SOCK=~/.1password/agent.sock
fi
