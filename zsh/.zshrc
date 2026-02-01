# ~/.zshrc

export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/calmkoi-dotfiles/zsh/custom-plugins"
ZSH_THEME=""

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"
