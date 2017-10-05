#!/bin/bash

echo "Installing HomeBrew for MacOS..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Installing zsh, tmux, nodejs, and npm..."
brew install zsh tmux nodejs npm

echo "Setting up NodeJS environment..."
sudo npm i -g n
sudo n lts
sudo npm i -g npm

echo "Setting up Github environment..."
git config --global user.name "Edward Gao"
git config --global user.email "edsperanto@users.noreply.github.com"
git config --global push.default simple
#ssh-keygen -t rsa -b 4096 -C "edsperanto@users.noreply.github.com"
#eval "$(ssh-agent -s)"
#ssh-add ~/.ssh/id_rsa
echo "Please copy ~/.ssh/id_rsa.pub to Gibhub SSH keys"
