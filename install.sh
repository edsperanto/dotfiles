#!/bin/bash

# Constants
DEPLOY=false
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Functions
function warn() {
  echo "${RED}$*${NC}"
}
function fin() {
  echo "${GREEN}$*${NC}"
  read -p "Press [ENTER] to continue."
}

warn "Installing HomeBrew for MacOS..."
if $DEPLOY ; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
fin "HomeBrew installed."

warn "Installing zsh, tmux, nodejs, and npm..."
if $DEPLOY ; then
  brew install zsh tmux nodejs npm
fi
fin "zsh, tmux, node, and npm installed."

warn "Setting up NodeJS environment..."
if $DEPLOY ; then
  sudo npm i -g n
  sudo n lts
  sudo npm i -g npm
fi
fin "Node environment set up complete."

echo "${RED}Setting up Github environment...${NC}"
if $DEPLOY ; then
  sudo git config --global user.name "Edward Gao"
  sudo git config --global user.email "edsperanto@users.noreply.github.com"
  sudo git config --global push.default simple
  ssh-keygen -t rsa -b 4096 -C "edsperanto@users.noreply.github.com"
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa
fi
warn "----------------- Start of SSH public key -----------------"
cat ~/.ssh/id_rsa.pub
warn "------------------ End of SSH public key ------------------"
fin "\nPlease copy the above public key to to Gibhub"
