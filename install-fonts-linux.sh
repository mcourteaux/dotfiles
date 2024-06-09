#!/bin/bash

VERSION="v3.2.1"

rm -rf tmp-fonts

wget https://github.com/ryanoasis/nerd-fonts/releases/download/$VERSION/RobotoMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/$VERSION/FiraCode.zip

mkdir -p tmp-fonts && cd tmp-fonts

# Fira Code
unzip ../FiraCode.zip
sudo mkdir -p /usr/share/fonts/firacode-nerdfont/
sudo mv * /usr/share/fonts/firacode-nerdfont/

unzip ../RobotoMono.zip
sudo mkdir -p /usr/share/fonts/robotomono-nerdfont/
sudo mv * /usr/share/fonts/firacode-nerdfont/

cd ..
rm -rf tmp-fonts
rm RobotoMono.zip
rm FiraCode.zip
