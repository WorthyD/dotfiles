#!/bin/bash

echo "Installing packages in the system requires sudo permission."
read -rp "Do you want to install packages?: (Y/n): " user_response
if [ "$user_response" = "y" ] || [ "$user_response" = "Y" ] || [ "$user_response" = "" ]; then
SUDO_VAR="yes"

sudo apt install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

fi