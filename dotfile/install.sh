#!/bin/bash

set -e

echo "==> Criando backup..."

BACKUP="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP"

for dir in fastfetch hypr kitty waybar wofi; do
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

cp -r fastfetch "$HOME/.config/"
cp -r hypr "$HOME/.config/"
cp -r kitty "$HOME/.config/"
cp -r waybar "$HOME/.config/"
cp -r wofi "$HOME/.config/"
cp -r wallpaper/* "$HOME/wallpaper/"

echo ""
echo "✔️ Instalação concluída!"
echo "📦 Backup salvo em: $BACKUP"
