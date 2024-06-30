# Execute tmux automatically if using Alacritty
if [ "$TERM_PROGRAM" != "vscode" ]; then
    if [ -z "$TMUX" ]; then
        tmux new-session -A -s main
    fi
fi

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Golang
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/code/go
export PATH=$PATH:$GOPATH/bin

# PROMPT
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
    eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/oh-my-posh.toml)"
fi

# TMUX PLUGIN MANAGER
TMUX_HOME="${XDG_DATA_HOME:-${HOME}}/.tmux/plugins/tpm"

if [ ! -d "$TMUX_HOME" ]; then
    mkdir -p "$(dirname $TMUX_HOME)"
    git clone https://github.com/tmux-plugins/tpm "$TMUX_HOME"
fi

# ZINIT PLUGIN MANAGER
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Load completions
autoload -U compinit && compinit
zinit cdreplay -q

# Keybindings
bindkey '^f' autosuggest-accept
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}'
zstyle ':completion:*' menu
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias c='clear'
alias t='tmux new-session -A -s main'
alias grep='ripgrep'
alias find='fd'
alias v='nvim'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# Adjust the completion behavior for special directories like '~' and '..'
zstyle ':completion:*' special-dirs true

