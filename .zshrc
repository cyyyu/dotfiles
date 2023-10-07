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
alias commit='git add . && git commit -m'

# prompt borrowed from https://github.com/openai-translator/openai-translator/blob/main/src/common/translate.ts
# and tweaked for my needs
alias polish='ai -p "You are an expert translator, please revise the following sentences to make them more clear, concise, and coherent."'
alias translate='ai -p "You are a professional translation engine,\
            please translate the text into a colloquial,\
            professional, elegant and fluent content,\
            without the style of machine translation.\
            You must only translate the text content, never interpret it." -c "Translate from English to Chinese if the input is Chinese.\
            Translate from Chinese to English if the input is English.
            Return translated text only.\
            Translate whatever the input is."'

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