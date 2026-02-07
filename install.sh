#!/bin/bash
# install.sh - calmkoi-dotfiles installer

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "================================"
echo "|| calmkoi-dotfiles installer ||"
echo "================================"
echo ""

echo "Dotfiles directory: $DOTFILES_DIR"
echo ""

echo "NOTE: apps must be installed first otherwise this script will not do anything!"
echo ""

echo "--------------------"
echo "| OPERATING SYSTEM |"
echo "--------------------"
echo "Which OS are you running?"
echo "1) Linux"
echo "2) MacOS"
AUTO_OS=""
if [[ -n "$OSTYPE" ]]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        AUTO_OS="macos"
        echo "3) Auto-detect (MacOS)"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        AUTO_OS="linux"
        echo "3) Auto-detect (Linux)"
    else
        echo "Auto-detect OS failed"
    fi
else
    echo "Auto-detect OS failed"
fi
read -p "Enter choice: " os_choice
echo ""

echo "---------"
echo "| SHELL |"
echo "---------"
echo "Which shell would you prefer?"
echo "1) zsh"
echo "2) bash"
echo "3) fish"
read -p "Enter choice: " shell_choice
echo ""

echo "---------"
echo "| THEME |"
echo "---------"
echo "Which theme would you like to use?"
echo "1) Debian"
echo "2) MacOS"
echo "3) Ubuntu"
read -p "Enter choice: " theme_choice
echo ""

echo "-------------"
echo "| TERMINALS |"
echo "-------------"
read -p "Configure kitty? (y/n) " kitty
read -p "Configure alacritty? (y/n) " alacritty
echo ""

echo "----------------"
echo "| SHELL PROMPT |"
echo "----------------"
read -p "Configure starship? (y/n) " starship
echo ""

echo "----------------"
echo "| INSTALLATION |"
echo "----------------"

case $os_choice in
    1)
        OS="linux"
        echo "Using $OS"
        ;;
    2)
        OS="macos"
        echo "Using $OS"
        ;;
    3|"")
        if [[ -n "$AUTO_OS" ]]; then
            OS="$AUTO_OS"
            echo "Using auto-detected OS: $OS"
        else
            OS="macos"
            echo "Could not auto-detect OS, defaulting to macOS"
        fi
        ;;
    *)
        echo "Invalid choice! Defaulting to macOS."
        OS="macos"
        ;;
esac

case $shell_choice in
    1)
        SHELL="zsh"
        echo "Using $SHELL shell"
        ;;
    2)
        SHELL="bash"
        echo "Using $SHELL shell"
        ;;
    3)
        SHELL="fish"
        echo "Using $SHELL shell"
        ;;
    *)
        echo "Invalid choice! Defaulting to zsh."
        SHELL="zsh"
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

# --- Initialise Git Submodules...
echo "Checking and initialising git submodules..."
if [[ -f "$DOTFILES_DIR/.gitmodules" ]]; then
    (cd "$DOTFILES_DIR" && git submodule update --init --recursive 2>/dev/null || true)
    echo "Git submodules initialised"
else
    echo "No .gitmodules found"
fi
echo ""

# --- ZSH ---
echo "Setting up ZSH..."
if [[ -f "$DOTFILES_DIR/zsh/.$OS" ]]; then
    cp "$DOTFILES_DIR/zsh/.$OS" ~/.zshrc
    echo "Created ~/.zshrc"

else
    echo "Warning: zsh/.zshrc not found"
fi

# --- TODO: BASH ---

# --- TODO: FISH ---

# --- kitty ---
if [[ "$kitty" == "y" ]]; then
    echo "Setting up kitty..."
    if [[ -f "$DOTFILES_DIR/kitty/base.conf" && -f "$DOTFILES_DIR/kitty/themes/${THEME}.conf" ]]; then
        mkdir -p ~/.config/kitty
        cat "$DOTFILES_DIR/kitty/base.conf" "$DOTFILES_DIR/kitty/themes/${THEME}.conf" > ~/.config/kitty/kitty.conf
        echo "Created ~/.config/kitty/kitty.conf"
    else
        echo "Warning: Kitty configs not found"
    fi
else
    echo "Skipping kitty..."
fi

# --- alacritty ---
if [[ "$alacritty" == "y" ]]; then
    echo "Setting up alacritty.."
    if [[ -f "$DOTFILES_DIR/alacritty/${THEME}.toml" ]]; then
        mkdir -p ~/.config/alacritty
        cp "$DOTFILES_DIR/alacritty/${THEME}.toml" ~/.config/alacritty/alacritty.toml

        echo "Created ~/.config/alacritty/alacritty.toml"
    else
        echo "Warning: alacritty configs not found"
    fi
else
    echo "Skipping alacritty..."
fi

# --- starship ---
if [[ "$starship" == "y" ]]; then
    echo "Setting up starship..."
    STARSHIP_SRC="$DOTFILES_DIR/starship/${THEME}.toml"
    if [[ -f "$STARSHIP_SRC" ]]; then
        mkdir -p ~/.config
        cp "$STARSHIP_SRC" ~/.config/starship.toml
        echo "Created ~/.config/starship.toml"
    else
        echo "Warning: starship/${THEME}.toml not found"
    fi
else
    echo "Skipping starship..."
fi

echo ""

echo "Installation complete!"