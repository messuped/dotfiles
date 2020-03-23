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
        ubuntu_packages=(git fish discord lutris steam obs-studio picard openjdk-8-jdk)
        sudo apt install -y 

        # Since not all packages are in the repos, we have to manually download and install any missing ones:
        wget -P ~/Downloads/discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
        wget -P ~/Downloads/vscode.deb "https://code.visualstudio.com/Download"
        wget -P ~/Downloads/lsd.deb "https://github.com/Peltoche/lsd/releases/download/0.16.0/lsd_0.16.0_amd64.deb"
        wget -P ~/Downloads/synology.deb "https://global.download.synology.com/download/Tools/SynologyDriveClient/2.0.1-11061/Ubuntu/Installer/x86_64/synology-drive-client-11061.x86_64.deb"
        wget -P ~/Downloads/vivaldi.deb "https://downloads.vivaldi.com/stable/vivaldi-stable_2.11.1811.49-1_amd64.deb"

        sudo dpkg -R --install ~/Downloads/
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