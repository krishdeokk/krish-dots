#!/usr/bin/env bash

set -e

DOTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=========================================="
echo "      Krish's Dotfiles Setup"
echo "=========================================="

# Update system
echo "[1/7] Updating system..."
sudo pacman -Syu --noconfirm

# Install official repository packages
echo "[2/7] Installing official packages..."
sudo pacman -S --needed --noconfirm \
    $(cat "$DOTS_DIR/packages-pacman.txt")

# Install yay if needed
if ! command -v yay &>/dev/null; then
    echo "[3/7] Installing yay..."

    sudo pacman -S --needed --noconfirm git base-devel

    TMPDIR=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$TMPDIR/yay"
    (
        cd "$TMPDIR/yay"
        makepkg -si --noconfirm
    )
    rm -rf "$TMPDIR"
else
    echo "[3/7] yay already installed."
fi

# Install AUR packages
echo "[4/7] Installing AUR packages..."
yay -S --needed --noconfirm \
    $(cat "$DOTS_DIR/packages-aur.txt")

# Restore user configuration
echo "[5/7] Restoring configuration..."

mkdir -p "$HOME/.config"

cp -a "$DOTS_DIR/config/caelestia" "$HOME/.config/"
cp -a "$DOTS_DIR/config/hypr" "$HOME/.config/"

# Restore wallpapers
echo "[6/7] Restoring wallpapers..."

mkdir -p "$HOME/Pictures/Wallpapers"
cp -a "$DOTS_DIR/wallpapers/." "$HOME/Pictures/Wallpapers/"

# Restore modified Caelestia system files
echo "[7/7] Restoring modified Caelestia files..."

sudo cp -a \
    "$DOTS_DIR/system/caelestia/etc/." \
    /etc/

echo ""
echo "=========================================="
echo " Setup complete!"
echo " Reboot recommended."
echo "=========================================="
