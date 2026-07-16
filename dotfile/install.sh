#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Verificando gerenciador de pacotes..."

if command -v pacman &>/dev/null; then
    PM="pacman"

elif command -v apt &>/dev/null; then
    PM="apt"

elif command -v dnf &>/dev/null; then
    PM="dnf"

elif command -v emerge &>/dev/null; then
    PM="emerge"

else
    echo "Nenhum gerenciador de pacotes suportado encontrado."
    exit 1
fi

echo "Usando: $PM"


echo "==> Verificando dependências..."

COMMANDS=(
    pamixer
    swaybg
    waybar
    wofi
    kitty
    fastfetch
    cava
    nemo
    amberol
)

MISSING=()

for cmd in "${COMMANDS[@]}"; do
    if ! command -v "$cmd" &>/dev/null; then
        MISSING+=("$cmd")
    fi
done


if [ ${#MISSING[@]} -ne 0 ]; then

    echo "Dependências faltando:"
    printf '%s\n' "${MISSING[@]}"

    read -p "Instalar dependências? [Y/n] " answer

    if [[ "$answer" =~ ^[Yy]$ || -z "$answer" ]]; then

        case $PM in

            pacman)
                sudo pacman -S --needed --noconfirm "${MISSING[@]}"
                ;;

            apt)
                sudo apt update
                sudo apt install -y "${MISSING[@]}"
                ;;

            dnf)
                sudo dnf install -y "${MISSING[@]}"
                ;;

            emerge)
                sudo emerge --ask=n "${MISSING[@]}"
                ;;

        esac

    else
        echo "Instalação cancelada."
        exit 1
    fi

fi


echo "==> Criando backup..."

BACKUP="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP"

CONFIGS=(
    fastfetch
    hypr
    kitty
    waybar
    wofi
    cava
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
    fi
done


if [ -d "$DOTFILES_DIR/wallpaper" ]; then
    cp -r "$DOTFILES_DIR/wallpaper/"* "$HOME/wallpaper/" 2>/dev/null || true
fi


echo ""
echo "✔️ Dotfile instalada!"
echo "📦 Backup salvo em:"
echo "$BACKUP"
echo ""
echo "Faça logout/login ou reinicie o Hyprland."
