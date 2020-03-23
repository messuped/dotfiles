#!/bin/bash

# Setup error handling and logging
set -e

OSERR="Error! Unknown OS!"
PMERR="Error! Unknown Package Manager!"

tput setaf 2; echo "Detecting Distro..."; tput sgr0
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
        tput setaf 1; echo $OSERR; tput sgr0
        exit 1
    ;;
esac
tput setaf 2; echo "Done! Your distro is '${distro[1]}'!"; tput sgr0

tput setaf 2; echo "Starting Update process..."; tput sgr0
case $system in
    "arch" )
        sudo pacman-mirrors --fasttrack
        tput setaf 2; echo "Updating system and installing yay..."; tput sgr0
        sudo pacman -Syyuu --noconfirm yay
    ;;
    "ubuntu" )
        tput setaf 2; echo "Updating packages..."; tput sgr0
        sudo apt update
        tput setaf 2; echo "Upgrading system..."; tput sgr0
        sudo apt upgrade -y
    ;;
    *)
        tput setaf 1; echo $PMERR; tput sgr0
        exit 2
    ;;
esac

tput setaf 2; echo "Done! Starting Installation process..."; tput sgr0
case $system in
    "arch" )
        arch_packages=(vivaldi vivaldi-ffmpeg-codecs vivaldi-ffmpeg-codecs code discord lutris synology-drive-client 
            lsd obs-studio jdk8-openjdk picard fish
        )
        yay -Syu --noconfirm ${arch_packages[*]}
    ;;
    "ubuntu" )
        ubuntu_packages=()
        command="apt install -y ${ubuntu_packages[*]} >> setup.log 2>&1"

        # Since not all packages are in the repos, we have to manually download and install any missing ones
    ;;
    *)
        echo tput setaf 1; $PMERR; tput sgr0
        exit 2
    ;;
esac

tput setaf 2; echo "Done! Making final configurations..."; tput sgr0
sudo chsh -s /usr/bin/fish $USER
# Install OMF
curl -L https://get.oh-my.fish | fish
# Pass default config
mv config.fish ~/.config/fish/

tput setaf 2; echo "Done! Don't forget to configure:
1. omf install bobthefish 
2. alias ls='lsd' in fish!"; tput sgr0
set +e