#!/bin/bash

# --- SWAP CONTENT (MÉTODO BURBUJA) ---
# Usa el "special workspace" como buffer temporal para un intercambio limpio.

# 1. Obtener Info de Monitores
monitors=$(hyprctl monitors -j)

# Monitor A (Foco actual)
ws_a=$(echo "$monitors" | jq -r '.[] | select(.focused == true) | .activeWorkspace.id')
id_mon_a=$(echo "$monitors" | jq -r '.[] | select(.focused == true) | .id')

# Monitor B (El otro)
# Buscamos el primer monitor cuyo ID NO sea el de A
ws_b=$(echo "$monitors" | jq -r ".[] | select(.id != $id_mon_a) | .activeWorkspace.id" | head -n 1)

# Debug: Verificar que tenemos ambos IDs
if [ -z "$ws_a" ] || [ -z "$ws_b" ] || [ "$ws_a" == "null" ] || [ "$ws_b" == "null" ]; then
    notify-send "Swap Error" "No se pudieron identificar los workspaces activos."
    exit 1
fi

# 2. Obtener ventanas
clients=$(hyprctl clients -j)

# PIDs en A
pids_a=$(echo "$clients" | jq -r ".[] | select(.workspace.id == $ws_a) | .address")
# PIDs en B
pids_b=$(echo "$clients" | jq -r ".[] | select(.workspace.id == $ws_b) | .address")

if [ -z "$pids_a" ] && [ -z "$pids_b" ]; then
    exit 0
fi

# 3. EL BAILE DE LA BURBUJA

# Paso I: Mover A -> Special Workspace (Buffer)
# Usamos 'special:swapbuffer' para no mezclar con scratchpads normales si usas alguno
for addr in $pids_a; do
    hyprctl dispatch movetoworkspacesilent "special:swapbuffer,address:$addr"
done

# Paso II: Mover B -> Workspace A
for addr in $pids_b; do
    hyprctl dispatch movetoworkspacesilent "$ws_a,address:$addr"
done

# Paso III: Mover Buffer (ex-A) -> Workspace B
# Obtenemos de nuevo la lista del buffer por si acaso (más seguro)
# o usamos la lista pids_a que ya teníamos.
for addr in $pids_a; do
    hyprctl dispatch movetoworkspacesilent "$ws_b,address:$addr"
done

