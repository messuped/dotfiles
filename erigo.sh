#!/bin/bash

# Setup error handling and logging
set -e

USAGE="Usage: 
            -s: setup, update and install packages in a fresh system.
            -d: download, update local configurations with remote values.
            -u: upload, update remote configurations with local values."
OSERR="Error! Unknown OS!"

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

print_usage() {
    tput sgr0
    echo "$USAGE"
}

invoke_script() {
    # shellcheck source=/dev/null
    source "$PWD/$1"
}

detect_os() {
    os_info="$(cat /etc/os-release)" # Load OS info

    # Get Distro by extracting input's 'NAME' field and subsequently extract its value
    IFS=$'"' read -ra distro <<<"IFS=$'\n' read -ra name <<< '$os_info'"

    case ${distro[1]} in
    "Arch Linux" | "Manjaro Linux")
        invoke_script "arch-based/arch.sh"
        ;;
    "Pop!_OS")
        invoke_script "popos/popos.sh"
        ;;
    *)
        print_error "$OSERR"
        exit 1
        ;;
    esac
}

setup=''
download=''
upload=''

while getopts 'sdu' flag; do
    case "${flag}" in
    s) setup='true' ;;
    d) download='true' ;;
    u) upload='true' ;;
    *)
        print_usage
        exit 1
        ;;
    esac
done

if [ $setup ]; then
    detect_os
    invoke_script "config_scripts/config.sh"
fi

if [ $download ]; then
    invoke_script "helper_scripts/download_config.sh"
fi

if [ $upload ]; then
    invoke_script "helper_scripts/upload_config.sh"
fi

if [ $# -le 0 ]; then
    print_usage
fi

set +e
exit 0