#!/bin/bash

# Obtener información de los monitores en formato JSON
monitors=$(hyprctl monitors -j)

# Obtener el monitor actual (el que tiene foco)
current_monitor=$(echo "$monitors" | jq -r '.[] | select(.focused == true) | .name')

# Obtener el OTRO monitor (asumiendo 2 monitores principales)
# Selecciona el primer monitor que NO sea el actual
target_monitor_info=$(echo "$monitors" | jq -r ".[] | select(.name != \"$current_monitor\") | {name: .name, x: .x, y: .y, width: .width, height: .height} | @base64" | head -n 1)

if [ -z "$target_monitor_info" ]; then
    notify-send "Monitor Switch" "No se encontró otro monitor."
    exit 1
fi

# Decodificar info del monitor destino
_jq() {
 echo "${target_monitor_info}" | base64 --decode | jq -r "${1}"
}

name=$(_jq '.name')
x=$(_jq '.x')
y=$(_jq '.y')
width=$(_jq '.width')
height=$(_jq '.height')

# Calcular el centro
# Hyprland usa coordenadas globales absolutas
center_x=$(echo "$x + ($width / 2)" | bc)
center_y=$(echo "$y + ($height / 2)" | bc)

# Ejecutar el cambio:
# 1. Focus monitor
# 2. Mover cursor al centro calculado
hyprctl dispatch focusmonitor "$name"
hyprctl dispatch movecursor "$center_x" "$center_y"
