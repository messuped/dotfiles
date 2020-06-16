#!/bin/bash
# Setup error handling and logging
set -e
print_color() {
    tput setaf 2
    echo "$1"
    tput sgr0
}

print_color "Done! Configuring Fish..."
# Configure Fish as default shell
sudo chsh -s /usr/bin/fish "$USER"
# Install Oh My Fish
fish <<'END_FISH'
    fish -c "$PWD/helper_scripts/oh-my-fish.fish --noninteractive --yes"
    fish -c "omf install bobthefish"
END_FISH
# Link default configs
mkdir -p ~/.config/fish/
ln -sf "$PWD/config_files/config.fish" ~/.config/fish/config.fish

print_color "Done configuring Fish!"
set +e
