#!/bin/bash

action="$1"

# assert action
if [ -z "$action" ]; then
    echo "Usage: $0 [software|dotfiles]"
    exit 1
fi

# setup softwares
if [ "$action" == "softwares" ]; then
    echo "Installing softwares"

    softwares='zsh git node haskell-language-server neovim tldr tmux curl'
    
    # mac
    if [ "$(uname)" == "Darwin" ]; then
      # install brew
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
      # install everything
      brew install ${softwares}
    fi
    # linux
    if [ "$(uname)" == "Linux" ]; then
      # install everything
      sudo apt-get ${softwares}
    fi

    # install oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    
    # haskell
    # install stack
    curl -sSL https://get.haskellstack.org/ | sh
    # hindent
    stack install hindent
    # ghcup
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
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
