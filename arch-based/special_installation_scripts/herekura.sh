#!/bin/bash

print_color() {
    tput setaf 2
    echo "$1"
    tput sgr0
}

print_color "Installing Herecura Repository..."
sudo bash -c 'HERECURA="[herecura]
Server = https://repo.herecura.be/\$repo/\$arch";
echo "$HERECURA" >> /etc/pacman.conf'
sudo pacman -Syyuu