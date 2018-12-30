# My personal dotfiles

## Install instructions Ubuntu

 - sudo apt install git
 - git clone this repo
 - git submodule update --recursive init
 - sudo apt install vim-gtk3 stow fasd zsh curl gconf2
 - sudo apt install build-essential cmake python3-dev
 - dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"
 - gconftool-2 --set /apps/gnome-terminal/profiles/Default/font --type string "Fura Mono Regular Nerd Font 11"
 - stow stuff
 - chsh (/usr/bin/zsh)
 - vim +PluginInstall +qall
 - sudo apt install libncurses-dev libz-dev xz-utils libpthread-workqueue-dev
 - compile ycm :
 
      # macOS
      YCM_CORES=6 EXTRA_CMAKE_ARGS="-DEXTERNAL_LIBCLANG_PATH=$(brew --prefix llvm)/lib/libclang.dylib" python3 ./install.py --clang-completer --java-completer

      # Linux
      YCM_CORES=6 python3 ./install.py --clang-completer --java-completer

 - compile color_coded (mkdir build, cmake .., make, make install)
 - sudo apt install gnome-tweak-tool
 - set font through Tweaks (search Nerd)
 - logout/login
 - base16_monokai


## Install instructions macOS

 - brew install llvm
 - brew install fd fzf the-silver-searcher


