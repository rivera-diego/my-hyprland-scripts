#!/bin/bash

# $1 es la dirección: u (arriba) o d (abajo)
DIR=$1

ACTIVE=$(hyprctl activewindow -j)
[ "$ACTIVE" = "null" ] && exit 0

CUR_X=$(echo "$ACTIVE" | jq '.at[0]')
CUR_Y=$(echo "$ACTIVE" | jq '.at[1]')
CUR_WS=$(echo "$ACTIVE" | jq '.workspace.id')


# 1. Buscamos todas las ventanas que están en nuestra misma COLUMNA (mismo eje X)
OTHERS=$(hyprctl clients -j | jq --argjson ws "$CUR_WS" --argjson x "$CUR_X" \
    '.[] | select(.workspace.id == $ws and .at[0] == $x and .floating == false)')

if [ "$DIR" == "u" ]; then
    # ¿Hay alguna ventana físicamente por encima de la mía? (Y menor)
    HAS_ABOVE=$(echo "$OTHERS" | jq --argjson y "$CUR_Y" 'select(.at[1] < $y)')

    if [ -z "$HAS_ABOVE" ]; then
        # BORDE SUPERIOR: Mandar al workspace anterior
        # Usamos movetoworkspace para que la cámara siga a la ventana
        hyprctl dispatch movetoworkspace e-1
    else
        # Hay ventana arriba: Intercambio normal
        hyprctl dispatch movewindow u
    fi

elif [ "$DIR" == "d" ]; then
    # ¿Hay alguna ventana físicamente por debajo de la mía? (Y mayor)
    HAS_BELOW=$(echo "$OTHERS" | jq --argjson y "$CUR_Y" 'select(.at[1] > $y)')

    if [ -z "$HAS_BELOW" ]; then
        # BORDE INFERIOR: Mandar al siguiente workspace
        hyprctl dispatch movetoworkspace e+1
    else
        # Hay ventana abajo: Intercambio normal
        hyprctl dispatch movewindow d
    fi
fi

# Ajustamos la visión para que la ventana quede centrada tras el movimiento
hyprctl dispatch layoutmsg fit active

# Nativos de Hyprland para notificar Socket 2
hyprctl dispatch focuswindow active
