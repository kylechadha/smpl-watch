# Watch Face Design Improvements
## Venu 3S 390x390 AMOLED Round Display

**Design Philosophy**: Maximize clarity and breathing room while respecting the circular constraint. Focus on hierarchy: time is hero, supporting metrics provide context without clutter.

**Universal Design Principles Applied:**
- **RobotoLight**: All text uses RobotoLight (FONT_NUMBER_HOT, FONT_SMALL, FONT_XTINY) for thin, refined appearance
- **Typography Hierarchy**: TIME > DATE > LABEL > VALUE (clear size and weight differentiation)
- **Whitespace**: Minimum 12-16px padding around content edges, generous vertical spacing between sections
- **Circular Constraint**: Content stays within 340px diameter, edges reserved for perimeter ticks or clear space
- **Color Consistency**: Active mode uses defined palette, AOD mode dims all accents to gray (0x282828)
- **Progress Bars**: Replace linear bars with circular arcs (drawArc) for battery/steps where possible

---

## 1. HORIZON — Clean Minimal

### Current Issues
- Text cramped: time (y=140), date (y=200), metrics (y=242, y=280) — only 40px between rows
- Sunset display broken (shows "SS --:--")
- No visual weight distribution
- System fonts feel generic

### New Layout
```
              ┌─────────────────┐
              │   (ticks)       │
              │                 │
            90│  MON 15 MAR     │  ← Date, small gray label
              │                 │
           150│    12:45        │  ← Time, HERO (FONT_NUMBER_HOT, white, 72px)
              │                 │
           220│                 │  ← Circular battery arc (0-360°, 180px diameter)
              │  [●]  ● 12,345  │  ← Battery circle + label left, steps right
              │                 │
           285│  72 bpm    68°F │  ← HR + temp, small labels above
              │                 │
              │   (clear space) │
              └─────────────────┘
```

### Typography
- **Time**: FONT_NUMBER_HOT (y=150, white, centered) — largest, most prominent
- **Date**: FONT_XTINY (y=90, 0x555555 gray) — compact, MON 15 MAR format
- **Labels** (above metrics): FONT_XTINY (0x999999) — "BATTERY", "STEPS", "HEART", "TEMP"
- **Values**: FONT_TINY (colored) — steps/HR/temp/battery

### Color Palette
- **Time**: 0xFFFFFF (white)
- **Date**: 0x555555 (medium gray)
- **Battery circle arc**: 0x4ADE80 (green)
- **Steps**: 0x38BDF8 (cyan)
- **HR**: 0xF87171 (red)
- **Temp**: 0x2DD4BF (teal)
- **AOD**: All accents become 0x282828, time becomes 0x777777

### Metrics to Keep / Remove
- **KEEP**: Time, Date, Steps, HR, Battery, Temperature (add as replacement for sunset)
- **REMOVE**: Sunset/sunrise (broken, not essential)
- **ADD**: Circular battery progress arc (180px diameter, centered at 220y)

### Progress Indicators
- **Battery Arc**: Circular, 180px diameter, centered at (CX, 220)
  - Starts at 270° (bottom), sweeps clockwise to represent 0-100%
  - Stroke width: 3px
  - Color: Green (0x4ADE80)

### Spacing & Padding
- Outer edges: 60px clearance
- Date row: y=90 (top breathing room)
- Time row: y=150 (center of visual weight)
- Battery arc: y=220 (clear separation)
- Metrics row: y=285 (lower, compact)
- Row heights: 40px minimum between major elements
- Horizontal spacing between columns: 110px

### AOD Mode
- Time: 0x777777 (dimmed gray)
- Date: 0x282828 (nearly black)
- Battery arc: 0x282828 (dim gray)
- All metric values: 0x282828
- Keep layout identical, just desaturate colors

---

## 2. VITALS — Health Dashboard

### Current Issues
- **Too dense**: Steps bar + battery bar + 4-cell grid + sparkline + 3 separators all fighting for space
- **Metrics overload**: Shows HR, calories, distance, floors — 6 data points cramped
- **Sparkline competes**: Uses 30px height that crowds the design
- **No breathing room**: Grid rows only 28px apart

