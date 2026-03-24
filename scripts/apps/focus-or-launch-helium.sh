#!/bin/bash
set -euo pipefail

# Localizamos una ventana existente de Helium (cualquier clase que contenga "helium")
HELIUM_ADDRESS=$(hyprctl clients -j | jq -r '.[] | select((.class // "") | ascii_downcase | contains("helium")) | .address' | head -n 1)

if [ -n "$HELIUM_ADDRESS" ]; then
    CURRENT_WS=$(hyprctl activeworkspace -j | jq '.id')

    hyprctl dispatch movetoworkspace "$CURRENT_WS,address:$HELIUM_ADDRESS"
    hyprctl dispatch focuswindow "address:$HELIUM_ADDRESS"
else
    helium &
fi
