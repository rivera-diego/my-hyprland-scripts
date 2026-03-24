#!/bin/bash

DIR=$1 # l o r


ACTIVE=$(hyprctl activewindow -j)
[ "$ACTIVE" = "null" ] && exit 0

CUR_X=$(echo "$ACTIVE" | jq '.at[0]')
CUR_WS=$(echo "$ACTIVE" | jq '.workspace.id')
# Obtenemos el nombre del monitor para evitar errores de ID
CUR_MON=$(hyprctl monitors -j | jq -r --argjson ws "$CUR_WS" '.[] | select(.activeWorkspace.id == $ws) | .name')

# 1. Contamos ventanas en la columna actual
COL_COUNT=$(hyprctl clients -j | jq --argjson ws "$CUR_WS" --argjson x "$CUR_X" \
    '[.[] | select(.workspace.id == $ws and .floating == false and .at[0] == $x)] | length')

if [ "$COL_COUNT" -gt 1 ]; then
    # --- CASO EXPULSAR (EXPEL) ---
    hyprctl dispatch layoutmsg promote
    [ "$DIR" == "l" ] && hyprctl dispatch layoutmsg swapcol l
    # Forzamos a la cámara a centrar la nueva columna
    hyprctl dispatch layoutmsg fit active
else
    # --- CASO CONSUMIR O MOVER ---
    CLIENTS=$(hyprctl clients -j)

    if [ "$DIR" == "r" ]; then
        HAS_RIGHT=$(echo "$CLIENTS" | jq --argjson ws "$CUR_WS" --argjson x "$CUR_X" \
            '[.[] | select(.workspace.id == $ws and .floating == false and .at[0] > $x)] | length')

        if [ "$HAS_RIGHT" -eq 0 ]; then
            # BLOQUEO DE CICLO: Si ya estamos en el monitor de la derecha (HDMI), NO HACEMOS NADA
            if [ "$CUR_MON" == "HDMI-A-1" ]; then
                exit 0
            fi

            # Si estamos en DP-1, saltamos al HDMI
            hyprctl dispatch movewindow mon:r
            sleep 0.08 # Un poquito más de tiempo para el HDMI que es de 75Hz

            # Corrector de posición (poner al inicio del monitor derecho)
            NEW_WS=$(hyprctl activewindow -j | jq '.workspace.id')
            WIN_COUNT=$(hyprctl clients -j | jq --argjson ws "$NEW_WS" '([.[] | select(.workspace.id == $ws and .floating == false)] | length)')
            if [ "$WIN_COUNT" -gt 1 ]; then
                for ((i=1; i<$WIN_COUNT; i++)); do
                    hyprctl dispatch layoutmsg swapcol l
                done
            fi
        else
            hyprctl dispatch movewindow r
        fi

    elif [ "$DIR" == "l" ]; then
        HAS_LEFT=$(echo "$CLIENTS" | jq --argjson ws "$CUR_WS" --argjson x "$CUR_X" \
            '[.[] | select(.workspace.id == $ws and .floating == false and .at[0] < $x)] | length')

        if [ "$HAS_LEFT" -eq 0 ]; then
            # BLOQUEO DE CICLO: Si ya estamos en el monitor de la izquierda (DP-1), salir
            if [ "$CUR_MON" == "DP-1" ]; then
                exit 0
            fi
            hyprctl dispatch movewindow mon:l
        else
            hyprctl dispatch movewindow l
        fi
    fi
fi

# --- EL FIX DEL VIEWPORT ---
# Esta orden le dice al layout de scrolling: "Asegúrate de que la ventana activa esté a la vista"
hyprctl dispatch layoutmsg fit active

# Nativos de Hyprland para notificar Socket 2
hyprctl dispatch focuswindow active
