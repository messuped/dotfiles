#!/usr/bin/env fish
if status is-interactive
    set fish_greeting ""

    # Aliases
    alias ls 'eza --icons --color=auto'
    alias c clear
    alias t 'tmux new-session -A -s main'
    alias grep rg
    alias find fd
    alias v nvim
    alias cat bat

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

    # Golang
    set -x PATH $PATH /usr/local/go/bin
    set -x GOPATH $HOME/code/go
    set -x PATH $PATH $GOPATH/bin

    # Zoxide
    if type -q zoxide
        eval (zoxide init fish)
    end
end
