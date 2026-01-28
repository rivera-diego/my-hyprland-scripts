#!/bin/bash

# Captura el área (slurp)
GEOM=$(slurp)
if [ -z "$GEOM" ]; then exit 1; fi

# Pre-procesado con ImageMagick para mejorar OCR:
# 1. Convierte a escala de grises
# 2. Aumenta el contraste y normaliza (-normalize)
# 3. Reescala (resample 300) y enfoca (-sharpen) para que las fuentes sean más legibles
grim -g "$GEOM" - | \
    magick - -colorspace gray -normalize -resample 300 -sharpen 0x1 - \
    | tesseract stdin stdout -l spa+eng --psm 6 \
    | wl-copy

notify-send "OCR" "Texto extraído correctamente" -i accessories-character-map -t 2000