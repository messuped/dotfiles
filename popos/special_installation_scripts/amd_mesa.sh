#!/bin/bash
string=${lspci | grep -iE 'VGA|3D|video'}
if [[ $string == *"[AMD/ATI]"* ]]; then
  sudo add-apt-repository ppa:kisak/kisak-mesa -y
    sudo apt update
    sudo apt install libgl1-mesa-dri:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386 -y
fi