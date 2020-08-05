#!/bin/bash

# Setup error handling and logging
set -e

PACK_LIST_LOC="$PWD/popos/popos_packages"
DEB_LIST_LOC="$PWD/popos/popos_debs"
DEB_LOC="$PWD/debs"
DL_TOOL="wget -4 -O"

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
    sudo apt update
    print_color "Upgrading system..."
    sudo apt upgrade -y
}

install() {


    # Default Repo Installation
    print_color "Installing packages from repositories..."
    mapfile -t popos_packages < <(cat "$PACK_LIST_LOC")
    eval "sudo apt install -y" "${popos_packages[@]}"

    # Deb Installation Steps
    print_color "Done! Starting .deb packages download process..."
    mapfile -t debs < <(cat "$DEB_LIST_LOC")
    mkdir "$DEB_LOC"
    for deb in "${debs[@]}"; do
        IFS=" " read -r -a deb_arr <<<"$deb"
        print_color "Downloading ${deb_arr[0]} from ${deb_arr[1]}"
        eval "$DL_TOOL $DEB_LOC/${deb_arr[0]}.deb ${deb_arr[1]}"
    done

    print_color "Done! Starting .deb packages installation..."
    sudo dpkg -R --install "$DEB_LOC"

    print_color "Done! Cleaning up..."
    rm -rf "$DEB_LOC"
}

update
install
update
set +e
