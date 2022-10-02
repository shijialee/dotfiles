#!/bin/sh


# link
ln -fsvn ~/.dotfiles/link/.profile             ~/.profile
ln -fsvn ~/.dotfiles/link/.bash_profile        ~/.bash_profile
ln -fsvn ~/.dotfiles/link/.bashrc              ~/.bashrc
ln -fsvn ~/.dotfiles/link/.vimrc               ~/.vimrc
ln -fsvn ~/.dotfiles/link/.vim                 ~/.vim
ln -fsvn ~/.dotfiles/link/.gitconfig           ~/.gitconfig
ln -fsvn ~/.dotfiles/link/.gitignore_global    ~/.gitignore_global
ln -fsvn ~/.dotfiles/link/.ssh/config          ~/.ssh/config
ln -fsvn ~/.dotfiles/link/.screenrc            ~/.screenrc
ln -fsvn ~/.dotfiles/link/kitty                ~/.config/kitty

# copy
# cp ~/.dotfiles/copy/    ~/

mkdir ~/.vim/.undo/ ~/.vim/.swp/ ~/.vim/.backup/
