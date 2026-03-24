
#!/bin/bash

# Este script controla el monitor secundario (HDMI) y persiste el cambio en monitors.conf
# Uso: ./monitor-control.sh [on|off]

CONF_FILE="$HOME/.config/hypr/monitors.conf"
MONITOR_NAME="HDMI-A-1"
# Configuración EXACTA que quieres usar cuando esté encendido
MONITOR_CONFIG="1920x1080@75, 1920x-410, 1, transform, 3"

if [ "$1" == "off" ]; then
    notify-send "Monitor" "Desactivando $MONITOR_NAME..."

    # 1. Modificar el archivo para que sea persistente (usamos sed para reemplazar la línea)
    # Convertimos cualquier configuración de HDMI-A-1 en 'disable'
    sed -i "s|^monitor = $MONITOR_NAME,.*|monitor = $MONITOR_NAME, disable|" "$CONF_FILE"

    # 2. Aplicar el cambio inmediatamente (sin esperar reload completo si es posible)
    hyprctl keyword monitor "$MONITOR_NAME, disable"

    exit 0
fi

if [ "$1" == "on" ]; then
    notify-send "Monitor" "Activando $MONITOR_NAME..."

    # 1. Modificar el archivo con la configuración correcta
    # Buscamos la línea (incluso si está disabled) y la reemplazamos con la config buena
    sed -i "s|^monitor = $MONITOR_NAME,.*|monitor = $MONITOR_NAME, $MONITOR_CONFIG|" "$CONF_FILE"

    # 2. Recargar Hyprland para que lea el archivo y aplique cambios (wallpapers, waybar, etc)
    hyprctl reload

    exit 0
fi

if [ "$1" == "toggle" ]; then
    # Verificamos si actualmente está en modo "disable" en el archivo
    if grep -q "monitor = $MONITOR_NAME, disable" "$CONF_FILE"; then
        # Está desactivado -> Lo encendemos
        $0 on
    else
        # Está activado (o no dice disable) -> Lo apagamos
        $0 off
    fi
    exit 0
fi

echo "Uso: $0 [on|off|toggle]"
exit 1
