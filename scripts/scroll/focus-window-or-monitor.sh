#!/bin/bash# Obtener nombre del layout actual
LAYOUT=$(hyprctl -j activeworkspace | jq -r '.tiledLayout')


# Focus en ventana: usa layoutmsg para scrolling, movefocus para master/dwindle
# Si llega al borde, salta al monitor adyacente
# $1 = dirección: l (izquierda), r (derecha), u (arriba), d (abajo)

DIR=$1

ACTIVE=$(hyprctl activewindow -j)
[ "$ACTIVE" = "null" ] && exit 0

# Obtener nombre del layout actual
LAYOUT=$(hyprctl -j activeworkspace | jq -r '.tiledLayout')

# Guardar ventana enfocada actual antes de intentar mover
BEFORE_FOCUS=$(hyprctl activewindow -j | jq -r '.address')

# Usar layoutmsg focus solo para scrolling (detecta ventanas ocultas en scroll infinito)
# Para master/dwindle usar movefocus normal
case "$DIR" in
    l)
        if [[ "$LAYOUT" == *"scrolling"* ]]; then
            hyprctl dispatch layoutmsg focus l
        fi
        if [[ "$LAYOUT" == *"master"* ]] || [[ "$LAYOUT" == *"dwindle"* ]]; then
            hyprctl dispatch movefocus l
        fi
        ;;
    r)
        if [[ "$LAYOUT" == *"scrolling"* ]]; then
            hyprctl dispatch layoutmsg focus r
        fi
        if [[ "$LAYOUT" == *"master"* ]] || [[ "$LAYOUT" == *"dwindle"* ]]; then
            hyprctl dispatch movefocus r
        fi
        ;;
    u)
        if [[ "$LAYOUT" == *"scrolling"* ]]; then
            hyprctl dispatch layoutmsg focus u
        fi
        if [[ "$LAYOUT" == *"master"* ]] || [[ "$LAYOUT" == *"dwindle"* ]]; then
            hyprctl dispatch movefocus u
        fi
        ;;
    d)
        if [[ "$LAYOUT" == *"scrolling"* ]]; then
            hyprctl dispatch layoutmsg focus d
        fi
        if [[ "$LAYOUT" == *"master"* ]] || [[ "$LAYOUT" == *"dwindle"* ]]; then
            hyprctl dispatch movefocus d
        fi
        ;;
esac

# Pequeña pausa para que Hyprland actualice
sleep 0.03

# Obtener ventana enfocada después del intento
AFTER_FOCUS=$(hyprctl activewindow -j | jq -r '.address')

# Si el foco no cambió (misma ventana), significa que llegamos al borde
# En ese caso, saltar al monitor adyacente
if [ "$BEFORE_FOCUS" = "$AFTER_FOCUS" ]; then
    case "$DIR" in
        l) hyprctl dispatch focusmonitor l ;;
        r) hyprctl dispatch focusmonitor r ;;
        u) hyprctl dispatch focusmonitor u ;;
        d) hyprctl dispatch focusmonitor d ;;
    esac
fi
