#!/bin/bash
# 1. Obtener el ID del workspace actual de forma precisa
WS_ID=$(hyprctl activeworkspace -j | jq -r '.id')

# 2. Sacar la ventana activa al workspace especial (esto la quita de la cinta)
hyprctl dispatch movetoworkspacesilent special:roll

# 3. Devolverla inmediatamente al workspace original
# Al entrar de nuevo, el layout scrolling la pone al FINAL automáticamente
hyprctl dispatch movetoworkspacesilent $WS_ID

# 4. Centrar la vista en la nueva ventana que quedó al principio
hyprctl dispatch layoutmsg focus r
hyprctl dispatch layoutmsg focus l