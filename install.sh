#!/bin/bash

# mac
if [ "$(uname)" == "Darwin" ]; then
  # install brew
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  # install zsh, git
  brew install zsh git
  # install node
  brew install node
  # install haskell-language-server
  brew install haskell-language-server
  # install neovim
  brew install neovim
  # install tldr
  brew install tldr
  # install tmux
  brew install tmux
  # install curl
  brew install curl
fi
# linux
if [ "$(uname)" == "Linux" ]; then
  # install zsh, git
  sudo apt-get install zsh git
  # install node
  sudo apt-get install node
  # install haskell-language-server
  sudo apt-get install haskell-language-server
  # install neovim
  sudo apt-get install neovim
  # install tldr
  sudo apt-get install tldr
  # install tmux
  sudo apt-get install tmux
  # install curl
  sudo apt-get install curl
fi

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# link zsh config
ln -sf $(pwd)/.zshrc ~/.zshrc
# link tmux config
ln -sf $(pwd)/.tmux.conf ~/.tmux.conf

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
# done config nvim
