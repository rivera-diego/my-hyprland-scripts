#!/bin/bash

# 1. Buscamos el address de Thunar
THUNAR_ADDRESS=$(hyprctl clients -j | jq -r '.[] | select(.class=="thunar" or .class=="Thunar") | .address' | head -n 1)

# Función para aplicar los 1066px (para no repetir código)
aplicar_medida_niri() {
    local MON_ID=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .id')
    # ID 1 es tu monitor DP-1 (Horizontal)
    if [ "$MON_ID" -eq 1 ]; then
        sleep 0.2 # Tiempo para que el layout registre la ventana
        hyprctl dispatch layoutmsg colresize 0.5

    fi
}

if [ -n "$THUNAR_ADDRESS" ]; then
    # --- CASO A: LA VENTANA YA EXISTE (SUMMON) ---
    CURRENT_WS=$(hyprctl activeworkspace -j | jq '.id')

    hyprctl dispatch movetoworkspace "$CURRENT_WS,address:$THUNAR_ADDRESS"
    hyprctl dispatch focuswindow "address:$THUNAR_ADDRESS"

    aplicar_medida_niri
else
    # --- CASO B: LA VENTANA NO EXISTE (LAUNCH) ---
    thunar &
    aplicar_medida_niri
fi
