# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export LANG='en_US.UTF-8'
export LANGUAGE='en_US:en'
export LC_ALL='en_US.UTF-8'
export TERM=xterm-256color
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(nano {})+abort'"
export NVM_DIR="$HOME/.nvm"

export ZSH="/root/.oh-my-zsh"

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
    git
    kubectl
    terraform
)

source $ZSH/oh-my-zsh.sh
source ~/powerlevel10k/powerlevel10k.zsh-theme
source /root/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias python="python3"
alias cat="batcat"
alias top="htop"
alias k="kubectl"
alias gs="git status"
alias tf="terraform"
alias tg="terragrunt"
alias preview="fzf --preview 'cat {}'"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.custom.zsh ] && source ~/.custom.zsh
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
