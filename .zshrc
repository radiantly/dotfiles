# zmodload zsh/zprof

# Options section
setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
setopt nocaseglob                                               # Case insensitive globbing
setopt rcexpandparam                                            # Array expension with parameters
setopt nocheckjobs                                              # Don't warn about running processes when exiting
setopt numericglobsort                                          # Sort filenames numerically when it makes sense
setopt nobeep                                                   # No beep
setopt appendhistory                                            # Immediately append history instead of overwriting
setopt histignorealldups                                        # If a new command is a duplicate, remove the older one
setopt histignorespace                                          # Do not store commands that start with a space
setopt sharehistory                                             # Share history across terminals
setopt incappendhistory                                         # Immediately append history to file
setopt autocd                                                   # if only directory path is entered, cd there.

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' rehash true                              # automatically find new executables in path 
# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
HISTFILE=~/.zhistory
HISTSIZE=15000
SAVEHIST=10000
WORDCHARS=${WORDCHARS//\/[&.;]}                                 # Don't consider certain characters part of the word

## Keybindings section
bindkey -v
bindkey ' ' magic-space                                         # Expand history expansion on space
bindkey '^[[7~' beginning-of-line                               # Home key
bindkey '^[[H' beginning-of-line                                # Home key
bindkey '^[[8~' end-of-line                                     # End key
bindkey '^[[F' end-of-line                                      # End key
bindkey '^[[2~' overwrite-mode                                  # Insert key
bindkey '^[[3~' delete-char                                     # Delete key
bindkey '^[[C'  forward-char                                    # Right key
bindkey '^[[D'  backward-char                                   # Left key
bindkey '^[[5~' history-beginning-search-backward               # Page up key
bindkey '^[[6~' history-beginning-search-forward                # Page down key

# Navigate words with ctrl+arrow keys
bindkey '^[Oc' forward-word                                     #
bindkey '^[Od' backward-word                                    #
bindkey '^[[1;5D' backward-word                                 #
bindkey '^[[1;5C' forward-word                                  #
bindkey '^[[3;5~' kill-word                                     # delete next word with ctrl+delete
bindkey '^H' backward-kill-word                                 # delete previous word with ctrl+backspace
bindkey '^[[Z' undo                                             # Shift+tab undo last action

autoload -Uz compinit                                           # compinit can be found in $fpath
compinit                                                        # Enable zsh completions

## Plugins section: Enable fish style features
# z.lua
eval "$(lua /usr/share/z.lua/z.lua --init zsh enhanced fzf once)"

# Use zsh autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh

# Use syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_STYLES[command]=fg=white,bold

# Use history substring search
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
export HISTORY_SUBSTRING_SEARCH_FUZZY=1

# Bind UP and DOWN arrow keys to history substring search
bindkey '^[[A' history-substring-search-up			
bindkey '^[[B' history-substring-search-down

# Load the usual
source ~/Documents/gitHub/dotfiles/common.sh
source ~/Documents/gitHub/dotfiles/mystuff.zsh

# We don't load nvm right away because it takes up 95% of zsh's startup time
nvm() {
  unfunction nvm
  source /usr/share/nvm/init-nvm.sh
  nvm "$@"
}

# Start docker service if it isn't running already
docker() {
  unfunction docker
  systemctl is-active --quiet docker || sudo systemctl start docker
  docker "$@"
}

# Completion for kitty
kitty + complete setup zsh | source /dev/stdin

# Load keys
export GPG_TTY=$(tty)
eval $(keychain --eval --noask --quiet --agents ssh,gpg github 6B113D80D68C409C)

# Starship
eval "$(starship init zsh)"

# zprof
