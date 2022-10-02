#!/bin/bash

action="$1"
isMac=`uname -a | grep Darwin`
isLinux=`uname -a | grep Linux`

# assert action
if [ -z "$action" ]; then
    echo "Usage: $0 [software|dotfiles]"
    exit 1
fi

# setup softwares
if [ "$action" == "softwares" ]; then
    declare -a softwares=("zsh" "git" "node" "haskell-language-server" "neovim" "tldr" "tmux" "curl")

    # install homebrew if not exists on mac
    if [ ! -z "$isMac" ] && [ ! -x "$(command -v brew)" ]; then
        echo "Installing homebrew..."
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    for software in "${softwares[@]}"; do
      # check if software is installed
      if ! command -v $software &> /dev/null; then
        echo "Installing $software"
        if [ ! -z "$isMac" ]; then
          brew install $software
        elif [ ! -z "$isLinux" ]; then
          sudo apt install $software
        fi
      fi
    done

    # install oh-my-zsh if not exists
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
      echo "Installing oh-my-zsh"
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi
    
    # haskell
    # install stack if not exists
    if [ ! -x "$(command -v stack)" ]; then
      echo "Installing stack"
      curl -sSL https://get.haskellstack.org/ | sh
    fi
    # install ghcup if not exists
    if [ ! -x "$(command -v ghcup)" ]; then
      echo "Installing ghcup"
      curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
    fi
fi

# setup dotfiles
if [ "$action" == "dotfiles" ]; then
  echo "Installing dotfiles"

  # link zsh config
  ln -sf $(pwd)/.zshrc ~/.zshrc
  # link tmux config
  ln -sf $(pwd)/.tmux.conf ~/.tmux.conf
  # link wezterm config
  ln -sf $(pwd)/.wezterm.lua ~/.wezterm.lua

  # link if not exists
  if [ ! -f ~/.npmrc ]; then
    ln -sf $(pwd)/.npmrc ~/.npmrc
  fi

  # config nvim stuff
  if [ ! -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]
  then
    echo "Installing packer..."
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\
      ~/.local/share/nvim/site/pack/packer/start/packer.nvim
  fi
  
  undodir="$HOME/.vim_undo" 
  if [ ! -d $undodir ]
  then
    echo "Creating undo directory..."
    mkdir -p $undodir
    echo "Created $undodir"
  fi
  
  configdir="$HOME/.config/nvim" 
  if [ -f "$configdir/init.vim" ]
  then
    echo "Removing existing nvim config ($configdir/init.vim )..."
    rm "$configdir/init.vim" 
  fi
  
  if [ ! -d $configdir ]
  then
    echo "Creating nvim config directory..."
    mkdir -p $HOME/.config/nvim
    echo "Created $configdir"
  fi
  
  ln -sf $(pwd)/nvim.lua $configdir/init.lua
fi

echo "DONE!"
