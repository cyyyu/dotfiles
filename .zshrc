export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="sonicradish"

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
alias i='ai -i'
alias aicommit="ai -p 'I want you to act as a commit message generator. I will provide you with information organized in a custom git status and git diff format. Your task is to generate an appropriate commit message using the conventional git commit format. Reply only with the commit message itself and nothing else.'"

commitall() {
  if [ -n "$1" ]; then
    msg="$1"
  else
    # Combine the output of git status and git diff, and pipe it to aicommit
    combined_output=$(git status && git diff)
    msg=$(echo "$combined_output" | aicommit)
  fi

  echo -e "Generated commit message:\n\033[1;32m$msg\033[0m"
  echo "Do you want to proceed with this commit message? (Press Enter to confirm, any other key to cancel): "
  vared -p "> " -c confirm

  if [ -z "$confirm" ]; then
    git add .
    git commit -m "$msg"
    echo "Committed."
  else
    echo "Commit aborted."
  fi
}

export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'

if [ -f /etc/env ]; then
  source /etc/env
fi

[ -f "/Users/chuangyu/.ghcup/env" ] && source "/Users/chuangyu/.ghcup/env" # ghcup-env

# bun completions
[ -s "/Users/chuangyu/.bun/_bun" ] && source "/Users/chuangyu/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/chuangyu/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

if [ -f $HOME/.zshenv ]; then
  source $HOME/.zshenv
fi
