## Blur Issue on Vertical Monitor with `new_optimizations = true` (NVIDIA RTX 3060 Ti)

Hi, thanks for working on this PR! 👋

I'm experiencing an issue with the blur effect on a **vertical monitor** when using `new_optimizations = true`. Even with the fixes from this PR, the problem persists.

---

### System Information

- **GPU:** NVIDIA GeForce RTX 3060 Ti (GA104)
- **Driver:** NVIDIA proprietary (latest)
- **Hyprland-Git Version:** 0.54.0 (built from `main` branch, commit `64a2e4e26`)
- **Date:** March 23, 2026
- **Session:** Wayland

---

### Monitor Configuration

```ini
monitor = HDMI-A-1, 1920x1080@75, 0x0, 1, transform, 1
monitor = DP-1, 1920x1080@144, 1080x396, 1
```

- **HDMI-A-1:** Vertical monitor (rotated 90°, `transform, 1`)
- **DP-1:** Horizontal monitor (primary, 144Hz)

---

### Blur Configuration

```ini
decoration {
    blur {
        enabled = true
        size = 6
        passes = 2
        ignore_opacity = true
        new_optimizations = true  # ← Issue occurs with this enabled
        xray = false
        vibrancy = 0.2
    }
}
```

---

### Issue Description

When `new_optimizations = true` is enabled:

- The blur effect on the **vertical monitor** renders the background **as if it were in horizontal orientation**
- The blurred background appears **rotated incorrectly** (90° offset)
- This affects **any window with blur** on the vertical monitor (terminals, rofi, etc.)

When `new_optimizations = false`:

- Blur renders correctly on the vertical monitor
- Background orientation matches the actual monitor rotation

---

### Environment Variables (NVIDIA)

```ini
env = LIBVA_DRIVER_NAME,nvidia
env = XDG_SESSION_TYPE,wayland
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = NVD_BACKEND,direct
env = __GL_SHADER_DISK_CACHE_SKIP_CLEANUP,1
env = __GL_YIELD,USLEEP
```

---

### Video Attachment

📎 **[Attach your video here]** showing:
1. Blur with `new_optimizations = true` (incorrect rotation)
2. Blur with `new_optimizations = false` (correct rendering)

---

### Additional Notes

- The original fix from PR #9210 seemed to work previously, but the issue reappeared in recent builds
- This might be related to how the damage tracking or framebuffer handling works with NVIDIA + `new_optimizations`
- Happy to test any additional patches or provide more logs if needed!

---

Let me know if I can help with testing! 🙏