### New Layout
```
              ┌─────────────────┐
            50│    12:45        │  ← Time, FONT_NUMBER_HOT (large, centered)
              │                 │
            95│  MON 15 MAR     │  ← Date, FONT_XTINY, gray
              │ ────────────    │  ← Subtle divider
              │                 │
           130│ STEPS           │  ← Label left
              │ 12,345 / 10,000 │  ← Value + goal right
           150│ [████████░░░]   │  ← Progress bar (4px tall, 220px wide)
              │                 │
           180│ HEART           │  ← Label left
              │ 72 bpm          │  ← Value right (no circular arc yet, simpler)
              │ ────────────    │  ← Subtle divider
              │                 │
           220│ BAT: 68%        │  ← Battery left, no arc (simpler for AOD)
              │ TEMP: 68°F      │  ← Temp right
              │                 │
              │ (clear space)   │
              └─────────────────┘
```

### Typography
- **Time**: FONT_NUMBER_HOT (y=50, white) — hero
- **Date**: FONT_XTINY (y=95, gray)
- **Labels** (STEPS, HEART, BAT, TEMP): FONT_XTINY (0x999999, left-aligned, 16px from edge)
- **Values**: FONT_SMALL (colored, right-aligned)
- **Goal** (for steps): FONT_XTINY (gray, right-aligned)

### Color Palette
- **Time**: 0xFFFFFF
- **Date**: 0x555555
- **Label text**: 0x999999 (medium gray)
- **Steps**: 0x38BDF8
- **HR**: 0xF87171
- **Battery**: 0x4ADE80
- **Temperature**: 0x2DD4BF
- **Progress track**: 0x111111 (dark gray)
- **Dividers**: 0x1C1C1C (subtle)
- **AOD**: Accents → 0x282828, time → 0x777777, text → 0x282828

### Metrics to Keep / Remove
- **KEEP**: Time, Date, Steps (with goal and progress bar), HR, Battery, Temperature
- **REMOVE**: Calories, Distance, Floors, Sparkline (too much data)
- **RATIONALE**: Core health metrics (steps, HR, battery) + contextual info (temp)

### Progress Indicators
- **Steps Progress Bar**: Rectangular, 220px wide × 4px tall, positioned y=150
  - Track: 0x111111, Fill: 0x38BDF8
  - Rounded ends (h/2 radius)

### Spacing & Padding
- Horizontal margins: 70px from edges
- Time to Date: 45px vertical gap
- Dividers: 10px above, 15px below
- Section gaps: 25-30px between major sections
- Label to value vertical gap: 12px

### AOD Mode
- Remove all dividers (simplify to time + essential data)
- Time: 0x777777
- All labels/values: 0x282828
- Progress bar: dim (0x282828 fill)
- Cleaner, minimal appearance for power efficiency

---

## 3. STRATA — Layered Bands

### Current Issues
- **Bands too close**: y=102, y=195 (93px between), y=307 (112px) — inconsistent spacing
- **Cramped middle**: Time, date, and bar all squeezed in center
- **Battery hard to read**: Forced to right edge at y=80
- **Sunset clutters bottom**: Not essential

### New Layout
```
              ┌─────────────────┐
              │                 │
          TOP │ DATE:  14 MAR   │  60px height band
          BAND│ BAT:   68%      │
              │ ──────────────  │
              │                 │
       CENTER │    12:45        │  ← Time, large FONT_NUMBER_HOT
          BAND│                 │  ← Big breathing room here (80px)
              │ STEPS:  12,345  │
              │ [████░░░░░░]    │  ← Progress bar
              │ ──────────────  │
              │                 │
        BOTTOM│ HEART:  72 bpm  │  40px height band
          BAND│ TEMP:   68°F    │
              │                 │
              └─────────────────┘
```

### Typography
- **Top band**: FONT_XTINY for labels/values (DATE, BAT)
- **Center band**: FONT_NUMBER_HOT for time (y=165, centered, white, 72px)
- **Center band data**: FONT_SMALL for steps (y=220, colored)
- **Bottom band**: FONT_TINY for HR + temp (y=290, colored)

