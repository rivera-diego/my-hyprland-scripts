#!/bin/bash

# Mover columna/ventana: verifica si hay ventanas en la dirección, luego mueve
# Si no hay ventanas en esa dirección, salta al monitor adyacente
# $1 = dirección: l (izquierda) o r (derecha)

DIR=$1

ACTIVE=$(hyprctl activewindow -j)
[ "$ACTIVE" = "null" ] && exit 0

CUR_X=$(echo "$ACTIVE" | jq '.at[0]')
CUR_WS=$(echo "$ACTIVE" | jq '.workspace.id')
LAYOUT=$(hyprctl -j activeworkspace | jq -r '.tiledLayout')

# Verificar si hay ventanas en la dirección especificada
if [ "$DIR" == "l" ]; then
    # Buscar ventanas a la izquierda (X menor)
    HAS_TARGET=$(hyprctl clients -j | jq --argjson ws "$CUR_WS" --argjson x "$CUR_X" \
        '[.[] | select(.workspace.id == $ws and .floating == false and .at[0] < $x)] | length')
elif [ "$DIR" == "r" ]; then
    # Buscar ventanas a la derecha (X mayor)
    HAS_TARGET=$(hyprctl clients -j | jq --argjson ws "$CUR_WS" --argjson x "$CUR_X" \
        '[.[] | select(.workspace.id == $ws and .floating == false and .at[0] > $x)] | length')
fi

# Si hay ventanas en esa dirección, intercambiar/mover
if [ "$HAS_TARGET" -gt 0 ]; then
    if [[ "$LAYOUT" == *"scrolling"* ]]; then
        hyprctl dispatch layoutmsg swapcol "$DIR"
    else
        hyprctl dispatch movewindow "$DIR"
    fi
else
    # No hay ventanas en esa dirección, saltar al monitor adyacente
    hyprctl dispatch movewindow "mon:$DIR"
fi

# Notificar a Hyprland
hyprctl dispatch focuswindow active
