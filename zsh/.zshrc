# ~/.zshrc

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

ZSH_CUSTOM="$HOME/calmkoi-dotfiles/zsh/custom-plugins"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"
