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
            sudo pacman-mirrors --fasttrack >> setup.log 2>&1
            echo "Updating system and installing yay..."
            sudo pacman -Syyuu --noconfirm yay >> setup.log 2>&1
        ;;
        "ubuntu" )
            echo "Updating packages..."
            sudo apt update >> setup.log 2>&1
            echo "Upgrading system..."
            sudo apt upgrade -y >> setup.log 2>&1
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
            yay -Syu --noconfirm ${arch_packages[*]} >> setup.log 2>&1
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
echo date > setup.log 
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

echo "Done! Installing fonts...$'\n'"
git clone https://github.com/ryanoasis/nerd-fonts.git .nerd-fonts >> setup.log 2>&1
cd .nerd-fonts/
./install.sh Cascadia Code >> setup.log 2>&1

echo "Done! Making final configurations..."
sudo chsh -s /usr/bin/fish $USER >> setup.log 2>&1
# Install OMF
curl -L https://get.oh-my.fish | fish >> setup.log 2>&1
# # Setup bobthefish
omf install bobthefish >> setup.log 2>&1
# Pass default config
mv config.fish ~/.config/fish/

echo "Done! Don't forget to configure alias ls='lsd' in fish!"
set +e