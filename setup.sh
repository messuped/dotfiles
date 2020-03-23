#!/bin/bash

# Setup error handling and logging
set -e

OSERR="Error! Unknown OS!"
PMERR="Error! Unknown Package Manager!"
DEB_LOC="debs"
DL_TOOL="wget -4 -O"

tput setaf 2
echo "Detecting Distro..."
tput sgr0
input="$(cat /etc/os-release)" # Load OS info

# Get Distro by extracting input's 'NAME' field and subsequently extract its value
IFS=$'"' read -ra distro <<<"IFS=$'\n' read -ra name <<< '$input'"
case ${distro[1]} in
"Arch Linux" | "Manjaro Linux")
    system="arch"
    ;;
"Ubuntu" | "Pop!_OS")
    system="ubuntu"
    ;;
*)
    tput setaf 1
    echo $OSERR
    tput sgr0
    exit 1
    ;;
esac
tput setaf 2
echo "Done! Your distro is '${distro[1]}'!"
tput sgr0

tput setaf 2
echo "Starting Update process..."
tput sgr0
case $system in
"arch")
    sudo pacman-mirrors --fasttrack
    tput setaf 2
    echo "Updating system..."
    tput sgr0
    sudo pacman -Syyuu --noconfirm
    ;;
"ubuntu")
    tput setaf 2
    echo "Updating packages..."
    tput sgr0
    sudo apt update
    tput setaf 2
    echo "Upgrading system..."
    tput sgr0
    sudo apt upgrade -y
    ;;
*)
    tput setaf 1
    echo $PMERR
    tput sgr0
    exit 2
    ;;
esac

tput setaf 2
echo "Done! Starting package installation process..."
tput sgr0
case $system in
"arch")
    arch_packages=$(awk '{ print $1 }' config_files/arch_packages)
    sudo pacman -Syu --noconfirm ${arch_packages[*]}
    ;;
"ubuntu")
    ubuntu_packages=$(awk '{ print $1 }' config_files/ubuntu_packages)
    sudo apt install -y ${ubuntu_packages[*]}

    # Since not all packages are in the repos, we have to manually download and install any missing ones:
    tput setaf 2
    echo "Done! Starting .deb packages installation process..."
    tput sgr0
    deb_names=($(awk '{ print $1 }' config_files/ubuntu_debs))
    deb_addr=($(awk '{ print $2 }' config_files/ubuntu_debs))
    mkdir $DEB_LOC
    for ((i = 0; i < ${#deb_names[@]}; i++)); do
        eval "$DL_TOOL $DEB_LOC/${deb_names[$i]}.deb ${deb_addr[$i]}"
    done

    sudo dpkg -R --install $DEB_LOC

    rm -rf $DEB_LOC
    ;;
*)
    echo tput setaf 1
    $PMERR
    tput sgr0
    exit 2
    ;;
esac

tput setaf 2
echo "Done! Making final configurations..."
tput sgr0
# Configure Fish as default shell
sudo chsh -s /usr/bin/fish $USER
# Install OMF
curl -L https://get.oh-my.fish
# Pass default config
mv config_files/config.fish ~/.config/fish/

tput setaf 2
echo "Done! Don't forget to configure:
1. omf install bobthefish 
2. alias ls='lsd' in fish!"
tput sgr0
set +e
