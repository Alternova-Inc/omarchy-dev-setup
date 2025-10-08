### Setting Up Language Switching and Display in Waybar on Omarchy

This guide walks you through configuring language switching in your Omarchy environment (a distro built on Arch Linux), including displaying the current language in the Waybar. The process is simple and will let you easily switch between keyboard layouts using ALT + Space.

####  1. Configure Keyboard Layouts and Language Switch Shortcut

File: `~/.config/hypr/input.conf`

First, we need to tell Hyprland which keyboard layouts you'll use and how to switch between them:

```ini
# Enable US International and Latin American Spanish
kb_layout = us,latam

# Apply international variant to the English layout
kb_variant = intl,

# Set ALT + Space as the shortcut to switch languages
kb_options = grp:alt_space_toggle
```

This setup enables you to use both US International (with tilde, ñ, etc.) and Spanish layouts, switching between them with `ALT + Space`.

#### 2. Display the Current Language in Waybar

Now let’s visually integrate this feature into your Waybar, so you always know which layout is active.

**File:** `~/.config/waybar/config.json`

**a. Create the Language Module**

Inside your JSON config, add the following object. This defines the formats to display depending on the active layout:

```json
"hyprland/language": {
    "format": "{}",
    "format-en": "US",
    "format-en-intl": "US-INTL",
    "format-es-lat": "ES"
  }
```

**b. Register the Module in the Bar**

Once created, add it to the visible modules section. Here we place it on the right side of the bar:

```json
 "modules-right": [
    "group/tray-expander",
    "bluetooth",
    "network",
    "pulseaudio",
    "cpu",
    "battery",
    "hyprland/language" // new module
  ]
```

#### 3. Style the Language Module

To keep visual consistency with the rest of your modules, adjust its style in Waybar’s CSS file.

File: `~/.config/waybar/style.css`

```css
#language {
  min-width: 12px;
  margin: 0 7.5px;
}
```

#### 4. Apply the Changes

Finally, restart Waybar so the changes take effect:

```bash
pkill waybar && hyprctl dispatch exec waybar
```

Done! Now you can switch between languages using `ALT + Space` and see which one is currently active right in your Waybar. If something doesn’t display as expected, double-check the layout and variant names, as they may vary depending on your system.