#!/bin/bash
# Ruta personalizada
DIR="$HOME/Imágenes/Screenshots"
FILE="$DIR/scr_$(date +%Y%m%d_%H%M%S).png"

# Asegurar que el directorio existe
mkdir -p "$DIR"

# 1. Congela la pantalla y captura el área
GEOM=$(wayfreeze --after-freeze-cmd 'slurp; killall wayfreeze')
if [ -z "$GEOM" ]; then exit 1; fi

# 2. Captura (grim) y envía a Satty
# Satty recibe la imagen directamente desde grim (stdin) para editarla antes de guardar/copiar.
# --output-filename: Define dónde se guardará el archivo si decides guardarlo en Satty.
# --early-exit: Cierra Satty automáticamente después de copiar o guardar.
grim -g "$GEOM" - | satty --filename - --output-filename "$FILE" --copy-command wl-copy --early-exit
