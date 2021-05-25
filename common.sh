# We definitely don't want to use nano
export EDITOR=nvim
alias vim="nvim"

# Usual stuff
alias ...='cd ../..'
alias ....='cd ../../..'
alias cp='cp -i'                                         # Confirm before overwriting something
alias df='df -h'                                         # Human-readable sizes
alias free='free -h'                                     # Show sizes in MB
alias ls='ls --color=tty'                                # Show colors on ls
alias ip='ip -c'                                         # Show colors on ip
alias grep='grep --color=auto'                           # Show colors on grep

# A few aliases for tmux ^_^
alias tmux='tmux -u'
alias ta='tmux attach-session -t'
alias tl='tmux list-sessions'

# Let's make git more keyboard-friendly
alias ga='git add'
alias gst='git status'
alias gss='git status -s'
alias gp='git push'
alias gcl='git clone'
alias gl='git log'
alias glo='git log --oneline'

# Color man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-r

# Keyboard bindings for bash
if [[ ! -z "$BASH" ]]; then
    shopt -s autocd                                      # cd into directories without needing to type cd
    bind '"\e[3;5~":kill-word'                           # delete next word with ctrl+delete
    bind '"\C-h":backward-kill-word'                     # delete previous word with ctrl+backspace
fi

# Make a directory and cd into it in a single step
md() {
    command mkdir -p "$1" && cd "$1"
}
