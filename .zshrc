export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="lambda"

export PATH=$HOME/.npm-packages/bin:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH

export LC_ALL="en_US.UTF-8"
export LANG=en_US.UTF-8

plugins=(git docker npm jump)

source $ZSH/oh-my-zsh.sh

bindkey "^P" up-line-or-beginning-search
bindkey "^N" down-line-or-beginning-search

alias dk=docker
alias dc=docker-compose
alias rgf='rg --files | rg'
alias v=nvim

export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'

if [ -f /etc/env ]; then
  source /etc/env
fi

[ -f "/Users/chuangyu/.ghcup/env" ] && source "/Users/chuangyu/.ghcup/env" # ghcup-env
