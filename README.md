# smpl-watch

Custom watch face for the **Garmin Venu 3S** (390x390 round AMOLED). Built with [Connect IQ](https://developer.garmin.com/connect-iq/) and Monkey C.

Clean, modern, data-forward — designed for legibility and AMOLED efficiency.

## Watch Faces

Seven designs, each with an always-on display (AOD) mode:

| # | Name | Style |
|---|------|-------|
| 1 | **Horizon** | Clean minimal, sunrise/sunset by time of day |
| 2 | **Vitals** | Dense health data, sparklines, both progress bars |
| 3 | **Strata** | Layered bands, step goal with progress bar |
| 4 | **Signal** | Minimal data-viz, indigo gradient accent bar |
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
├── mockups/          # HTML mockup file with all 20 concepts
├── assets/           # QC screenshots from mockup review
├── docs/             # Design requirements and decisions
│   └── design.md
├── source/           # Connect IQ Monkey C source (TODO)
├── resources/        # Connect IQ resources (TODO)
├── manifest.xml      # Connect IQ manifest (TODO)
└── monkey.jungle     # Connect IQ build config (TODO)
```

## Building

### Prerequisites

1. Install the [Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/)
2. Install [VS Code](https://code.visualstudio.com/) with the [Monkey C extension](https://marketplace.visualstudio.com/items?itemName=garmin.monkey-c)
3. Set `GARMIN_HOME` to your SDK path (the SDK manager handles this)

### Build & Run in Simulator

```bash
# Via VS Code
# 1. Open this project in VS Code
# 2. Cmd+Shift+P → "Monkey C: Build for Device"
# 3. Select "venu3s" as target device
# 4. Cmd+Shift+P → "Monkey C: Run" to launch simulator
```

### Load onto Watch

1. Build a release `.prg` file: `Monkey C: Export Project` in VS Code
2. Connect your Venu 3S via USB
3. Copy the `.prg` file to `GARMIN/APPS/` on the watch
4. Safely eject and disconnect
5. On the watch: hold face → select new watch face

Alternatively, publish to the [Connect IQ Store](https://apps.garmin.com/) for OTA install.

## License

MIT
