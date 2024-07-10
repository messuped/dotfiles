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
    set -x GOPATH $HOME/code/go

    # Zoxide
    if type -q zoxide
        eval (zoxide init fish)
    end


    # Zellij
    if type -q zellij
        if test "$TERM_PROGRAM" != vscode
            if not set -q ZELLIJ
                zellij a -c main
            end
        end
    end
end
