#!/usr/bin/env bash
set -euo pipefail

mode="${1:-}"

stable_pkgs=(
  hyprland
  aquamarine
  hyprcursor
  hyprgraphics
  hyprland-guiutils
  hyprland-protocols
  hyprlang
  hyprtoolkit
  hyprutils
  hyprwayland-scanner
  xdg-desktop-portal-hyprland
  hypridle
  hyprlock
  hyprpaper
  hyprpicker
  hyprpolkitagent
  hyprland-qt-support
  hyprwire
)

git_pkgs=(
  hyprland-git
  aquamarine-git
  hyprcursor-git
  hyprgraphics-git
  hyprland-guiutils-git
  hyprland-protocols-git
  hyprlang-git
  hyprtoolkit-git
  hyprutils-git
  hyprwayland-scanner-git
  xdg-desktop-portal-hyprland
  hypridle
  hyprlock
  hyprpaper
  hyprpicker
  hyprpolkitagent
  hyprland-qt-support
  hyprwire
)

all_hypr_pkgs=(
  hyprland
  hyprland-git
  aquamarine
  aquamarine-git
  hyprcursor
  hyprcursor-git
  hyprgraphics
  hyprgraphics-git
  hyprland-guiutils
  hyprland-guiutils-git
  hyprland-protocols
  hyprland-protocols-git
  hyprlang
  hyprlang-git
  hyprtoolkit
  hyprtoolkit-git
  hyprutils
  hyprutils-git
  hyprwayland-scanner
  hyprwayland-scanner-git
  hyprwire
  hyprwire-git
  hypridle
  hyprlock
  hyprpaper
  hyprpicker
  hyprpolkitagent
  hyprland-qt-support
)

show_status() {
  echo
  pacman -Q | rg '^(hypr|aquamarine|xdg-desktop-portal-hyprland|wlroots)'
  echo
  hyprctl version || true
}

case "$mode" in
  stable)
    # Remover todos los paquetes hypr primero (incluyendo -git)
    sudo pacman -R --noconfirm "${all_hypr_pkgs[@]}" 2>/dev/null || true
    sudo pacman -Syu --noconfirm "${stable_pkgs[@]}"
    ;;
  git)
    # Remover todos los paquetes hypr primero (incluyendo stable)
    sudo pacman -R --noconfirm "${all_hypr_pkgs[@]}" 2>/dev/null || true
    if command -v paru >/dev/null 2>&1; then
      paru -S --noconfirm --needed "${git_pkgs[@]}"
    elif command -v yay >/dev/null 2>&1; then
      yay -S --noconfirm --needed "${git_pkgs[@]}"
    else
      echo "Necesitas paru o yay para instalar la rama -git."
      exit 1
    fi
    ;;
  *)
    echo "Uso: $0 {stable|git}"
    exit 1
    ;;
esac

echo
echo "Reinicia la sesion de Hyprland para cargar los binarios nuevos."
show_status