### Color Palette
- Same as Horizon: cyan steps, red HR, green battery, teal temp
- Dividers: 0x1C1C1C (subtle, thin)
- Labels: 0x999999
- Values: Full color
- **AOD**: Dividers disappear, all accents → 0x282828

### Metrics to Keep / Remove
- **KEEP**: Date, Battery, Time, Steps (with goal + progress), HR, Temperature
- **REMOVE**: Sunset (not essential)

### Progress Indicators
- **Steps Bar**: Rectangular, 200px wide × 5px tall (y=245)
  - Positioned below steps value
  - Same style as Vitals

### Spacing & Padding
- Top band: y=45-95 (50px height)
- Center band: y=95-260 (165px height) — most space for time + data
- Bottom band: y=260-310 (50px height)
- Dividers: y=95, y=260 (clear separation)
- Horizontal margins: 70px from edges
- Vertical padding within bands: 12-16px

### AOD Mode
- Top band: Minimal (DATE only, no BAT)
- Center band: TIME only (remove steps/bar)
- Bottom band: Remove entirely
- Overall: Just time + date on black, ~40% of display used for power savings

---

## 4. SIGNAL — Minimal Data Viz

### Current Issues
- **Sparse layout**: Concentric rings, gradient line, but steps label is "steps" not a metric
- **Sunset top-right**: Wastes prime real estate, broken data
- **Accent line**: Nice but takes space, could be better used
- **Bottom row cramped**: Only 36px from date to HR/battery

### New Layout
```
              ┌─────────────────┐
              │  (subtle rings) │  ← Keep concentric circles (visual interest)
              │                 │
            80│  MON 15 MAR     │  ← Date, FONT_XTINY, gray
              │                 │
           160│    12:45        │  ← Time, FONT_NUMBER_HOT, white, HERO
              │                 │
           230│ [●] 12,345 STEPS│  ← Steps with small circle badge (colored)
              │                 │
           290│ 72 BPM    68°F  │  ← HR + Temp, small, minimal
              │ 68% BAT        │  ← Battery below (one line)
              │                 │
              └─────────────────┘
```

### Typography
- **Date**: FONT_XTINY (y=80, gray)
- **Time**: FONT_NUMBER_HOT (y=160, white, 72px)
- **Steps**: FONT_SMALL (y=230, cyan) + small FONT_XTINY label
- **Metrics row**: FONT_TINY (y=290, colored — red HR, teal temp, green battery)

### Color Palette
- Same accent palette (cyan, red, teal, green)
- Remove the indigo gradient line (simplify)
- Keep concentric rings (0x080808, subtle, active mode only)
- **AOD**: Rings disappear, all text → 0x282828

### Metrics to Keep / Remove
- **KEEP**: Date, Time, Steps (hero), HR, Temperature, Battery
- **REMOVE**: Sunset, gradient accent line (unnecessary)

### Progress Indicators
- **Steps Badge**: Small colored circle (30px diameter) left of "STEPS" text
  - Fills proportionally based on step goal
  - Color: 0x38BDF8 (cyan)

### Spacing & Padding
- Date y=80 (clear top space)
- Time y=160 (center visual weight)
- Steps y=230 (breathing room)
- Metrics y=290, y=320 (bottom, compact)
- Horizontal: 85px from edges for text, rings can be at center
- Concentric rings: 80px, 140px, 200px radius (symmetric)

### AOD Mode
- Remove concentric rings entirely
- Keep date (y=80)
- Keep time (y=160, dimmed)
- Remove steps badge and decoration
- Just time + date + minimal metrics below (all gray 0x282828)

---

## 5. TACTICAL — Military Field Watch

### Current Issues
- **Row stacking**: 6 rows of data, cramped vertically
  - y=37 (time), y=41 (date), y=30 divider, y=52 onwards (data)
- **Data density**: STEPS, HR, BAT, SUNSET — too many key:value pairs
- **Sunset unnecessary**: Remove completely
- **Layout is actually decent** but needs better spacing

