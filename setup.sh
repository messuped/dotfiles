#!/bin/bash

# Helper Functions
function Update {
    case $1 in
        "arch" )
            # First optimize mirrors
            #pacman-mirrors --fasttrack && pacman -Syyuu yay
            pacman -Syu
        ;;
        "buntu" )
            apt update && apt upgrade
        ;;
        *)
            echo "Unsupported Package Manager!"
            exit 1
        ;;
    esac
}

# Detect OS

input="$(cat /etc/os-release)" # Load OS info

# Get Distro by extracting input's 'NAME' field and subsequently extract its name
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
Update $system

# Install:

# FISH
# Steam
# Vivaldi
# Discord
# Lutris

# Install Fonts

# Setup FISH:
# Configure as default shell
# Pass default config
# Install OMF
# Setup bobthefish