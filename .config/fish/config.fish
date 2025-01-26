#!/usr/bin/env fish
if status is-interactive
    set fish_greeting ""

    # Aliases
    alias ls 'eza --icons --color=auto'
    alias c clear
    alias grep rg
    alias find fd
    alias v nvim
    alias cat bat
    alias lg lazygit

    # Starship
    function starship_transient_prompt_func
        starship module character
    end
    starship init fish | source
    enable_transience

    # Homebrew
    if test -x /opt/homebrew/bin/brew
        eval (/opt/homebrew/bin/brew shellenv)
    end
    set -x HOMEBREW_NO_ENV_HINTS 1

    # Golang
    set -x GOPATH $HOME/code/go

    # Zoxide
    if type -q zoxide
        eval (zoxide init fish)
    end
    
end