### New Layout
```
              ┌─────────────────┐
              │ (olive ticks)   │
              │                 │
            75│  15 MAR 2026    │  ← Military date, FONT_XTINY, dim olive
              │                 │
           155│    12:45        │  ← Time, FONT_NUMBER_HOT, sand (HERO)
              │ ──────────────  │  ← Divider
              │                 │
           220│ STEPS: 12,345   │  ← Left column, label + value (sand)
           250│ HEART: 72 bpm   │
              │                 │
           310│ BAT: 68%        │  ← Single metric at bottom
              │ TEMP: 68°F      │
              │                 │
              └─────────────────┘
```

### Typography
- **Date**: FONT_XTINY (y=75, dim olive 0x5A5A30, military format)
- **Time**: FONT_NUMBER_HOT (y=155, sand 0xD4D4A0, HERO, 72px)
- **Labels** (STEPS, HEART, BAT, TEMP): FONT_XTINY (dim olive)
- **Values**: FONT_SMALL (sand 0xD4D4A0)

### Color Palette
- **Active**: Olive (0xA3A651) for ticks + some accents, Sand (0xD4D4A0) for primary text
- **Dim Olive**: 0x5A5A30 for labels and date
- **Time**: Sand (0xD4D4A0)
- **Divider**: Dim olive (0x5A5A30)
- **AOD**: All accents → 0x282828, time → 0x777777, dim olive → 0x1A1A1A

