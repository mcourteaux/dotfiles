#!/bin/bash

VERSION="v3.2.1"

function install() {
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/$VERSION/$1.zip

  rm -rf tmp-fonts
  mkdir -p tmp-fonts && cd tmp-fonts

  unzip ../$1.zip
  lowercase=$(echo "$1" | tr A-Z a-z)
  sudo mkdir -p /usr/share/fonts/${lowercase}-nerdfont/
  sudo mv * /usr/share/fonts/${lowercase}-nerdfont/

   cd ..
   rm -rf tmp-fonts
   rm $1.zip
}

install "FiraCode"
install "RobotoMono"
install "ComicShannsMono"

