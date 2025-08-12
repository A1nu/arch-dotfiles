# Listings
alias ls='eza --group-directories-first'
alias ll='eza -lh --group-directories-first'
alias la='eza -lha --group-directories-first'

# Pretty file viewer with syntax highlight
alias cat='bat --paging=never'

# Handy: quick TUI file manager
alias y='yazi'

# Faster search tools
alias grep='rg'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias -- -='cd -'

# Quick edit/reload
alias bashrc='${EDITOR:-nvim} ~/.bashrc'
alias reload='source ~/.bashrc'
alias c='clear'

# Git aliases
alias gp='git pull'
alias gh='git push'
alias gs='git status'
alias gco='git checkout'
alias gb='git branch'
alias gc='git commit'
alias gl="git log --graph --decorate --abbrev-commit --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"

# Network helpers
alias myip='curl -s ifconfig.me && echo'
alias speedtest='iperf3 -c speedtest.hetzner.de'
alias headers='curl -I'

# Archive helpers
alias extract='bsdtar -xvf'          # Extract any tar.* or zip file
alias zipit='zip -r'                 # Quick zip archive

# JSON pretty print
alias json='jq .'

# tmux helpers
alias tns='tmux new -s'               # new session
alias tls='tmux ls'                   # list sessions
alias ta='tmux attach -t'              # attach to session

scanlocal() {
    local subnet="${1:-192.168.1.0/24}"
    sudo nmap -sn "$subnet"
}
