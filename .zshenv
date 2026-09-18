# XDG base directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Default editor used by git, crontab, etc.
export EDITOR="nvim"
export VISUAL="nvim"

# Starship
export STARSHIP_CONFIG="$HOME/.config/starship.toml"

# PATH
if [[ -x "/opt/homebrew/bin/brew" ]]; then
  eval "$("/opt/homebrew/bin/brew" shellenv)"
elif [[ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
  eval "$("/home/linuxbrew/.linuxbrew/bin/brew" shellenv)"
fi
export PATH="$HOME/.local/bin:$PATH"

# Pager
export MANPAGER="bat -l man -p"

# Opencode / AI
export OPENCODE_CONFIG="$HOME/.config/opencode/opencode.private.json"
export COLI_MODEL="$HOME/models/glm52_i4"

# Secrets (not tracked in dotfiles)
[[ -f ~/.config/zsh/secrets.zshenv ]] && source ~/.config/zsh/secrets.zshenv

# Work-specific env vars (not tracked in dotfiles)
[[ -f ~/.config/zsh/work.zshenv ]] && source ~/.config/zsh/work.zshenv
