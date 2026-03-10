# Design Requirements & Decisions

## Target Device

- **Garmin Venu 3S**
- Display: 390 x 390 px, round AMOLED, 1.2" diagonal
- Always-on display (AOD) supported

## Design Principles

1. **AMOLED-first** — black background, no unnecessary fills/gradients
2. **Legibility** — minimum ~16px effective font size for complications
3. **Clean + techy** — modern typography with data-forward layout
4. **60-30-10 color rule** — dominant black, secondary white/gray, accent colors for data
5. **AOD efficiency** — simplified monochrome in always-on mode, no glow effects

## User Preferences

- Digital time (no analog-only)
- No dials or gauges
- Emojis for quick visual identification of data types
- Both battery and steps progress bars when space allows
- Sunrise OR sunset shown based on current time of day
- Step goal displayed as "/ 10,000" for technical aesthetic
- Terminal status line: dynamic health summary (OK / WARN / CRIT)

## Selected Designs (7 favorites)

### 1. Horizon
Clean minimal. Large time, date, 2x2 complication grid with emojis.
Sunrise/sunset switches based on time of day.

### 2. Vitals
Dense health dashboard. Time at top, steps bar, battery bar, 2x2 health stats (HR, calories, distance, floors), HR 6-hour sparkline at bottom.
**Variation idea:** Add sparkline to Horizon as well.

### 3. Strata
Layered horizontal bands. Date + battery top, large time center, steps with "/ 10,000" goal and progress bar, HR + sunset bottom.

### 4. Signal
Minimal data-viz. Sunset top-right, large light-weight time, gradient-fade indigo accent line, "4,281 steps" hero stat, HR + battery bottom.

### 5. Tactical
Military field watch. Olive/sand color scheme, 12 hour markers, bold monospace time, "09 MAR 2026" date format, centered key:value data block (STEPS, HR, BAT, SUNSET).

### 6. Retro LCD
Amber segment display. Two bordered panels — top panel with date, steps, HR, sunset, battery; bottom panel with large Orbitron time + seconds.
**Note:** Fix overlapping seconds text (:27) positioning.

### 7. Grid
Clean 2x3 cells with thin dividing lines. Time + date above, labeled stat cells below (STEPS, HEART, BATTERY, SUNSET, DISTANCE, CALORIES).

## Available Garmin Data Fields

| Field | API | Notes |
|-------|-----|-------|
| Steps | `ActivityMonitor.getInfo().steps` | |
| Step Goal | `ActivityMonitor.getInfo().stepGoal` | Default 10,000 |
| Heart Rate | `Activity.getActivityInfo().currentHeartRate` or `SensorHistory` | |
| Battery | `System.getSystemStats().battery` | 0-100 float |
| Sunrise/Sunset | `Weather.getSunrise()` / `Weather.getSunset()` | Requires location |
| Distance | `ActivityMonitor.getInfo().distance` | In cm, convert to mi/km |
| Calories | `ActivityMonitor.getInfo().calories` | Total active |
| Floors | `ActivityMonitor.getInfo().floorsClimbed` | |
| Body Battery | `SensorHistory.getBodyBatteryHistory()` | 0-100 |
| Stress | `SensorHistory.getStressHistory()` | 0-100 |
| Active Minutes | `ActivityMonitor.getInfo().activeMinutesWeek` | |

## Color Palette

```
White:    #FFFFFF (time)
Gray:     #555555 (date, secondary text)
Dim:      #333333 (inactive/tertiary)
Blue:     #38BDF8 (steps)
Red:      #F87171 (heart rate)
Green:    #4ADE80 (battery)
Gold:     #E8A838 (sunrise)
Indigo:   #818CF8 (accent/signal)
Teal:     #2DD4BF (distance/alt accent)
Amber:    #FFB000 (retro LCD)
Olive:    #A3A651 (tactical)
Sand:     #D4D4A0 (tactical text)
```

## AOD Color Scheme

All accent colors reduce to `#282828` (barely visible gray).
Time reduces to `#777777`. Track/background elements to `#080808`.
No glow, no gradients, no fill effects in AOD mode.
