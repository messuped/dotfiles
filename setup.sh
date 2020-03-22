#!/bin/bash

# Helper Functions

# Function Update
# Updates every OS component and returns list of programs to be installed
# @args:
#   $1 - defines which OS is running (thus which package manager to use)
function Update {
    case $1 in
        "arch" )
            echo "Optimizing mirrors..."
            sudo pacman-mirrors --fasttrack
            echo "Updating system and installing yay..."
            sudo pacman -Syyuu --noconfirm yay
        ;;
        "ubuntu" )
            echo "Updating packages..."
            sudo apt update
            echo "Upgrading system..."
            sudo apt upgrade -y
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
            arch_packages=(
                vivaldi vivaldi-ffmpeg-codecs vivaldi-ffmpeg-codecs code discord lutris synology-drive-client
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
            exit 2
        ;;
    esac
}

set -e


date > setup.log 

exec > setup.err                                                                      
exec 2>&1

echo "Detecting Distro..."
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
echo "Done! Your distro is ${distro[1]} !"

echo "Starting Update process..."
Update $system ${packages[*]}

echo "Done! Starting Installation process..."
Install $system

echo "Done! Making final configurations..."
sudo chsh -s /usr/bin/fish $USER
# Install OMF
curl -L https://get.oh-my.fish
# Pass default config
mv config.fish ~/.config/fish/

echo "Done! Don't forget to configure:
1. omf install bobthefish 
2. alias ls='lsd' in fish!"
set +e