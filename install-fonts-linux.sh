#!/bin/bash

function install_nerd_fonts() {
  VERSION="v3.3.0"
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

install_nerd_fonts "FiraCode"
install_nerd_fonts "RobotoMono"
install_nerd_fonts "ComicShannsMono"
install_nerd_fonts "Gohu"
install_nerd_fonts "ProggyClean"
install_nerd_fonts "3270"
install_nerd_fonts "BigBlueTerminal"
install_nerd_fonts "Hack"
install_nerd_fonts "Hermit"
install_nerd_fonts "Iosevka"
install_nerd_fonts "Lekton"
install_nerd_fonts "ProFont"

function install_serious_shanns() {
  VERSION="v6.0.0"
  BASE="SeriousShanns"
  wget https://github.com/kaBeech/serious-shanns/releases/download/$VERSION/${BASE}$1.otf

  lowercase=$(echo "$BASE" | tr A-Z a-z)
  sudo mkdir -p /usr/share/fonts/${lowercase}-nerdfont/
  sudo mv ${BASE}$1.otf /usr/share/fonts/${lowercase}-nerdfont/
}

install_serious_shanns "NerdFontMono-Bold"
install_serious_shanns "NerdFontMono-BoldItalic"
install_serious_shanns "NerdFontMono-Italic"
install_serious_shanns "NerdFontMono-Light"
install_serious_shanns "NerdFontMono-LightItalic"
install_serious_shanns "NerdFontMono-Regular"

