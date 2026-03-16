# smpl-watch

**7 standalone custom watch faces for the Garmin Venu 3S** (390x390 round AMOLED). Built with [Connect IQ](https://developer.garmin.com/connect-iq/) and Monkey C.

Each face is a separate, independently sideloadable app. Clean, modern, data-forward — designed for legibility and AMOLED efficiency.

## Watch Faces (7 Independent Apps)

| # | App | Style | .prg File |
|---|-----|-------|-----------|
| 1 | **Horizon** | Clean minimal, battery arc | `apps/horizon/bin/horizon.prg` |
| 2 | **Vitals** | Simplified health dashboard | `apps/vitals/bin/vitals.prg` |
| 3 | **Strata** | 3-band layout, step progress | `apps/strata/bin/strata.prg` |
| 4 | **Signal** | Minimal data-viz, concentric rings | `apps/signal/bin/signal.prg` |
| 5 | **Tactical** | Military aesthetic, olive/sand | `apps/tactical/bin/tactical.prg` |
| 6 | **Retro LCD** | Amber segments, hero time | `apps/retro_lcd/bin/retro_lcd.prg` |
| 7 | **Grid** | Clean 2x3 stat cells | `apps/grid/bin/grid.prg` |

See [mockups/mockups.html](mockups/mockups.html) for original 20 design concepts (open in browser).

## Data Displayed (All Faces)

- **Time** (digital, large hero)
- **Date** (compact format)
- **Steps** (with goal + progress bar where applicable)
- **Heart rate** (live from sensor)
- **Battery** percentage
- **Temperature** (weather API)
- **Distance & Calories** (Vitals, Grid only)

## Project Structure

```
smpl-watch/
├── apps/                                  # 7 independent Connect IQ apps
│   ├── horizon/
│   │   ├── source/
│   │   │   ├── HorizonApp.mc              # App entry point
│   │   │   ├── HorizonView.mc             # Watch face view
│   │   │   ├── faces/HorizonFace.mc       # Drawing logic
│   │   │   ├── Colors.mc                  # (shared, copied)
│   │   │   ├── Data.mc                    # (shared, copied)
│   │   │   └── Draw.mc                    # (shared, copied)
│   │   ├── resources/                     # Icons, layouts, strings
│   │   ├── bin/horizon.prg                # Compiled app (ready for sideload)
│   │   ├── manifest.xml                   # Unique app ID per face
│   │   └── monkey.jungle                  # Build config
│   ├── vitals/                            # Same structure × 6
│   ├── strata/
│   ├── signal/
│   ├── tactical/
│   ├── retro_lcd/
│   └── grid/
├── shared/                                # Source files (copied into each app)
│   ├── Colors.mc                          # Color constants + AOD palette
│   ├── Data.mc                            # Data access (steps, HR, battery, temp)
│   └── Draw.mc                            # Shared drawing utilities
├── mockups/                               # HTML mockup with all 20 design concepts
├── DESIGN_IMPROVEMENTS.md                 # Design spec and layout details
├── README.md                              # This file
└── keys/
    └── developer_key.der                  # Signing key (gitignored)
```

## Setup & Building

### 1. Install the Connect IQ SDK

```bash
# Download the SDK Manager from:
# https://developer.garmin.com/connect-iq/sdk/

# On macOS, the SDK Manager installs to ~/Library/ConnectIQ/
# It will set GARMIN_HOME automatically
```

### 2. Install VS Code Extension

Install the [Monkey C extension](https://marketplace.visualstudio.com/items?itemName=garmin.monkey-c) in VS Code. This provides:
- Syntax highlighting and IntelliSense for Monkey C
- Build, run, and export commands
- Integrated simulator launching

### 3. Generate a Developer Key

```bash
# First time only — you'll need this to sign your app
# VS Code: Cmd+Shift+P → "Monkey C: Generate Developer Key"
# Save the .der file securely — you can't update published apps without it
```

### 4. Build All 7 Apps

```bash
# Build all 7 apps at once:
for app in horizon vitals strata signal tactical retro_lcd grid; do
  cd apps/$app
  monkeyc -d venu3s -f monkey.jungle -o bin/${app}.prg -y ../../keys/developer_key.der
  cd ../..
done

# The .prg files will be in:
# apps/horizon/bin/horizon.prg
# apps/vitals/bin/vitals.prg
# ... etc
```

### 5. Test in Simulator (Optional)

```bash
# Launch Garmin simulator
connectiq

# Load an app in the simulator
monkeydo apps/horizon/bin/horizon.prg venu3s

# Switch faces in the simulator:
# Settings → [App Name] → [any app-specific settings]
```

### 6. Sideload to Watch

See **Sideloading to Your Watch** section above. Use OpenMTP to copy `.prg` files to `GARMIN/APPS/`.

## Sideloading to Your Watch (7 Apps)

Each face is a **separate, independent app**. You need to sideload the `.prg` files you want.

### Step-by-Step: USB Sideload with OpenMTP (Recommended)

1. **Connect Venu 3S to Mac via USB** (USB cable, not wireless)
2. **Open OpenMTP** (free app available on Mac App Store)
   - It will mount your watch as a USB drive
3. **Copy the .prg files** you want from `apps/*/bin/*.prg`
   - Navigate to: `GARMIN/APPS/` on the watch drive
   - Copy (e.g.) `horizon.prg`, `tactical.prg`, `grid.prg` — pick your favorites
4. **Safely eject** the watch from OpenMTP
5. **On the watch:**
   - Tap Apps
   - Scroll down to find your new watch faces (by name)
   - Tap to select the watch face
   - Long-press to set as active

### Alternative: Garmin Connect Mobile

1. Open Garmin Connect Mobile on your phone
2. Pair your Venu 3S (if not already)
3. Go to Device Settings → Watch Face
4. You should see any sideloaded apps listed
5. Tap to select

### All 7 Pre-Built .prg Files

```
apps/horizon/bin/horizon.prg          (112K) — Clean minimal, battery arc
apps/vitals/bin/vitals.prg            (112K) — Health dashboard
apps/strata/bin/strata.prg            (112K) — 3-band layout
apps/signal/bin/signal.prg            (111K) — Concentric rings
apps/tactical/bin/tactical.prg        (112K) — Military aesthetic
apps/retro_lcd/bin/retro_lcd.prg      (112K) — Amber segments
apps/grid/bin/grid.prg                (112K) — 2x3 grid
```

All files are under the 128KB limit. **Just copy the ones you want to `GARMIN/APPS/` on your watch.**

## Switching Between Installed Watch Faces

Once sideloaded, each app appears as a separate watch face:

- **On the watch:** Long-press the current watch face → Swipe/scroll → Tap the face you want
- **In Garmin Connect Mobile:** Apps → Watch Faces → Select
- **Quick tap:** Once active, quick-tap the watch face to cycle to the next one

## Development Notes

- **AMOLED optimization:** All faces use pure black (`0x000000`) backgrounds. AOD mode reduces all accent colors to dim gray to minimize burn-in.
- **Font sizing:** Uses built-in Garmin fonts. `FONT_NUMBER_THAI_HOT` for large time display (~90px), `FONT_NUMBER_HOT` for medium (~60px), system fonts for complications.
- **No permissions required:** Steps, HR, battery, and basic weather data don't require special permissions on the Venu 3S.
- **Target device:** `venu3s` only (41mm, 390x390). Can be extended to other AMOLED Garmin devices by adding them to `manifest.xml`.

## License

MIT
