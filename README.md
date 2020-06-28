# My personal dotfiles

## Install instructions Ubuntu

 - sudo apt install git
 - git clone this repo
 - git submodule update --recursive --init
 - sudo apt install vim-gtk3 stow fasd zsh curl gconf2 gnome-tweak-tool build-essential cmake python3-dev silversearcher-ag libncurses-dev libz-dev xz-utils libpthread-workqueue-dev xclip rxvt-unicode-256color i3status feh compton zathura xdotool playerctl ctags
 - To install emoji-keyboards support:
   - sudo apt install fonts-emojione rofi xdotool xsel
   - Download release from: https://github.com/fdw/rofimoji/releases
   - Install wheel: pip3 install rofimoji-....
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
 - brew install fd fzf the-silver-searcher ctags

# Fixing the Keychron K2 under Linux

Set keyboard in Linux-mode (hardware switch).

    echo "options hid_apple fnmode=0 swap_opt_cmd=0" | sudo tee /etc/modprobe.d/hid_apple.conf
    sudo update-initramfs -u

And reboot. To do the same at runtime:

    echo 0 | sudo tee /sys/module/hid_apple/parameters/swap_opt_cmd
    echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode

To use Azerty:

    setxkbmap -layout be