### Metrics to Keep / Remove
- **KEEP**: Date (military format), Time, Steps, HR, Battery, Temperature
- **REMOVE**: Sunset (not essential, military watches don't show it)

### Progress Indicators
- **No progress bars** (too utilitarian, breaks military aesthetic)
- Could add: Small circular battery indicator (optional, subtle)

### Spacing & Padding
- Date: y=75 (clear top)
- Time: y=155 (center, with large weight)
- Divider: y=190 (clear separation)
- Data rows: y=220, y=250 (30px apart, comfortable)
- Bottom metrics: y=310, y=340 (compact group)
- Horizontal margins: 90px from edges (respects circular constraint)
- Hour markers: Thick lines at cardinal points (already implemented well)

### AOD Mode
- Remove hour markers (save power)
- Time only (sand → 0x777777)
- Minute ticks remain (subtle navigation aid)
- No data below time (just time + date, minimal)

---

## 6. RETRO LCD — Amber Segments

### Current Issues
- **Two panels compete**: Top panel (steps, HR, sunset, battery) + bottom panel (time + seconds)
- **Sunset wastes space**: Remove
- **Dual-panel design** is awkward — time should be more prominent
- **Seconds display** is nice but takes horizontal space

### New Layout (Option A: Single Hero Time)
```
              ┌─────────────────┐
              │ MON    15 MAR   │  ← Date split left/right (amber)
              │ ────────────────│
              │                 │
              │     12:45       │  ← Time HERO (FONT_NUMBER_THAI_HOT, amber, 60px)
              │                 │
              │ ────────────────│
              │ STEPS   HEART   │  ← Two columns
              │ 12,345  72 bpm  │
              │                 │
              │ BAT: 68%        │  ← Battery + temp (compact)
              │ TEMP: 68°F      │
              │                 │
              └─────────────────┘
```

### Typography
- **Date**: FONT_TINY (split left/right, y=50, amber)
- **Time**: FONT_NUMBER_THAI_HOT (y=155, amber, HERO)
- **Labels**: FONT_XTINY (dim amber 0x664800)
- **Values**: FONT_SMALL (amber 0xFFB000)

### Color Palette
- **Amber**: 0xFFB000 (primary)
- **Dim Amber**: 0x664800 (labels, date)
- **Panel borders**: 0x1A1A1A (subtle, 1px)
- **AOD**: Amber → 0x444444, dim amber → 0x1A1A1A

### Metrics to Keep / Remove
- **KEEP**: Date, Time, Steps, HR, Battery, Temperature
- **REMOVE**: Sunset, Seconds display (takes space, not essential)

### Progress Indicators
- **No progress bars** (clashes with retro aesthetic)
- Keep it minimal and segment-focused

### Spacing & Padding
- Panel positions:
  - Top section: y=35-180 (date + time)
  - Bottom section: y=180-330 (metrics)
- Horizontal: 85px from edges
- Vertical between sections: 15px
- Panel border width: 220px
- Row height: 28px (comfortable, not cramped)

### AOD Mode
- Minimal amber (very dim)
- Time + date only
- No metrics panel
- Just essential timekeeping info

---

## 7. GRID — Clean 2×3 Stat Cells

### Current Issues
- **Sunset wastes cell** (row 2, right): Remove
- **Cell height 36px**: Adequate but could be 40-44px for better breathing room
- **Typography density**: Labels and values cramped vertically
- **Overall layout is actually solid** — main fix is removing sunset and increasing whitespace

### New Layout
```
              ┌─────────────────┐
            55│    12:45        │  ← Time, FONT_NUMBER_HOT, white
              │  MON 15 MAR     │  ← Date, FONT_XTINY, gray
              │                 │
          y=95├────────┬────────┤
              │ STEPS  │ HEART  │
          y=105│ 12,345 │ 72 bpm │
              │        │        │
          y=135├────────┼────────┤
              │BATTERY │ TEMP   │
          y=145│  68%   │ 68°F   │
              │        │        │
          y=175├────────┼────────┤
              │ DISTANCE│CALORIES│
          y=185│ 2.4 mi │ 580 cal│
              │        │        │
          y=215└────────┴────────┘
```

### Typography
- **Time**: FONT_NUMBER_HOT (y=55, white, 72px, centered)
- **Date**: FONT_XTINY (y=75, gray, centered)
- **Cell labels**: FONT_XTINY (0x999999, uppercase, 10px from top of cell)
- **Cell values**: FONT_SMALL (colored, 22px from top of cell)

### Color Palette
- **Time**: 0xFFFFFF
- **Date**: 0x555555
- **Grid lines**: 0x1C1C1C (subtle)
- **Labels**: 0x999999
- **Values**: Colored (cyan steps, red HR, green battery, teal temp, gold distance/calories)
- **AOD**: Lines → 0x0E0E0E, labels → 0x282828, values → 0x282828

### Metrics to Keep / Remove
- **KEEP**: Time, Date, Steps, HR, Battery, Temperature, Distance, Calories
- **REMOVE**: Sunset (not useful, takes cell space)
- **RATIONALE**: 6 metrics fit comfortably in 2×3 grid

### Progress Indicators
- Could optionally make one cell a circular progress (battery or steps)
- Keep simple for now — rectangle grid is clean
- If adding progress, use middle-right cell (currently Temperature) as a circular battery indicator

### Spacing & Padding
- Time y=55, date y=75 (total 45px for header)
- Grid top y=95
- Cell heights: 40px each (with 0px gap between dividers)
- Row dividers: y=135, y=175
- Vertical divider: x=CX (center)
- Horizontal margins: 80px from edges
- Padding within cells: 8px (label), 16px (value)

### AOD Mode
- Time: 0x777777 (dimmed)
- Date: 0x282828
- Grid lines: Nearly black (0x0E0E0E)
- All values: 0x282828
- Very minimal, just time visible at glance

---

## Implementation Checklist

### Phase 1: Spacing & Layout
- [ ] Adjust Y positions for all text elements per spec
- [ ] Add whitespace padding per section
- [ ] Verify text doesn't overlap using getTextDimensions()
- [ ] Test on emulator at 390×390

### Phase 2: Typography
- [ ] Confirm all fonts are built-in Garmin fonts (no custom TTF)
- [ ] FONT_NUMBER_HOT for all time displays (consistent)
- [ ] FONT_SMALL for important metrics
- [ ] FONT_XTINY for labels
- [ ] FONT_TINY for secondary metrics

### Phase 3: Remove Sunset
- [ ] Delete Data.getSunEvent() calls from all faces
- [ ] Remove getSunIcon() helper function
- [ ] Remove sunrise/sunset weather API calls
- [ ] Test all faces compile without errors

### Phase 4: Add Progress Arcs
- [ ] Horizon: Battery arc (circular, 180px diameter)
- [ ] Vitals: Keep simple (linear bar for steps)
- [ ] Strata: Linear bar for steps
- [ ] Signal: Small badge circle for steps
- [ ] Tactical: No arcs (military aesthetic)
- [ ] Retro LCD: No arcs (LCD aesthetic)
- [ ] Grid: Optional battery circle (future enhancement)

### Phase 5: AOD Optimization
- [ ] Reduce line drawings in sleep mode
- [ ] Dim all text per spec (0x282828 for accents, 0x777777 for time)
- [ ] Remove decorative elements (ticks, rings, arcs) in AOD
- [ ] Test battery impact

### Phase 6: Color Consistency
- [ ] Add temperature color (0x2DD4BF teal) to Colors.mc if missing
- [ ] Update all faces to use consistent accent colors
- [ ] Verify AOD mode desaturates all accents

---

## Notes for Implementation

### Font Sizes Reference
- **FONT_NUMBER_HOT**: ~72px, best for time
- **FONT_NUMBER_THAI_HOT**: Similar, also good for time
- **FONT_SMALL**: ~20-24px, good for metric values
- **FONT_TINY**: ~16-18px, good for secondary data
- **FONT_XTINY**: ~12-14px, good for labels

### getTextDimensions() Gotchas
- Always call before laying out overlapping text
- Remember to set the font first: `dc.setFont(font)`
- Dimensions are [w, h] array
- Centered text needs: `x - w/2` and `y - h/2`

### Color Palette Summary
```
ACTIVE MODE:
- TIME: 0xFFFFFF (white)
- DATE: 0x555555 (gray)
- STEPS: 0x38BDF8 (cyan)
- HR: 0xF87171 (red)
- BATTERY: 0x4ADE80 (green)
- TEMP: 0x2DD4BF (teal)
- LABEL: 0x999999 (dim gray)
- DIVIDER: 0x1C1C1C (very dark)

AOD MODE:
- TIME: 0x777777 (dim gray)
- ALL ACCENTS: 0x282828 (dark gray)
- DIVIDER: 0x0E0E0E (nearly black)
```

### Circular Constraint
- Display is 390×390, but circular
- Safe area: center 340×340 (±170px from center)
- Edges (±170-195px) can use for perimeter ticks/rings
- Content should stay within 340px diameter (radius 170px from center)

---

## Testing Checklist

For each face:
1. Verify time display is readable and doesn't overlap date
2. Confirm all metrics are visible and colored correctly
3. Check AOD mode shows minimal data (power efficiency)
4. Test with getTextDimensions() that no text overlaps
5. Emulate on Venu 3S device (390×390 AMOLED)
6. Verify progress indicators appear (if included)
7. Check spacing is generous, not cramped
8. Confirm no sunset references in compiled output

---

## Files to Modify

### Horizon
- `/Users/kychadha/projects/watch-face/apps/horizon/source/faces/HorizonFace.mc`
- Add battery arc, remove sunset, adjust spacing

### Vitals
- `/Users/kychadha/projects/watch-face/apps/vitals/source/faces/VitalsFace.mc`
- Remove calories, distance, floors, sparkline; increase spacing; remove sunset

### Strata
- `/Users/kychadha/projects/watch-face/apps/strata/source/faces/StrataFace.mc`
- Adjust band spacing, remove sunset, add temperature metric

### Signal
- `/Users/kychadha/projects/watch-face/apps/signal/source/faces/SignalFace.mc`
- Remove gradient line, remove sunset, add temperature, keep rings

### Tactical
- `/Users/kychadha/projects/watch-face/apps/tactical/source/faces/TacticalFace.mc`
- Adjust spacing, remove sunset, add temperature, keep military aesthetic

### Retro LCD
- `/Users/kychadha/projects/watch-face/apps/retro_lcd/source/faces/RetroLcdFace.mc`
- Simplify panels, remove sunset, remove seconds, add temperature

### Grid
- `/Users/kychadha/projects/watch-face/apps/grid/source/faces/GridFace.mc`
- Remove sunset cell, increase cell padding, add temperature, adjust spacing

### Colors.mc (add if needed)
- Add TEMP color constant if missing: `const TEMP = 0x2DD4BF;`
- Add `function temp(aod as Boolean)` if missing

### Data.mc (cleanup)
- Mark `getSunEvent()` and `getSunIcon()` as deprecated
- These can be removed entirely once all faces are updated
