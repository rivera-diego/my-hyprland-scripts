#!/bin/bash

# Obtener el ID del monitor de la ventana activa
monitor_id=$(hyprctl activewindow -j | jq -r '.monitor')

# Mover la ventana al otro monitor
if [ "$monitor_id" == "0" ]; then
    # Estamos en HDMI-A-1 (monitor 0), mover a DP-1
    hyprctl dispatch movewindow mon:DP-1
else
    # Estamos en DP-1 (monitor 1), mover a HDMI-A-1
    hyprctl dispatch movewindow mon:HDMI-A-1
fi
