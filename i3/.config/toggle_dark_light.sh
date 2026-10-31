#!/bin/bash

background="$1"


if [ $background = "dark" ]; then
    sed -i "s/^background_opacity .*/background_opacity 0.80/g" ~/.config/kitty/kitty.conf
    #kitty +kitten themes --reload-in=all "Monokai"
    kitty +kitten themes --reload-in=all "Gruvbox Material Dark Medium"



    echo "
    Net/ThemeName \"Adwaita-dark\"
    Gtk/ThemeName \"Adwaita-dark\"
    " > ~/.xsettingsd
else
    sed -i "s/^background_opacity .*/background_opacity 1.0/g" ~/.config/kitty/kitty.conf
    #kitty +kitten themes --reload-in=all "Solarized Light"
    kitty +kitten themes --reload-in=all "Leaf Light"


    echo "
    Net/ThemeName \"Radiance\"
    Gtk/ThemeName \"Radiance\"
    " > ~/.xsettingsd

fi

killall -USR1 kitty
killall -HUP xsettingsd
