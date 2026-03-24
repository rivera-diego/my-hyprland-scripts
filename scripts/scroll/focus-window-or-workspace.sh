#!/bin/bash

# $1 es la dirección: u (arriba) o d (abajo)
DIR=$1

# 1. Obtenemos los datos de la ventana actual usando el stableID o la dirección
ACTIVE=$(hyprctl activewindow -j)
CUR_X=$(echo "$ACTIVE" | jq '.at[0]')
CUR_Y=$(echo "$ACTIVE" | jq '.at[1]')
CUR_WS=$(echo "$ACTIVE" | jq '.workspace.id')

# 2. Obtenemos todas las ventanas del mismo Workspace y la misma Columna (mismo X)
# Filtramos para que solo cuente las que están en el mismo eje X que nosotros
OTHERS=$(hyprctl clients -j | jq --argjson x "$CUR_X" --argjson ws "$CUR_WS" \
    '.[] | select(.workspace.id == $ws and .at[0] == $x and .floating == false)')

# 3. Lógica de frontera física
if [ "$DIR" == "d" ]; then
    # ¿Hay alguna ventana con una Y mayor a la mía? (O sea, más abajo)
    HAS_BELOW=$(echo "$OTHERS" | jq --argjson y "$CUR_Y" 'select(.at[1] > $y)')

    if [ -z "$HAS_BELOW" ]; then
        hyprctl dispatch workspace e+1
    else
        hyprctl dispatch movefocus d
    fi

elif [ "$DIR" == "u" ]; then
    # ¿Hay alguna ventana con una Y menor a la mía? (O sea, más arriba)
    HAS_ABOVE=$(echo "$OTHERS" | jq --argjson y "$CUR_Y" 'select(.at[1] < $y)')

    if [ -z "$HAS_ABOVE" ]; then
        hyprctl dispatch workspace e-1
    else
        hyprctl dispatch movefocus u
    fi
fi
