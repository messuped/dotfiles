#!/bin/bash

# Helper Functions

# Function Update
# Updates every OS component and returns list of programs to be installed
# @args:
#   $1 - defines which OS is running (thus which package manager to use)
function Update {
    case $1 in
        "arch" )
            # First optimize mirrors
            pacman-mirrors --fasttrack && pacman -Syyuu --noconfirm yay
            arch_packages=(vivaldi vivaldi-ffmpeg-codecs vivaldi-ffmpeg-codecs code discord lutris synology-drive-client lsd obs-studio jdk8-openjdk picard fish)
            command="yay -Syu --noconfirm ${arch_packages[*]}"
        ;;
        "ubuntu" )
            apt update && apt upgrade -y
            ubuntu_packages=()
            command="apt install -y ${ubuntu_packages[*]}"
        ;;
        *)
            exit 1
        ;;
    esac
    
    
    echo ${command[*]}
}

# Function Install
# Installs a given set of programs to the OS
# @args:
#   $1 - defines which OS is running (thus which package manager to use)
function Install {
    case $1 in
        "arch" )
            eval ${2[*]}
        ;;
        "ubuntu" )
            # Since not all packages are in the repos, we have to manually download and install them
            apt install -y ${2[*]}
        ;;
        *)
            exit 2
        ;;
    esac
}

# Detect OS
input="$(cat /etc/os-release)" # Load OS info

# Get Distro by extracting input's 'NAME' field and subsequently extract its value
IFS=$'"' read -ra distro <<< "IFS=$'\n' read -ra name <<< '$input'"

case ${distro[1]} in
    "Arch Linux" | "Manjaro Linux" )
        system="arch"
    ;;
    "Ubuntu" | "Pop!_OS" )
        system="ubuntu"
    ;;
    *)
        echo "Unsupported OS!"
        exit 1
    ;;
esac

# Update
command=$(Update $system ${packages[*]})

# Install:
Install $system ${command[*]}

# # Install Fonts
# git clone https://github.com/ryanoasis/nerd-fonts.git .nerd-fonts
# cd .nerd-fonts/
# ./install.sh Cascadia Code

# # Setup FISH:
# # Configure as default shell
# chsh -s /usr/bin/fish $USER
# # Pass default config
# mv config.fish ~/.config/fish/
# # Install OMF
# curl -L https://get.oh-my.fish | fish
# # Setup bobthefish
# omf install bobthefish

echo "Don't forget to configure alias ls='lsd' in fish!"