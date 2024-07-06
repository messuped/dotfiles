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

    # Execute tmux automatically if using Alacritty
    if test "$TERM_PROGRAM" != vscode
        if not set -q TMUX
            tmux new-session -A -s main \; source-file ~/.tmux.conf
        end
    end

    # Homebrew
    if test -x /opt/homebrew/bin/brew
        eval (/opt.homebrew/bin/brew shellenv)
    end

    # Golang
    set -x PATH $PATH /usr/local/go/bin
    set -x GOPATH $HOME/code/go
    set -x PATH $PATH $GOPATH/bin

    # TMUX Plugin Manager
    if set -q XDG_DATA_HOME
        set -gx TMUX_HOME $XDG_DATA_HOME/.tmux/plugins/tpm
    else
        set -gx TMUX_HOME $HOME/.tmux/plugins/tpm
    end

    if not test -d "$TMUX_HOME"
        mkdir -p (dirname "$TMUX_HOME")
        git clone https://github.com/tmux-plugins/tpm "$TMUX_HOME"
    end

    if type -q zoxide
        eval (zoxide init fish)
    end
end
