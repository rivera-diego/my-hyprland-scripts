# Hyprland Scripts

A collection of useful shell scripts for Hyprland window manager automation and utilities.

## Scripts Overview

### `kill-active.sh`
Intelligent window termination with multiple fallback strategies.

- **Primary:** Attempts normal window close (`hyprctl dispatch killactive`)
- **Secondary:** Force kills process group if window doesn't close
- **Tertiary:** Deep cleanup for stubborn Electron apps (VSCode, Discord, etc.)
- **Notifications:** Shows which processes are being terminated

Useful for cleaning up frozen or unresponsive windows.

---

### `monitor-switch.sh`
Switches focus to the secondary monitor and centers the cursor.

- Detects connected monitors and identifies the focused one
- Moves focus to the other monitor
- Calculates monitor center coordinates (handles multi-monitor setups)
- Moves cursor to center of target monitor

Great for dual-monitor workflows to quickly jump between displays.

---

### `screenshot-editor.sh`
Takes region-based screenshots with annotation capabilities.

- Select area with `slurp`
- Captures with `grim`
- Saves to `~/Imágenes/Screenshots/` with timestamp
- Copies screenshot to clipboard
- Opens **Swappy** for instant annotation/editing

Perfect for capturing and annotating screen areas quickly.

**Requirements:** `grim`, `slurp`, `wl-copy`, `swappy`

---

### `screenshot-ocr.sh`
Extracts text from screen regions using OCR.

- Select area with `slurp`
- Captures with `grim`
- Pre-processes image with ImageMagick (grayscale, contrast normalization, sharpening)
- Runs **Tesseract** OCR (Spanish + English)
- Copies extracted text to clipboard
- Shows completion notification

Optimized for readable text extraction from screenshots.

**Requirements:** `grim`, `slurp`, `imagemagick`, `tesseract`, `wl-copy`

---

### `swap-content.sh`
Swaps all windows between two monitors (dual-monitor workflow).

Uses the Hyprland "special workspace" as a temporary buffer:
- **Step 1:** Moves all windows from Monitor A to special buffer
- **Step 2:** Moves all windows from Monitor B to Monitor A
- **Step 3:** Moves buffer contents to Monitor B

Result: Complete swap of workspaces/windows between monitors.

Useful for reorganizing layouts across dual monitors without manual dragging.

---

## Setup

1. Clone this repository to your Hyprland config:
   ```bash
   git clone <repo-url> ~/.config/hypr/scripts
   ```

2. Make scripts executable:
   ```bash
   chmod +x ~/.config/hypr/scripts/*.sh
   ```

3. Add bindings to your `hyprland.conf`:
   ```bash
   bind = $mainMod, Q, exec, ~/.config/hypr/scripts/kill-active.sh
   bind = $mainMod, M, exec, ~/.config/hypr/scripts/monitor-switch.sh
   bind = $mainMod SHIFT, S, exec, ~/.config/hypr/scripts/screenshot-editor.sh
   bind = $mainMod SHIFT, O, exec, ~/.config/hypr/scripts/screenshot-ocr.sh
   bind = $mainMod CTRL, X, exec, ~/.config/hypr/scripts/swap-content.sh
   ```

## Dependencies

| Script | Dependencies |
|--------|--------------|
| `kill-active.sh` | `hyprctl`, `jq`, `notify-send` |
| `monitor-switch.sh` | `hyprctl`, `jq`, `bc`, `notify-send` |
| `screenshot-editor.sh` | `grim`, `slurp`, `wl-copy`, `swappy` |
| `screenshot-ocr.sh` | `grim`, `slurp`, `imagemagick`, `tesseract`, `wl-copy`, `notify-send` |
| `swap-content.sh` | `hyprctl`, `jq`, `notify-send` |

---

## Notes

- All scripts use `notify-send` for user feedback
- Tested on Hyprland with Wayland
- Some scripts use JSON parsing with `jq` for reliability
- Screenshot directory defaults to `~/Imágenes/Screenshots/`
- OCR configured for Spanish + English (modify `-l spa+eng` in script if needed)

---

## License

Feel free to use and modify as needed.
