#!/bin/bash

# Setup error handling and logging
set -e

PACK_LIST_LOC="$PWD/arch-based/arch_packages"

print_color() {
    tput setaf 2
    echo "$1"
    tput sgr0
}

print_error() {
    tput setaf 1
    echo "$1"
    tput sgr0
}

update() {
    print_color "Updating packages..."
    sudo pacman-mirrors --fasttrack
    print_color "Upgrading system..."
    sudo pacman -Syyuuu --noconfirm
}

install() {

    # Special Installation Steps
    print_color "Checking if any special installation steps are required..."
    for f in "$PWD"/arch-based/special_installation_scripts/*.sh; do
        bash "$f"
    done

    # Default Repo Installation
    print_color "Installing packages from repositories..."
    mapfile -t arch_packages << $(cat "$PACK_LIST_LOC")
    eval "sudo pacman -Syu --noconfirm" "${arch_packages[@]}"
}

update
install
set +e
