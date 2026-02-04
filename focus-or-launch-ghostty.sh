#!/bin/bash

# Busca la dirección de la ventana de Ghostty
# Intentamos coincidir con "com.mitchellh.ghostty" (nombre de clase estándar) o "ghostty"
GHOSTTY_ADDRESS=$(hyprctl clients -j | jq -r '.[] | select(.class=="com.mitchellh.ghostty" or .class=="ghostty") | .address' | head -n 1)

if [ -n "$GHOSTTY_ADDRESS" ]; then
    # Obtén el workspace actual
    CURRENT_WORKSPACE=$(hyprctl activeworkspace -j | jq '.id')

    # Mueve la ventana al workspace actual DIRECTAMENTE (usando su dirección)
    # Esto evita que el foco (y el mouse) salten al otro monitor antes de mover la ventana
    hyprctl dispatch movetoworkspace "$CURRENT_WORKSPACE,address:$GHOSTTY_ADDRESS"

    # Luego enfoca la ventana que ya está aquí
    hyprctl dispatch focuswindow "address:$GHOSTTY_ADDRESS"
else
    # Si no está abierto, lo lanza con la configuración solicitada
    ghostty +new-window &
fi
