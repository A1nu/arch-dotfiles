# Check if fzf key bindings exist
if [ -f /usr/share/fzf/key-bindings.bash ]; then
    source /usr/share/fzf/key-bindings.bash
fi

# Check if fzf completion exists
if [ -f /usr/share/fzf/completion.bash ]; then
    source /usr/share/fzf/completion.bash
fi

# Enable bash-completion if installed
if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
fi

# Set FZF default command to use fd for faster searching
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Preview file content with bat in search results
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
