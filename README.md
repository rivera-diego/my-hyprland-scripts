# Hyprland Configuration

Mi configuración personal de [Hyprland](https://hyprland.org/), un compositor Wayland dinámico altamente personalizable.

![GitHub stars](https://img.shields.io/github/stars/rivera-diego/my-hyprland-scripts?style=flat)
![License](https://img.shields.io/badge/license-MIT-blue)

## 🖥️ Setup

### Hardware
- **GPU:** NVIDIA RTX 3060 Ti
- **Monitores:**
  - HDMI-A-1: 1920x1080@75Hz (Vertical, rotado 90°)
  - DP-1: 1920x1080@144Hz (Horizontal, principal)

### Software
- **Distro:** CachyOS (Arch Linux)
- **Compositor:** Hyprland (main branch)
- **Terminal:** Ghostty
- **Browser:** Helium

## 📁 Estructura

```
~/.config/hypr/
├── hyprland.conf          # Configuración principal
├── keybinds/              # Atajos de teclado
│   ├── keybinds.conf
│   ├── keybinds_scrolling.conf
│   └── ...
├── layouts/               # Configuración de layouts
│   ├── scrolling.conf
│   ├── master.conf
│   └── dwindle.conf
├── scripts/               # Scripts personalizados
│   ├── scroll/
│   ├── apps/
│   ├── capture/
│   └── ...
├── colors/                # Esquemas de color
└── ...
```

## 🚀 Instalación

```bash
# Clonar la configuración
git clone https://github.com/rivera-diego/my-hyprland-scripts.git ~/.config/hypr

# Hacer ejecutables los scripts
find ~/.config/hypr/scripts -type f -name "*.sh" -exec chmod +x {} \;

# Iniciar Hyprland (desde tu display manager o startx)
```

## ⌨️ Keybinds Principales

| Tecla | Acción |
|-------|--------|
| `SUPER + T` | Abrir terminal (Ghostty) |
| `SUPER + E` | Abrir administrador de archivos |
| `SUPER + W` | Abrir navegador |
| `SUPER + Q` | Cerrar ventana activa |
| `SUPER + V` | Toggle floating |
| `SUPER + F` | Toggle fullscreen |
| `SUPER + ←/→` | Navegar entre columnas (scrolling) |
| `SUPER + ↑/↓` | Navegar entre ventanas |
| `SUPER + 1-6` | Cambiar a workspace |
| `SUPER + TAB` | Cambiar entre monitores |

## 📜 Scripts Destacados

### `move-column-or-to-monitor.sh`
Mueve columnas en layout scrolling entre monitores con diferentes layouts.

### `focus-window-or-monitor.sh`
Navegación inteligente que salta entre monitores al llegar al borde.

### `screenshot-ocr.sh`
Extrae texto de capturas de pantalla usando Tesseract OCR.

### `swap-content.sh`
Intercambia ventanas entre monitores preservando los workspaces.

## 🛠️ Dependencias

- `hyprland` - Compositor Wayland
- `jq` - Procesamiento JSON
- `ghostty` - Terminal emulator
- `grim` + `slurp` - Capturas de pantalla
- `tesseract` - OCR
- `satty` - Editor de capturas
- `wayfreeze` - Congelar pantalla para capturas

## 📝 Notas

- Configuración optimizada para NVIDIA con drivers propietarios
- Layout principal: **scrolling** (estilo Niri)
- Soporte para monitores rotados (vertical/horizontal)

## 🤝 Contribuir

Si encuentras bugs o tienes mejoras, siéntete libre de abrir un issue o PR.

## 📄 Licencia

MIT - Siéntete libre de usar y modificar esta configuración.
