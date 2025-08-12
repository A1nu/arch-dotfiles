# Do not initialize prompt in non-interactive or dumb terminals
if [ -t 1 ] && [ "${TERM:-}" != "dumb" ]; then
  if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
  else
    PS1='\u@\h:\w\$ '  # Minimal fallback prompt
  fi
fi
