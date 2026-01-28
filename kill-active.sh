#!/bin/bash

# Obtener información de la ventana activa
active_window=$(hyprctl activewindow -j)
pid=$(echo "$active_window" | jq '.pid')
class=$(echo "$active_window" | jq -r '.class')
initial_class=$(echo "$active_window" | jq -r '.initialClass')

if [ "$pid" == "null" ] || [ -z "$pid" ]; then
    exit 0
fi

# 1. Intentar cierre normal
hyprctl dispatch killactive

# Esperar brevemente
sleep 0.5

# 2. Exterminio selectivo
# Si el proceso original sigue vivo...
if ps -p $pid > /dev/null; then
    notify-send "Force Kill" "Cerrando forzosamente $class..."
    
    # Intenta matar por grupo de procesos (PGID)
    pgid=$(ps -o pgid= -p $pid | grep -o '[0-9]*')
    if [ -n "$pgid" ]; then
        kill -SIGKILL -- -"$pgid" 2>/dev/null
    fi
    
    # Matar el PID específico
    kill -SIGKILL "$pid" 2>/dev/null
fi

# 3. Limpieza profunda por nombre (Para procesos Electron como Antigravity, VSCode, Discord)
# Solo si la clase es válida y no es algo genérico
if [ -n "$class" ] && [ "$class" != "null" ]; then
    # Busca procesos que coincidan con el nombre de la clase (case insensitive)
    # Excluye al propio script y grep
    pids_restantes=$(pgrep -f -i "$class")
    
    if [ -n "$pids_restantes" ]; then
        # Doble verificación: asegurarse de que son del usuario actual
        pkill -u "$USER" -SIGKILL -f -i "$class"
        notify-send "Limpieza Profunda" "Se eliminaron procesos residuales de $class."
    fi
fi
