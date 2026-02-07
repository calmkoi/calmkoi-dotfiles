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
AUTO_DISTRO=""
if [[ -n "$OSTYPE" ]]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        AUTO_OS="macos"
        echo "3) Auto-detect (MacOS)"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        AUTO_OS="linux"

        # Detect linux distribution
        if [[ -f /etc/os-release ]]; then
            source /etc/os-release
            case $ID in
                debian|ubuntu)
                    AUTO_DISTRO="$ID"
                    ;;
                arch)
                    AUTO_DISTRO="arch"
                    ;;
                fedora)
                    AUTO_DISTRO="fedora"
                    ;;
                *)
                    AUTO_DISTRO="linux"
                    ;;
            esac
            echo "3) Auto-detect (${AUTO_DISTRO})"
        else
            AUTO_DISTRO="linux"
            echo "3) Linux (auto-detect distro failed)"
        fi
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

# --- Initialise Git Submodules ---
echo "Checking and initialising git submodules..."
if [[ -f "$DOTFILES_DIR/.gitmodules" ]]; then
    (cd "$DOTFILES_DIR" && git submodule update --init --recursive 2>/dev/null || true)
    echo "Git submodules initialised"
else
    echo "No .gitmodules found"
fi
echo ""

# --- ZSH ---
if [[ "$SHELL" == "zsh" ]]; then
    echo "Setting up ZSH..."
    if [[ -f "$DOTFILES_DIR/zsh/.$OS" ]]; then
        cp "$DOTFILES_DIR/zsh/.$OS" ~/.zshrc
        echo "Created ~/.zshrc"

    else
        echo "Warning: zsh/.zshrc not found"
    fi
# --- BASH ---
elif [[ "$SHELL" == "bash" ]]; then
    echo "Setting up BASH..."
    echo "Note: bash configuration not yet implemented"
    echo ""
# --- TODO: FISH ---
elif [[ "$SHELL" == "fish" ]]; then
    echo "Setting up FISH..."
    echo "Note: fish configuration not yet implemented"
    echo ""
fi

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
    echo "Setting up alacritty..."
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
    # Clear all starship variables
    unset ACCENT_COLOR BG1_COLOR BG2_COLOR BG3_COLOR TEXT_COLOR
    unset GIT_COLOR GIT_STATUS_COLOR TIME_COLOR SUCCESS_COLOR ERROR_COLOR
    unset DOCUMENTS_ICON DOWNLOADS_ICON MUSIC_ICON PICTURES_ICON
    unset OS_ICON GIT_SYMBOL TIME_SYMBOL
    unset NODEJS RUST GOLANG PHP
    
    # Load theme colors first
    if [[ -f "$DOTFILES_DIR/starship/themes/${THEME}.env" ]]; then
        source "$DOTFILES_DIR/starship/themes/${THEME}.env"
        echo "Loaded $THEME theme colors"
    else
        echo "No theme file: starship/themes/${THEME}.env"
        # Fallback to default
        source "$DOTFILES_DIR/starship/themes/macos.env" 2>/dev/null || true
    fi
    
    # Load OS-specific settings (overrides)
    if [[ -f "$DOTFILES_DIR/starship/os/${OS}.env" ]]; then
        source "$DOTFILES_DIR/starship/os/${OS}.env"
        echo "Loaded $OS symbols and modules"
    else
        echo "No OS file: starship/os/${OS}.env"
    fi
    
    # Generate the config
    if [[ -f "$DOTFILES_DIR/starship/template.toml" ]]; then
        mkdir -p ~/.config
        
        # Use envsubst to replace all variables
        envsubst < "$DOTFILES_DIR/starship/template.toml" > ~/.config/starship.toml
        
        echo "Created ~/.config/starship.toml"
    else
        echo "Template not found: starship/template.toml"
    fi
else
    echo "Skipping starship..."
fi

echo ""

echo "Installation complete!"