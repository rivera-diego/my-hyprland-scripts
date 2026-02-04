#!/bin/bash

# Busca la dirección de la ventana de Vivaldi
VIVALDI_ADDRESS=$(hyprctl clients -j | jq -r '.[] | select(.class=="vivaldi-stable") | .address' | head -n 1)

if [ -n "$VIVALDI_ADDRESS" ]; then
    # Obtén el workspace actual
    CURRENT_WORKSPACE=$(hyprctl activeworkspace -j | jq '.id')

    # Mueve la ventana al workspace actual DIRECTAMENTE (usando su dirección)
    # Esto evita que el foco (y el mouse) salten al otro monitor antes de mover la ventana
    hyprctl dispatch movetoworkspace "$CURRENT_WORKSPACE,address:$VIVALDI_ADDRESS"

    # Luego enfoca la ventana que ya está aquí
    hyprctl dispatch focuswindow "address:$VIVALDI_ADDRESS"
else
    # Si no está abierto, lo lanza
    vivaldi-stable --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-gpu-rasterization --enable-zero-copy &
fi
