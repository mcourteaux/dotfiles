# My personal dotfiles

## Install instructions Ubuntu

 - sudo apt install git
 - git clone this repo
 - git submodule update --recursive --init
 - sudo apt install vim-gtk3 stow fasd zsh curl gconf2 gnome-tweak-tool build-essential cmake python3-dev silversearcher-ag libncurses-dev libz-dev xz-utils libpthread-workqueue-dev xclip dmenu rxvt-unicode-256color i3status feh compton zathura
 - install linuxbrew
 - brew install fzf (yes yes yes)
 - install fd (.deb)
 # - dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"
 - add option "caps:escape" to /etc/defaults/keyboard
 - gconftool-2 --set /apps/gnome-terminal/profiles/Default/font --type string "Fura Mono Regular Nerd Font 11"
 - stow stuff
 - chsh (/usr/bin/zsh)
 - vim +PluginInstall +qall
 - compile ycm :
 
      # macOS
      YCM_CORES=6 EXTRA_CMAKE_ARGS="-DEXTERNAL_LIBCLANG_PATH=$(brew --prefix llvm)/lib/libclang.dylib" python3 ./install.py --clang-completer --java-completer

      # Linux
      YCM_CORES=6 python3 ./install.py --clang-completer --java-completer

 - compile color_coded (mkdir build, cmake .., make, make install)
 - set font through Tweaks (search Nerd)
 - logout/login
 - base16_monokai


## Install instructions macOS

 - brew install llvm
 - brew install fd fzf the-silver-searcher


