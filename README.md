# Hyprland Scripts

A collection of useful shell scripts for Hyprland window manager automation and utilities.

## Scripts Overview

### `focus-or-launch-ghostty.sh`

Smart launch/focus for Ghostty terminal.

**What it does:**

- Checks if Ghostty is running.
- If running: Retrieves the window address and moves it to the **current workspace** before focusing.
- **Key Feature:** Uses direct address manipulation to prevent the cursor/focus from "jumping" to the other monitor before the window arrives.
- If not running: Launches a new Ghostty instance (`ghostty +new-window`).

**Requirements:** `hyprctl`, `jq`

---

### `focus-or-launch-vivaldi.sh`

Smart launch/focus for Vivaldi browser.

**What it does:**

- Checks if Vivaldi is running.
- If running: Retrieves the window address and moves it to the **current workspace** before focusing.
- **Key Feature:** Uses direct address manipulation to prevent the cursor/focus from "jumping" to the other monitor before the window arrives.
- If not running: Launches Vivaldi with Wayland/Ozone flags enabled.

**Requirements:** `hyprctl`, `jq`

---

### `kill-active.sh`

Intelligent window termination with multiple fallback strategies for zombie processes.

**Why?** Some applications leave zombie processes behind (Google Chrome, Thunar rename operations, certain games). This script ensures complete process cleanup instead of just closing the window.

**How it works:**

- **Primary:** Attempts normal window close (`hyprctl dispatch killactive`)
- **Secondary:** Force kills process group if window doesn't close
- **Tertiary:** Deep cleanup for stubborn processes (Electron apps, game processes, etc.)
- **Notifications:** Shows which processes are being terminated

Perfect for applications that don't fully terminate or leave orphaned processes.

---

### `monitor-switch.sh`

Switches focus to the secondary monitor and centers the cursor.

**Why?** Hyprland's "follow mouse focus" option causes issues: the cursor drifts when cycling windows in master layout. Disabling cursor movement creates a trap: fullscreen games on one monitor prevent escaping to the other. This script unlocks that by moving focus _and_ cursor to the target monitor.

**How it works:**

- Detects connected monitors and identifies the focused one
- Moves focus to the other monitor
- Calculates monitor center coordinates (handles multi-monitor setups precisely)
- Moves cursor to center of target monitor for seamless interaction

Essential for dual-monitor setups with fullscreen applications that would otherwise trap you.

---

### `screenshot-editor.sh`

Takes region-based screenshots and opens them in Satty for editing/annotating.

**What it does:**

- Freezes screen with `wayfreeze` for precise selection
- Select area with `slurp`
- Captures with `grim`
- Opens **Satty** immediately for annotation
- **User Action:** You choose to copy to clipboard or save to file directly from Satty interface
- Default save path: `~/Imágenes/Screenshots/`

Result: A frozen state allows capturing fleeting tooltips/menus, then Satty handles the editing and export.
**Requirements:** `grim`, `slurp`, `wayfreeze`, `satty`, `wl-copy`

---

### `screenshot-ocr.sh`

Extracts text from screen regions using OCR with preprocessing optimization.

**What it does:**

- Select area with `slurp`
- Captures with `grim`
- Pre-processes image with ImageMagick (grayscale, contrast normalization, sharpening for OCR readability)
- Runs **Tesseract** OCR (Spanish + English)
- Copies extracted text directly to clipboard
- Shows completion notification

Result: Extracted text ready to paste. Perfect for quickly grabbing text from images, UI elements, or documents.

**Requirements:** `grim`, `slurp`, `imagemagick`, `tesseract`, `wl-copy`

---

### `swap-content.sh`

Intelligently swaps all windows between two monitors while preserving layout structure.

**Why?** Hyprland's built-in workspace swap (`hyprctl dispatch swapactive`) completely shuffles workspaces, destroying custom configurations. This script swaps only the _windows_ while keeping workspaces intact and organized.

**How it works (The Bubble Sort Method):**

- **Step 1:** Moves all windows from Monitor A to a temporary special workspace (buffer)
- **Step 2:** Moves all windows from Monitor B to Monitor A's workspace
- **Step 3:** Moves buffered windows (originally from A) to Monitor B

The swap is imperceptible thanks to the intermediate workspace—everything moves seamlessly.

**Result:** Windows exchange monitors while maintaining their workspace assignment and layout state.

Perfect for reorganizing dual-monitor setups without disrupting your carefully configured layout.

---

### `toggle-monitor.sh`

Instantly moves the active window to the other monitor.

**What it does:**

- Detects which monitor the active window is on.
- Dispatches it to the specific opposite monitor (Toggle between DP-1 and HDMI-A-1).

**Requirements:** `hyprctl`, `jq`

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

3. Add bindings to your `keybinds.conf`:

   ```ini
   # Smart Launchers
   bind = SUPER, T, exec, ~/.config/hypr/scripts/focus-or-launch-ghostty.sh
   bind = SUPER, B, exec, ~/.config/hypr/scripts/focus-or-launch-vivaldi.sh

   # Window Management
   bind = SUPER, Q, exec, ~/.config/hypr/scripts/kill-active.sh
   bind = SUPER, Tab, exec, ~/.config/hypr/scripts/monitor-switch.sh
   bind = SUPER, mouse:276, exec, ~/.config/hypr/scripts/toggle-monitor.sh
   bind = SUPER, F12, exec, ~/.config/hypr/scripts/swap-content.sh

   # Screenshots
   bind = SUPER SHIFT, S, exec, ~/.config/hypr/scripts/screenshot-editor.sh
   bind = SUPER SHIFT, O, exec, ~/.config/hypr/scripts/screenshot-ocr.sh
   ```

## Dependencies

| Script                       | Dependencies                                                          |
| ---------------------------- | --------------------------------------------------------------------- |
| `focus-or-launch-ghostty.sh` | `hyprctl`, `jq`                                                       |
| `focus-or-launch-vivaldi.sh` | `hyprctl`, `jq`                                                       |
| `kill-active.sh`             | `hyprctl`, `jq`, `notify-send`                                        |
| `monitor-switch.sh`          | `hyprctl`, `jq`, `bc`, `notify-send`                                  |
| `screenshot-editor.sh`       | `grim`, `slurp`, `wayfreeze`, `satty`, `wl-copy`                      |
| `screenshot-ocr.sh`          | `grim`, `slurp`, `imagemagick`, `tesseract`, `wl-copy`, `notify-send` |
| `swap-content.sh`            | `hyprctl`, `jq`, `notify-send`                                        |
| `toggle-monitor.sh`          | `hyprctl`, `jq`                                                       |

## Notes

- All scripts use `notify-send` for user feedback where appropriate
- Tested on Hyprland with Wayland
- Some scripts use JSON parsing with `jq` for reliability
- Screenshot directory defaults to `~/Imágenes/Screenshots/`
- OCR configured for Spanish + English (modify `-l spa+eng` in script if needed)

## License

Feel free to use and modify as needed.
