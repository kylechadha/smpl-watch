# smpl-watch

Custom watch face for the **Garmin Venu 3S** (390x390 round AMOLED). Built with [Connect IQ](https://developer.garmin.com/connect-iq/) and Monkey C.

Clean, modern, data-forward — designed for legibility and AMOLED efficiency.

## Watch Faces

Seven designs, switchable via Garmin Connect Mobile or on-device settings. Each supports an always-on display (AOD) mode with reduced colors for AMOLED burn-in protection.

| # | Name | Style |
|---|------|-------|
| 1 | **Horizon** | Clean minimal, sunrise/sunset by time of day |
| 2 | **Vitals** | Dense health data, sparklines, both progress bars |
| 3 | **Strata** | Layered bands, step goal with progress bar |
| 4 | **Signal** | Minimal data-viz, indigo accent line |
| 5 | **Tactical** | Military field watch, olive/sand color scheme |
| 6 | **Retro LCD** | Amber segments, dual-panel layout |
| 7 | **Grid** | Clean 2x3 stat cells with thin dividers |

See [mockups/mockups.html](mockups/mockups.html) for all 20 design concepts (open in browser).

## Data Displayed

- Time (digital) + date
- Steps / step goal with progress bar
- Heart rate (+ sparkline on Vitals)
- Battery percentage
- Sunrise or sunset (based on time of day)
- Distance, calories, floors (on dense layouts)

## Project Structure

```
smpl-watch/
├── source/
│   ├── SmplWatchApp.mc         # App entry point
│   ├── SmplWatchView.mc        # Main view — dispatches to active face
│   ├── faces/
│   │   ├── HorizonFace.mc      # Face 1: Clean minimal
│   │   ├── VitalsFace.mc       # Face 2: Dense health dashboard
│   │   ├── StrataFace.mc       # Face 3: Layered bands
│   │   ├── SignalFace.mc       # Face 4: Minimal data-viz
│   │   ├── TacticalFace.mc     # Face 5: Military field watch
│   │   ├── RetroLcdFace.mc     # Face 6: Amber LCD segments
│   │   └── GridFace.mc         # Face 7: 2x3 stat grid
│   └── helpers/
│       ├── Colors.mc           # Color constants + AOD palette
│       ├── Data.mc             # Data access (steps, HR, battery, etc.)
│       └── Draw.mc             # Shared drawing utilities
├── resources/
│   ├── drawables/              # Icons and images
│   ├── layouts/                # XML layouts
│   ├── settings/               # User-configurable settings (face selection)
│   └── strings/                # Localized strings
├── mockups/                    # HTML mockup with all 20 concepts
├── assets/                     # QC screenshots
├── docs/                       # Design requirements and decisions
├── manifest.xml                # Connect IQ manifest (targets venu3s)
└── monkey.jungle               # Build configuration
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

### 4. Build & Run in Simulator

```bash
# Option A: VS Code (recommended)
# 1. Open this project folder in VS Code
# 2. Cmd+Shift+P → "Monkey C: Build for Device" → select "venu3s"
# 3. Press F5 to run in the simulator
#    (or Cmd+Shift+P → "Monkey C: Run")

# Option B: Command line
monkeyc -d venu3s -f monkey.jungle -o bin/smpl-watch.prg -y /path/to/developer_key.der
connectiq  # launches simulator
monkeydo bin/smpl-watch.prg venu3s  # loads app in simulator
```

### 5. Switching Watch Faces

The app includes 7 face designs. To switch between them:

**In the Simulator:**
- Settings → smpl watch → Watch Face → select design

**On the Watch (via Garmin Connect Mobile):**
1. Open Garmin Connect app on your phone
2. Go to your device → Appearance → Watch Face
3. Tap the settings gear on "smpl watch"
4. Select your preferred face design

**On the Watch (direct):**
1. Long-press the touchscreen on the watch face
2. Swipe to "smpl watch"
3. Tap the settings icon to change the layout

## Loading onto Your Watch

### Option A: USB Sideload (fastest for development)

1. Connect your Venu 3S to your Mac via USB
2. It should mount as a USB drive (like `GARMIN`)
3. Build: VS Code → Cmd+Shift+P → "Monkey C: Export Project"
4. Copy the `.prg` file to `GARMIN/APPS/` on the watch drive
5. Safely eject the drive
6. On the watch: long-press watch face → find "smpl watch"

### Option B: Garmin Connect IQ Store

1. Create a developer account at [developer.garmin.com](https://developer.garmin.com)
2. Export: VS Code → Cmd+Shift+P → "Monkey C: Export Project" (creates `.iq` file)
3. Upload at [apps.garmin.com/developer](https://apps.garmin.com/developer)
4. Once approved, install via Garmin Connect Mobile → Connect IQ Store

### Option C: Wireless via Garmin Express

1. Install [Garmin Express](https://www.garmin.com/express) on your Mac
2. Connect watch via USB, pair with Garmin Express
3. Use the Connect IQ app manager to sideload the `.prg` file

## Changing the Active Face

The active face design is stored as a setting. You can change it:
- Through the Garmin Connect Mobile app (Settings for the watch face)
- Through the simulator's settings panel during development

## Development Notes

- **AMOLED optimization:** All faces use pure black (`0x000000`) backgrounds. AOD mode reduces all accent colors to dim gray to minimize burn-in.
- **Font sizing:** Uses built-in Garmin fonts. `FONT_NUMBER_THAI_HOT` for large time display (~90px), `FONT_NUMBER_HOT` for medium (~60px), system fonts for complications.
- **No permissions required:** Steps, HR, battery, and basic weather data don't require special permissions on the Venu 3S.
- **Target device:** `venu3s` only (41mm, 390x390). Can be extended to other AMOLED Garmin devices by adding them to `manifest.xml`.

## License

MIT
