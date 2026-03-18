#!/usr/bin/env fish
if status is-interactive
    set fish_greeting ""

    # Aliases
    alias dotfiles 'cd ~/dotfiles/'
    alias upstow 'cd ~/dotfiles && stow .'
    alias ls 'eza --icons --color=auto'
    alias c clear
    alias grep rg
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

    # Golang
    set -x GOPATH $HOME/code/go

    # Zoxide
    if type -q zoxide
        eval (zoxide init fish)
    end

    # K8s
    if type -q kubectl
        kubectl completion fish | source
    end

    # Fzf
    fzf --fish | source

    # Java
    alias j21='sdk use java 21.0.6-sapmchn'
    alias j17='sdk use java 17.0.5-sapmchn'
    alias j11='sdk use java 11.0.24-sapmchn'

end

set -Ux JAXWS_HOME /Users/Eduardo.Subtil/code/jaxws-ri
