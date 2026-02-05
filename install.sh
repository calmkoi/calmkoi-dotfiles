#!/bin/bash
# install.sh - calmkoi-dotfiles installer

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "calmkoi-dotfiles installer"
echo "--------------------------"
echo ""

echo "Dotfiles directory: $DOTFILES_DIR"
echo ""

echo "NOTE: required apps (kitty, starship, zsh) must be installed first otherwise this script will not do anything!"
echo ""

echo "Which OS are you running?"
echo "1) Linux"
echo "2) MacOS"
read -p "Enter choice: " os_choice

echo "Which theme would you like to use?"
echo "1) Debian"
echo "2) MacOS"
echo "3) Ubuntu"
read -p "Enter choice: " theme_choice

case $os_choice in
    1)
        OS="linux"
        echo "Using $OS theme"
        ;;
    2)
        OS="macos"
        echo "Using $OS theme"
        ;;
    *)
        echo "Invalid choice! Defaulting to macOS."
        OS="macos"
        ;;
esac

case $theme_choice in
    1)
        THEME="debian"
        echo "Using $THEME theme"
        ;;
    2)
        THEME="macos"
        echo "Using $THEME theme"
        ;;
    3)
        THEME="ubuntu"
        echo "Using $THEME theme"
        ;;
    *)
        echo "Invalid choice! Defaulting to debian theme."
        THEME="debian"
        ;;
esac

echo ""

# --- ZSH ---
echo "Setting up ZSH..."
if [[ -f "$DOTFILES_DIR/zsh/.$OS" ]]; then
    cp "$DOTFILES_DIR/zsh/.$OS" ~/.zshrc
    echo "Created ~/.zshrc"

else
    echo "Warning: zsh/.zshrc not found"
fi

# --- Kitty ---
echo "Setting up Kitty..."
if [[ -f "$DOTFILES_DIR/kitty/base.conf" && -f "$DOTFILES_DIR/kitty/themes/${THEME}.conf" ]]; then
    mkdir -p ~/.config/kitty
    cat "$DOTFILES_DIR/kitty/base.conf" "$DOTFILES_DIR/kitty/themes/${THEME}.conf" > ~/.config/kitty/kitty.conf
    echo "Created ~/.config/kitty/kitty.conf"
else
    echo "Warning: Kitty configs not found"
fi

# --- Alacritty ---
echo "Setting up Alacritty.."
if [[ -f "$DOTFILES_DIR/alacritty/${THEME}.toml" ]]; then
    mkdir -p ~/.config/alacritty
    cp "$DOTFILES_DIR/alacritty/${THEME}.toml" ~/.config/alacritty/alacritty.toml

    echo "Created ~/.config/alacritty/alacritty.toml"
else
    echo "Warning: Alacritty configs not found"
fi

# --- Starship ---
echo "Setting up Starship..."
STARSHIP_SRC="$DOTFILES_DIR/starship/${THEME}.toml"
if [[ -f "$STARSHIP_SRC" ]]; then
    mkdir -p ~/.config
    cp "$STARSHIP_SRC" ~/.config/starship.toml
    echo "Created ~/.config/starship.toml"
else
    echo "Warning: starship/${THEME}.toml not found"
fi

echo ""

echo "Installation complete!"