#!/bin/bash

# variables
dir=~/dotfiles
olddir=~/dotfiles_old
files="bashrc vimrc zshrc zshenv tmux.conf"

# create backup
echo "Moving existing dotfiles to $olddir"
mkdir -p $olddir
for file in $files; do
	echo "Moving $file to $olddir"
	mv ~/.$file $olddir/
done

# create symbolic links
echo "Creating symbolic links"
for file in $files; do
	echo "Linking ~/.$file to $dir/$file"
	ln -s $dir/$file ~/.$file
done
