#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

echo "==> Criando backup..."
mkdir -p "$BACKUP/.config"

CONFIGS=(
    fastfetch
    hypr
    kitty
    waybar
    wofi
    cava
)

# Backup das configurações
for dir in "${CONFIGS[@]}"; do
    if [ -e "$HOME/.config/$dir" ]; then
        mv "$HOME/.config/$dir" "$BACKUP/.config/"
        echo "Backup: $dir"
    fi
done

# Backup dos wallpapers
if [ -d "$HOME/wallpaper" ]; then
    mv "$HOME/wallpaper" "$BACKUP/"
fi

# Backup do bashrc
if [ -f "$HOME/.bashrc" ]; then
    cp "$HOME/.bashrc" "$BACKUP/bashrc"
fi

echo "==> Criando diretórios..."

mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/wallpaper"

echo "==> Instalando configurações..."

for dir in "${CONFIGS[@]}"; do
    if [ -d "$DOTFILES_DIR/$dir" ]; then
        cp -r "$DOTFILES_DIR/$dir" "$HOME/.config/"
    fi
done

echo "==> Instalando wallpapers..."

if [ -d "$DOTFILES_DIR/wallpaper" ]; then
    cp -r "$DOTFILES_DIR/wallpaper/"* "$HOME/wallpaper/" 2>/dev/null || true
fi

echo "==> Instalando scripts..."

if [ -d "$DOTFILES_DIR/.local/bin" ]; then
    cp -r "$DOTFILES_DIR/.local/bin/"* "$HOME/.local/bin/"
    chmod +x "$HOME/.local/bin/"*
fi

echo "==> Configurando PATH..."

if [ -f "$HOME/.bashrc" ]; then
    if ! grep -qxF 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc"; then
        {
            echo
            echo "# Added by DNLX Dotfiles"
            echo 'export PATH="$HOME/.local/bin:$PATH"'
        } >> "$HOME/.bashrc"
    fi
else
    cat > "$HOME/.bashrc" <<EOF
export PATH="\$HOME/.local/bin:\$PATH"
EOF
fi

echo
echo "========================================"
echo "      DNLX Dotfiles instaladas!"
echo "========================================"
echo
echo "Backup salvo em:"
echo "  $BACKUP"
echo
echo "Faça logout/login ou reinicie o Hyprland."
