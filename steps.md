 - sudo apt install git
 - sudo apt install vim
 - sudo apt install stow
 - sudo apt install fasd
 - sudo apt install zsh
 - sudo apt install curl
 - sudo apt install gconftool-2
 - dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"
 - gconftool-2 --set /apps/gnome-terminal/profiles/Default/font --type string "Fura Mono Regular Nerd Font 11"

 - curl -L -o /tmp/FiraMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FiraMono.zip

 - stow stuff
 - vim +Plugininstall +qall
