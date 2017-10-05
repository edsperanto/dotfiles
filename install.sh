#!/bin/bash

DEPLOY=false
RED='\033[0;31m'
NC='\033[0m'

echo "${RED}Installing HomeBrew for MacOS...${NC}"
if $DEPLOY ; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "${RED}Installing zsh, tmux, nodejs, and npm...${NC}"
if $DEPLOY ; then
  brew install zsh tmux nodejs npm
fi

echo "${RED}Setting up NodeJS environment...${NC}"
if $DEPLOY ; then
  sudo npm i -g n
  sudo n lts
  sudo npm i -g npm
fi

echo "${RED}Setting up Github environment...${NC}"
if $DEPLOY ; then
  git config --global user.name "Edward Gao"
  git config --global user.email "edsperanto@users.noreply.github.com"
  git config --global push.default simple
  ssh-keygen -t rsa -b 4096 -C "edsperanto@users.noreply.github.com"
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa
fi
echo "${RED}Please copy ~/.ssh/id_rsa.pub to Gibhub SSH keys${NC}"
