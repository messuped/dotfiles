# Bob The Fish
set -g theme_display_git yes
set -g theme_display_git_master_branch yes
set -g theme_display_docker_machine yes
set -g theme_display_k8s_context yes
set -g theme_display_hg yes
set -g theme_display_virtualenv yes
set -g theme_display_ruby yes
set -g theme_display_nvm yes
set -g theme_display_user ssh
set -g theme_display_hostname ssh
set -g theme_display_date no
set -g theme_display_cmd_duration yes
set -g theme_title_display_process yes
set -g theme_title_display_path no
set -g theme_title_use_abbreviated_path no
set -g theme_date_format "+%a %H:%M"
set -g theme_avoid_ambiguous_glyphs yes
set -g theme_powerline_fonts no
set -g theme_nerd_fonts yes
set -g theme_show_exit_status yes
set -g theme_display_jobs_verbose yes
set -g theme_color_scheme nord
set -g theme_project_dir_length 3

# PATH environment
set -g PATH /opt/flutter/bin $PATH

# Abbreviations
abbr -a -g ls lsd
abbr -a -g ytdl youtube-dl -f bestaudio --audio-quality 0 --audio-format flac -i -x --extract-audio
abbr -a -g aptar sudo apt autoremove
abbr -a -g aptin sudo apt install
abbr -a -g aptup "sudo apt update && sudo apt upgrade"
abbr -a -g fct cd ~/Cloud/fct
abbr -a -g fish-conf code ~/.config/fish/config.fish
abbr -a -g python python3
abbr -a -g pip pip3⏎              