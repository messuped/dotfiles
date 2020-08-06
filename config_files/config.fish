# Shell Theme
set -g fish_color_normal normal
set -g fish_color_command 81a1c1
set -g fish_color_quote a3be8c
set -g fish_color_redirection b48ead
set -g fish_color_end 88c0d0
set -g fish_color_error ebcb8b
set -g fish_color_param eceff4
set -g fish_color_comment 434c5e
set -g fish_color_match --background=brblue
set -g fish_color_selection white --bold --background=brblack
set -g fish_color_search_match bryellow --background=brblack
set -g fish_color_history_current --bold
set -g fish_color_operator 00a6b2
set -g fish_color_escape 00a6b2
set -g fish_color_cwd green
set -g fish_color_cwd_root red
set -g fish_color_valid_path --underline
set -g fish_color_autosuggestion 4c566a
set -g fish_color_user brgreen
set -g fish_color_host normal
set -g fish_color_cancel -r
set -g fish_pager_color_completion normal
set -g fish_pager_color_description B3A06D yellow
set -g fish_pager_color_prefix white --bold --underline
set -g fish_pager_color_progress brwhite --background=cyan

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

# Abbreviations
abbr -a -g ls lsd
abbr -a -g ytdl youtube-dl 
abbr -a -g ytdla youtube-dl -f bestaudio --audio-quality 0 --audio-format flac -i -x --extract-audio
abbr -a -g fct cd ~/Cloud/fct
abbr -a -g config-fish code ~/.config/fish/config.fish
abbr -a -g python python3
abbr -a -g pip pip3     

# Ubuntu-specific abbreviations
abbr -a -g aptar sudo apt autoremove
abbr -a -g aptin sudo apt install -y
abbr -a -g aptup "sudo apt update && sudo apt upgrade -y"  
abbr -a -g aptpr "sudo apt purge -y"
abbr -a -g apts "apt search"