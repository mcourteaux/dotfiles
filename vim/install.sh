#!/bin/sh

origpwd=$(pwd)
git clone https://github.com/mcourteaux/mc-vim.git ~/.mc-vim/
cd ~
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.Vim
ln -s ~/.mc-vim/mc.vimrc .vimrc
mkdir -p ~/.vim/
ln -s ~/.mc-vim/ftplugin ftplugin
vim +PluginInstall +qall
cd $origpwd
