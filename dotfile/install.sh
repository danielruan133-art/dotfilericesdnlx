#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Criando backup..."

BACKUP="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP"

CONFIGS=(
    "fastfetch"
    "hypr"
    "kitty"
    "waybar"
    "wofi"
    "cava"
)

for dir in "${CONFIGS[@]}"; do
    if [ -e "$HOME/.config/$dir" ]; then
        mv "$HOME/.config/$dir" "$BACKUP/"
        echo "Backup de $dir criado."
    fi
done

if [ -d "$HOME/wallpaper" ]; then
    mv "$HOME/wallpaper" "$BACKUP/"
    echo "Backup do wallpaper criado."
fi

echo "==> Instalando dotfiles..."

mkdir -p "$HOME/.config"
mkdir -p "$HOME/wallpaper"

for dir in "${CONFIGS[@]}"; do
    if [ -d "$DOTFILES_DIR/$dir" ]; then
        cp -r "$DOTFILES_DIR/$dir" "$HOME/.config/"
        echo "$dir instalado."
    fi
done

if [ -d "$DOTFILES_DIR/wallpaper" ]; then
    cp -r "$DOTFILES_DIR/wallpaper/"* "$HOME/wallpaper/" 2>/dev/null || true
    echo "Wallpaper instalado."
fi

echo ""
echo "✔️ Instalação concluída!"
echo "📦 Backup salvo em:"
echo "$BACKUP"
echo ""
echo "Reinicie sua sessão para aplicar todas as configurações."
