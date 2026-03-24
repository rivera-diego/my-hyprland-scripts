#!/bin/bash
# smart-swap.sh - Verifica si hay ventana en dirección antes de hacer swap
# Uso: smart-swap.sh [l|r|u|d]

direction=$1

# Obtener ventana activa
active=$(hyprctl activewindow -j 2>/dev/null)
active_x=$(echo "$active" | jq -r '.at[0]')
active_y=$(echo "$active" | jq -r '.at[1]')
active_workspace=$(echo "$active" | jq -r '.workspace.id')

# Obtener todas las ventanas en el mismo workspace
windows=$(hyprctl clients -j 2>/dev/null | jq -r ".[] | select(.workspace.id == $active_workspace) | @json")

# Función para verificar si hay ventana en la dirección
has_window_in_direction() {
  local dir=$1

  while IFS= read -r window; do
    w_x=$(echo "$window" | jq -r '.at[0]')
    w_y=$(echo "$window" | jq -r '.at[1]')

    case $dir in
      r) [ "$w_x" -gt "$active_x" ] && return 0 ;;
      l) [ "$w_x" -lt "$active_x" ] && return 0 ;;
      d) [ "$w_y" -gt "$active_y" ] && return 0 ;;
      u) [ "$w_y" -lt "$active_y" ] && return 0 ;;
    esac
  done <<< "$windows"

  return 1
}

# Lógica principal
case $direction in
  l|r)
    if has_window_in_direction "$direction"; then
      hyprctl dispatch swapwindow "$direction"
    else
      hyprctl dispatch movewindow "$direction"
    fi
    ;;
  u)
    if has_window_in_direction "u"; then
      hyprctl dispatch swapwindow "$direction"
    else
      hyprctl dispatch movetoworkspace e-1
    fi
    ;;
  d)
    if has_window_in_direction "d"; then
      hyprctl dispatch swapwindow "$direction"
    else
      hyprctl dispatch movetoworkspace e+1
    fi
    ;;
esac
