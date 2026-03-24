#!/bin/bash

# 1. Buscamos el address de Sublime Text
SUBLIME_ADDRESS=$(hyprctl clients -j | jq -r '.[] | select(.class=="sublime_text") | .address' | head -n 1)

# Función para aplicar los 1066px (para no repetir código)
aplicar_medida_niri() {
    local MON_ID=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .id')
    # ID 1 es tu monitor DP-1 (Horizontal)
    if [ "$MON_ID" -eq 1 ]; then
        sleep 0.2 # Tiempo para que el layout registre la ventana
        hyprctl dispatch layoutmsg colresize 0.5

    fi
}

if [ -n "$SUBLIME_ADDRESS" ]; then
    # --- CASO A: LA VENTANA YA EXISTE (SUMMON) ---
    CURRENT_WS=$(hyprctl activeworkspace -j | jq '.id')

    hyprctl dispatch movetoworkspace "$CURRENT_WS,address:$SUBLIME_ADDRESS"
    hyprctl dispatch focuswindow "address:$SUBLIME_ADDRESS"

    aplicar_medida_niri
else
    # --- CASO B: LA VENTANA NO EXISTE (LAUNCH) ---
    SUBL_CMD="subl"
    if ! command -v "$SUBL_CMD" >/dev/null 2>&1; then
        SUBL_CMD="sublime_text"
    fi

    "$SUBL_CMD" &

    # Esperamos a que la ventana se cree y aparezca en Hyprland
    # 0.4s suele ser suficiente para que el proceso inicie
    sleep 0.4

    aplicar_medida_niri
fi
