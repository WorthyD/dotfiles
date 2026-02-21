#!/bin/bash

echo "Installing packages in the system requires sudo permission."
read -rp "Do you want to install packages?: (Y/n): " user_response
if [ "$user_response" = "y" ] || [ "$user_response" = "Y" ] || [ "$user_response" = "" ]; then
SUDO_VAR="yes"

#sudo apt install zsh
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


#git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search




# install ZSH and related packages
echo "Installing ZSH and related packages..."
sudo apt install zsh-autosuggestions zsh-syntax-highlighting zsh -y

# Install Oh My ZSH
echo "Installing Oh My ZSH..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install plugins
echo "Installing ZSH plugins..."

# autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# fast-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting

# autocomplete
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete

# Change .zshrc file
echo "Configuring .zshrc..."
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)/' ~/.zshrc

# switch to zsh as default shell
echo "Changing default shell to ZSH..."
chsh -s $(which zsh)

echo "Installation completed! Please restart your terminal or run 'source ~/.zshrc' to apply changes."

curl -s https://ohmyposh.dev/install.sh | bash -s

fi