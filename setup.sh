#!/bin/bash

# Helper Functions

# Function Update
# Updates every OS component
# @args:
#   $1 - defines which OS is running (thus which package manager to use)
function Update {
    case $1 in
        "arch" )
            # First optimize mirrors
            #pacman-mirrors --fasttrack && pacman -Syyuu --noconfirm yay
            pacman -Syu --noconfirm
        ;;
        "buntu" )
            apt update && apt upgrade -y
        ;;
        *)
            echo "Unsupported Package Manager!"
            exit 2
        ;;
    esac
}

# Function Install
# Installs a given set of programs to the OS
# @args:
#   $1 - defines which OS is running (thus which package manager to use)
#   $2 - array of programs to be installed supported by package manager
function Install {
    case $1 in
        "arch" )
            yay --noconfirm ${2[*]}
        ;;
        "buntu" )
            apt install -y ${2[*]}
        ;;
        *)
            echo "Unsupported Package Manager!"
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
        system="buntu"
    ;;
    *)
        echo "Unsupported OS!"
        exit 1
    ;;
esac

# Update
#Update $system

# Install:
programs=(ola linda e sexy Sara)
echo ${programs[*]} 

# FISH
# Steam
# Vivaldi
# Discord
# Lutris
# SynologyDrive
# LSD

# Install Fonts
git clone https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts/
./install.sh Cascadia Code

# Setup FISH:
# Configure as default shell
chsh -s /usr/bin/fish $USER
# Pass default config
mv config.fish ~/.config/fish/
# Install OMF
curl -L https://get.oh-my.fish | fish
# Setup bobthefish
omf install bobthefish