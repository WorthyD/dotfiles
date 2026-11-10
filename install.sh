#!/bin/bash
# Installs zsh, Oh My Zsh, plugins and oh-my-posh.
# Safe to run before or after makesymlinks.sh, and safe to re-run.

echo "Installing packages in the system requires sudo permission."
read -rp "Do you want to install packages?: (Y/n): " user_response
if [[ ! "$user_response" =~ ^([yY]|)$ ]]; then
    echo "Skipping installation."
    exit 0
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# zsh itself (plugins come from git below, not apt, to avoid duplicates)
echo "Installing ZSH..."
sudo apt install -y zsh git curl

# tmux + fzf for the `dev` project launcher (bin/dev)
sudo apt install -y tmux fzf

# Oh My Zsh. KEEP_ZSHRC stops the installer from replacing an existing
# ~/.zshrc (e.g. the symlink to this repo created by makesymlinks.sh).
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My ZSH..."
    KEEP_ZSHRC=yes RUNZSH=no CHSH=no \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My ZSH already installed, skipping."
fi

# Plugins: clone if missing, otherwise update
clone_or_update() {
    local url=$1 dest=$2
    if [ -d "$dest/.git" ]; then
        git -C "$dest" pull --quiet --ff-only
    else
        git clone --depth 1 "$url" "$dest"
    fi
}

echo "Installing ZSH plugins..."
clone_or_update https://github.com/zsh-users/zsh-autosuggestions.git     "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_or_update https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone_or_update https://github.com/marlonrichert/zsh-autocomplete.git    "$ZSH_CUSTOM/plugins/zsh-autocomplete"
# fast-syntax-highlighting removed: it conflicts with zsh-syntax-highlighting.

# Only touch the plugin list if ~/.zshrc is still the stock one.
# --follow-symlinks keeps a symlinked ~/.zshrc as a symlink.
if [ -f "$HOME/.zshrc" ] && grep -q '^plugins=(git)$' "$HOME/.zshrc"; then
    echo "Configuring .zshrc plugins..."
    sed -i --follow-symlinks \
        's/^plugins=(git)$/plugins=(git zsh-autosuggestions zsh-autocomplete zsh-syntax-highlighting)/' \
        "$HOME/.zshrc"
fi

# oh-my-posh
if ! command -v oh-my-posh >/dev/null 2>&1; then
    echo "Installing oh-my-posh..."
    curl -s https://ohmyposh.dev/install.sh | bash -s
fi

# Default shell
if [ "$(basename "$SHELL")" != "zsh" ]; then
    echo "Changing default shell to ZSH..."
    chsh -s "$(command -v zsh)"
fi

echo "Installation completed! Restart your terminal or run 'source ~/.zshrc'."
