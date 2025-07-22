#!/bin/bash
set -euo pipefail

echo ">> Updating System..."
sudo pacman -Syu --noconfirm

echo ">> Installing Packages..."
sudo pacman -S --noconfirm      \
    hyprland                    \
    kitty                       \



echo ">> Enabling NetworkManager..."
sudo systemctl enable --now NetworkManager

echo ">> Creating Config Directories..."
mkdir -p $HOME/.config/hypr/scripts
mkdir -p $HOME/.config/kitty
mkdir -p $HOME/.config/rofi
mkdir -p $HOME/.config/waybar

echo ">> Copying dotfiles..."
cp -r hypr/hyprland.conf $HOME/.config/hypr/hyprland.conf
cp -r hypr/scripts/* $HOME/.config/hypr/scripts/
cp -r kitty/kitty.conf $HOME/.config/kitty/kitty.conf
cp -r rofi/* $HOME/.config/rofi/
cp -r waybar/* $HOME/.config/waybar/