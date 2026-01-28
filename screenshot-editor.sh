#!/bin/bash
# Ruta personalizada
DIR="$HOME/Imágenes/Screenshots"
FILE="$DIR/scr_$(date +%Y%m%d_%H%M%S).png"

# Asegurar que el directorio existe
mkdir -p "$DIR"

# 1. Captura (grim/slurp)
# 2. Guarda en la carpeta (tee)
# 3. Copia al portapapeles (wl-copy) para que Noctalia lo vea
grim -g "$(slurp)" - | tee "$FILE" | wl-copy

# 4. Abre Swappy con el archivo guardado para editar/anotar
# Swappy detectará que el archivo existe y te dejará editarlo.
swappy -f "$FILE"
