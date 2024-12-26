#!/bin/bash

# ------------------------------------------------------
# Synchronize mirrors
# ------------------------------------------------------
pacman -Syy

# 1. setup ml4w-hyprland
# ------------------------------------------------------
clear
bash <(curl -s https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/setup-arch.sh)

# ------------------------------------------------------
# clash-verge-bin、输入法、keyd、wechat、obsidian、google、vnc、tmux、office
# 中文字体、lazynvim nerd-font 字体包
# flameshot-git、libreOffice、mpv
# ------------------------------------------------------

# ------------------------------------------------------
# Install Packages
# ------------------------------------------------------
pacman --noconfirm -S fcitx5-im fcitx5-chinese-addons keyd libreoffice-still libreoffice-still-zh-cn obsidian tmux wqy-zenhei wqy-microhei
yay -S --noconfirm clash-verge-rev-bin google-chrome realvnc-viewer wechat-bin mpv flameshot-git nvm

# https://github.com/tickstep/aliyunpan (aliyunpan TUI)

# ------------------------------------------------------
# 配置ml4w
# 配置快捷键和custom.conf 2个文件
# ------------------------------------------------------

# ------------------------------------------------------
# 配置keyd
# ------------------------------------------------------

# ------------------------------------------------------
# 配置nvim
# ------------------------------------------------------

# ------------------------------------------------------
# 配置git
# ------------------------------------------------------

# ------------------------------------------------------
# 配置tmux
# ------------------------------------------------------

# ------------------------------------------------------
# Copy installation scripts to home directory
# ------------------------------------------------------
# cp /archinstall/3-yay.sh /home/$username

clear
echo "     _                   "
echo "  __| | ___  _ __   ___  "
echo " / _' |/ _ \| '_ \ / _ \ "
echo "| (_| | (_) | | | |  __/ "
echo " \__,_|\___/|_| |_|\___| "
echo "                         "
echo ""
echo "please reboot!!!"
