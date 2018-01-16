#!/bin/bash

# Constants
DEPLOY=true
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

if [[ "$OSTYPE" == "linux-gnu"  ]]; then
    warn "Installing curl for Linux..."
    if $DEPLOY ; then
        sudo apt-get install -y curl
    fi
elif [[ "$OSTYPE" == "darwin"*  ]]; then
    warn "Installing HomeBrew for MacOS..."
    if $DEPLOY ; then
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
    fin "HomeBrew installed."
else
    # dunno yet
fi

warn "Setting up Github environment..."
if $DEPLOY ; then
  sudo git config --global user.name "Edward Gao"
  sudo git config --global user.email "edsperanto@users.noreply.github.com"
  sudo git config --global push.default simple
  # ssh-keygen -t rsa -b 4096 -C "edsperanto@users.noreply.github.com"
  # eval "$(ssh-agent -s)"
  # ssh-add ~/.ssh/id_rsa
fi
warn "----------------- Start of SSH public key -----------------"
cat ~/.ssh/id_rsa.pub
warn "------------------ End of SSH public key ------------------"
fin "\nPlease copy the above public key to to Gibhub"

warn "Copying dotfiles..."
if $DEPLOY ; then
  sh ~/dotfiles/make.sh
fi
fin "Copied dotfiles."

warn "Setting up vim environment..."
if $DEPLOY ; then
    if [[ "$OSTYPE" == "linux-gnu"  ]]; then
        sudo apt-get install -y vim
        sudo update-alternatives --config editor
    fi
    mkdir ~/.vim ~/.vim/tmp
    mkdir -p ~/.vim/autoload ~/.vim/bundle && \
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
    cd ~/.vim/bundle
    git clone https://github.com/mattn/emmet-vim.git
    git clone https://github.com/scrooloose/nerdtree.git
    git clone git://github.com/jiangmiao/auto-pairs.git
fi
fin "vim environment set up complete."

warn "Setting up NodeJS environment..."
if $DEPLOY ; then
    if [[ "$OSTYPE" == "linux-gnu"  ]]; then
        sudo apt-get install -y nodejs npm
    elif [[ "$OSTYPE" == "darwin"*  ]]; then
        brew install nodejs npm
    else
    sudo npm i -g n
    sudo n lts
    sudo npm i -g npm
fi
fin "Node environment set up complete."

warn "Setting up tmux environment..."
if $DEPLOY ; then
    if [[ "$OSTYPE" == "linux-gnu"  ]]; then
        # skip for now
        warn "Skipping tmux installation for Linux"
    elif [[ "$OSTYPE" == "darwin"*  ]]; then
        brew install tmux
    else
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
warn "Run tmux, and enter Ctrl+A + I to install plugins."
fin "tmux environment set up complete."

warn "Setting up oh-my-zsh..."
if $DEPLOY ; then
    if [[ "$OSTYPE" == "linux-gnu"  ]]; then
        sudo apt-get install -y zsh
    elif [[ "$OSTYPE" == "darwin"*  ]]; then
        brew install zsh
    else
    chsh -s $(which zsh)
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi
fin "zshell environment set up complete."
