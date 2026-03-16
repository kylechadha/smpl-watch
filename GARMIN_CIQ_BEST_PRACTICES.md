# Garmin Connect IQ Best Practices Guide

Research compiled March 2025. Exact API references and code examples from official Garmin SDK docs, forums, and GitHub examples.

---

## 1. Custom Vector Fonts in Garmin Connect IQ

### Directory Structure

Standard project layout for fonts:

```
project-root/
├── resources/
│   ├── fonts/
│   │   ├── fonts.xml
│   │   ├── CustomFont.fnt
│   │   ├── CustomFont_0.png
│   │   ├── CustomFont_1.png
│   │   └── CustomFont_*.png
│   ├── drawables/
│   ├── layouts/
│   └── strings/
├── source/
│   └── YourApp.mc
├── manifest.xml
└── monkey.jungle
```

### Configuration (Two Approaches)

**Approach 1: Bitmap Fonts (older, .fnt + PNG files)**

`resources/fonts/fonts.xml`:
```xml
<fonts>
  <font id="CustomFont32" filename="fonts/CustomFont.fnt" filter="0123456789:." />
</fonts>
```

**Key points:**
- The `.fnt` file is a descriptor (text format) created by BMFont or FontForge
- Companion PNG files contain the glyph bitmap data (must be PNG, not TGA)
- `filter` attribute restricts which characters are included (saves space)
- Reference in layout: `<label font="@Fonts.CustomFont32" />`
- Load in code: `var font = Rez.Fonts.CustomFont32;`

**Approach 2: Vector Fonts (modern, TTF directly)**

Use Garmin's built-in vector fonts or custom TTF via `Graphics.getVectorFont()`:

```monkey-c
var myFont = Graphics.getVectorFont({
  :face => ["RobotoRegular", "Swiss721Regular"],
  :size => 34
});

if (myFont == null) {
  // Fallback for older devices
  myFont = Graphics.FONT_LARGE;
}

dc.drawText(100, 100, myFont, "Hello", Gfx.TEXT_JUSTIFY_CENTER);
```

**Available Built-in Vector Font Faces** (device dependent, check `simulator.json`):
- RobotoRegular, RobotoCondensedRegular
- RobotoLight, RobotoThin (good for AMOLED)
- Swiss721Regular, Bionic
- **Note:** Not all fonts available on all devices

### Finding Available Vector Fonts

Open your device's simulator configuration:
```
SDK/devices/[DEVICE]/simulator.json
```

Look for entries with `"type": "system_ttf"`. The `"name"` field is the face name to pass to `getVectorFont()`.

### Handling Font Loading Errors

```monkey-c
function getOptimalFont(preferredSize) {
  if (Toybox.Graphics has :getVectorFont) {
    var font = Graphics.getVectorFont({
      :face => ["RobotoRegular", "RobotoLight", "Bionic"],
      :size => preferredSize
    });
    if (font != null) {
      return font;
    }
  }

  // Fallback to system fonts if vector unavailable
  return Graphics.FONT_LARGE;
}
```

### AMOLED Optimization

- **Use thin/light font weights:** `RobotoThin`, `RobotoLight` reduce burn-in risk
- **Avoid always-on static text:** Prefer variable content
- **Test with actual AMOLED device or Venu 3/3S emulator** — bitmap fonts may render differently

### File Size & Performance

- **Bitmap font PNG limit:** Each PNG should be <100KB for typical glyphs
- **Vector font benefit:** One TTF handles all sizes, smaller overall package
- **Best practice:** Use vector fonts where supported (API 4.2.1+), fallback to bitmap

### Loading Custom Fonts at Runtime

```monkey-c
import Toybox.WatchUi as WatchUi;

var customFont = WatchUi.loadResource(Rez.Fonts.CustomFont32);
dc.drawText(x, y, customFont, text, justification);
```

---

## 2. Text Measurement & Overflow Prevention

### Core Text Measurement API

**`dc.getTextDimensions(text, font)` → `[width, height]`**
- Returns array: `[width_in_pixels, height_in_pixels]`
- Accounts for newlines in text
- Height is **full font height** (ascent + descent), not just visible pixels
- Call in `onLayout()` once, not repeatedly in `onUpdate()`

**`dc.getTextWidthInPixels(text, font)` → width**
- Faster if only width needed
- Useful for measuring individual strings

### Text Dimension Quirk: Ascent & Descent

The returned height includes font metrics whitespace:

```monkey-c
var dims = dc.getTextDimensions("Text", myFont);
var actualWidth = dims[0];
var fontHeight = dims[1];  // Includes ascent/descent padding

// Actual visible text height is smaller:
var visibleHeight = dc.getFontHeight(myFont);  // More accurate
var ascent = dc.getFontAscent(myFont);
var descent = dc.getFontDescent(myFont);
```

**Workaround:** Use `TEXT_VCENTER` alignment to reduce apparent descent padding.

### Detecting Text Overflow

```monkey-c
function willTextFit(text, font, maxWidth) {
  var width = dc.getTextWidthInPixels(text, font);
  return width <= maxWidth;
}

function truncateToFit(text, font, maxWidth) {
  if (dc.getTextWidthInPixels(text, font) <= maxWidth) {
    return text;
  }

  // Binary search for longest fitting string
  for (var i = text.length() - 1; i > 0; i--) {
    var truncated = text.substring(0, i) + "…";
    if (dc.getTextWidthInPixels(truncated, font) <= maxWidth) {
      return truncated;
    }
  }
  return "…";
}
```

### Safe Text Rendering Strategy

```monkey-c
function drawSafeText(dc, x, y, text, font, maxWidth, justify) {
  var width = dc.getTextWidthInPixels(text, font);

  if (width > maxWidth) {
    // Truncate or scale
    text = truncateToFit(text, font, maxWidth);
    width = dc.getTextWidthInPixels(text, font);
  }

  // Add padding to prevent edge cutoff
  var padding = 4;
  if (x + width + padding > dc.getWidth()) {
    x = dc.getWidth() - width - padding;
  }
  if (x < padding) {
    x = padding;
  }

  dc.drawText(x, y, font, text, justify);
}
```

### Preventing Overlap Between Elements

```monkey-c
function layoutWithoutOverlap(dc, elements) {
  var yPos = 20;
  var padding = 8;

  for (var i = 0; i < elements.size(); i++) {
    var element = elements[i];
    var dims = dc.getTextDimensions(element["text"], element["font"]);

    // Check if we're running out of vertical space
    if (yPos + dims[1] + padding > dc.getHeight()) {
      System.println("Not enough space for element " + i);
      break;  // Skip remaining elements
    }

    dc.drawText(element["x"], yPos, element["font"], element["text"],
                element["justify"]);

    yPos += dims[1] + padding;
  }
}
```

---

## 3. Emulator Testing for Pixel-Perfect Accuracy

### Simulator Screenshot Capture

**Built-in approach:**
1. Run app in emulator: `monkeydo app.prg device-name`
2. Use emulator's built-in screenshot tool (camera icon in toolbar)
3. Saved to `~/Library/Caches/Garmin/connectiq/devices/[device]/screenshots/`

**Programmatic verification:**
```monkey-c
// Log dimensions for debugging
System.println("Screen: " + dc.getWidth() + " x " + dc.getHeight());
System.println("Text width: " + dc.getTextWidthInPixels(myText, myFont));
System.println("Font height: " + dc.getFontHeight(myFont));
```

### Inspecting Pixel-Perfect Rendering

**Using device reference simulator:**
1. Check target device in `simulator.json` (resolution, DPI, color depth)
2. Venu 3S: 390x390, AMOLED, 454 DPI
3. Compare emulator output to actual screenshots for discrepancies

**Common emulator vs device differences:**
- AMOLED antialiasing may differ from emulator
- Vector font rendering smoother on device
- Bitmap font may appear bolder due to rasterization

### Verifying Font Loading

```monkey-c
function onUpdate(dc) {
  var font = Graphics.getVectorFont({:face => ["RobotoRegular"], :size => 24});

  if (font == null) {
    System.println("ERROR: Vector font unavailable on this device");
    dc.drawText(50, 50, Graphics.FONT_LARGE, "Font unavailable",
                Gfx.TEXT_JUSTIFY_CENTER);
  } else {
    System.println("Font loaded successfully");
    dc.drawText(50, 50, font, "Font OK", Gfx.TEXT_JUSTIFY_CENTER);
  }
}
```

### Debugging Text Clipping

```monkey-c
function debugTextClipping(dc, x, y, text, font) {
  var dims = dc.getTextDimensions(text, font);
  var width = dims[0];
  var height = dims[1];

  // Draw bounding box
  dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
  dc.drawRectangle(x, y, width, height);

  // Draw text
  dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
  dc.drawText(x, y, font, text, Gfx.TEXT_JUSTIFY_LEFT);

  // Log if it exceeds screen bounds
  if (x + width > dc.getWidth()) {
    System.println("WARNING: Text " + text + " extends beyond right edge");
  }
}
```

---

## 4. Progress Bars in Garmin Connect IQ

### Arc-Based Circular Progress

**Parameters for `dc.drawArc()`:**
```monkey-c
dc.drawArc(
  x,                           // center X
  y,                           // center Y
  radius,                       // arc radius in pixels
  Graphics.ARC_CLOCKWISE,      // or ARC_COUNTER_CLOCKWISE
  degreeStart,                 // 0=3 o'clock, 90=12 o'clock, 180=9 o'clock
  degreeEnd
);
```

**Angle reference:**
- 0°: 3 o'clock (right)
- 90°: 12 o'clock (top)
- 180°: 9 o'clock (left)
- 270°: 6 o'clock (bottom)

### Simple Battery/Progress Arc

```monkey-c
function drawBatteryArc(dc, centerX, centerY, radius, batteryPercent) {
  var batteryColor = batteryPercent > 20 ? Gfx.COLOR_GREEN : Gfx.COLOR_RED;

  // Full circle background
  dc.setColor(Gfx.COLOR_DARK_GRAY, Gfx.COLOR_TRANSPARENT);
  dc.setPenWidth(4);
  dc.drawArc(centerX, centerY, radius, Graphics.ARC_CLOCKWISE, 0, 360);

  // Progress arc
  var arcDegrees = Math.round((batteryPercent / 100.0) * 360).toNumber();
  dc.setColor(batteryColor, Gfx.COLOR_TRANSPARENT);
  dc.drawArc(centerX, centerY, radius, Graphics.ARC_CLOCKWISE, 90, 90 + arcDegrees);
}
```

### Time-Based Progress (Days)

```monkey-c
function drawDayProgressArc(dc, centerX, centerY, radius) {
  var clockTime = System.getClockTime();
  var secondsInDay = (clockTime.hour * 3600.0) + (clockTime.min * 60.0) + clockTime.sec;
  var secondsPerDay = 24.0 * 3600.0;
  var percentageDay = (secondsInDay / secondsPerDay) * 100.0;
  var angleDegrees = 360.0 - (percentageDay / 100.0 * 360.0);

  // Background full circle
  dc.setColor(Gfx.COLOR_DARK_GRAY, Gfx.COLOR_TRANSPARENT);
  dc.setPenWidth(2);
  dc.drawArc(centerX, centerY, radius, Graphics.ARC_COUNTER_CLOCKWISE, 0, 360);

  // Progress arc (fills counterclockwise from 90°)
  dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
  dc.drawArc(centerX, centerY, radius, Graphics.ARC_COUNTER_CLOCKWISE, 90, angleDegrees + 90);
}
```

### Rectangular Progress Bar (Rounded Corners)

```monkey-c
function drawRoundedProgressBar(dc, x, y, width, height, percent, radius) {
  var barColor = Gfx.COLOR_GREEN;
  var bgColor = Gfx.COLOR_DARK_GRAY;

  // Clamp percent to 0-1
  if (percent > 1.0) { percent = 1.0; }
  if (percent < 0.0) { percent = 0.0; }

  // Background rounded rectangle
  dc.setColor(bgColor, Gfx.COLOR_TRANSPARENT);
  dc.fillRoundedRectangle(x, y, width, height, radius);

  // Filled progress portion
  var fillWidth = Math.round((width * percent)).toNumber();
  if (fillWidth > 0) {
    dc.setColor(barColor, Gfx.COLOR_TRANSPARENT);
    dc.fillRoundedRectangle(x, y, fillWidth, height, radius);
  }

  // Border
  dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
  dc.setPenWidth(1);
  dc.drawRoundedRectangle(x, y, width, height, radius);
}
```

**Usage:**
```monkey-c
// 75% progress bar, 200x20px, 5px corner radius
drawRoundedProgressBar(dc, 50, 100, 200, 20, 0.75, 5);
```

### Steps Progress (Circular)

```monkey-c
function drawStepsCircle(dc, centerX, centerY, radius, currentSteps, goalSteps) {
  var percent = (currentSteps / goalSteps).toFloat();
  if (percent > 1.0) { percent = 1.0; }

  // Background circle
  dc.setColor(Gfx.COLOR_DARK_GRAY, Gfx.COLOR_TRANSPARENT);
  dc.setPenWidth(8);
  dc.drawArc(centerX, centerY, radius, Graphics.ARC_CLOCKWISE, 0, 360);

  // Progress arc (90° = top)
  var arcEnd = 90.0 + (percent * 360.0);
  dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
  dc.drawArc(centerX, centerY, radius, Graphics.ARC_CLOCKWISE, 90, arcEnd.toNumber());

  // Draw step count text in center
  var stepsText = currentSteps.toString();
  var font = Graphics.FONT_LARGE;
  dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
  dc.drawText(centerX, centerY - 10, font, stepsText, Gfx.TEXT_JUSTIFY_CENTER);

  var goalText = "/" + goalSteps.toString();
  dc.drawText(centerX, centerY + 15, Graphics.FONT_SMALL, goalText,
              Gfx.TEXT_JUSTIFY_CENTER);
}
```

### Heart Rate Arc Indicator

```monkey-c
function drawHeartRateArc(dc, centerX, centerY, radius, heartRate, maxHR) {
  var percent = (heartRate / maxHR).toFloat();
  if (percent > 1.0) { percent = 1.0; }

  // Color by zone
  var zoneColor;
  if (percent < 0.5) {
    zoneColor = Gfx.COLOR_BLUE;    // Recovery
  } else if (percent < 0.7) {
    zoneColor = Gfx.COLOR_GREEN;   // Aerobic
  } else if (percent < 0.85) {
    zoneColor = Gfx.COLOR_YELLOW;  // Tempo
  } else {
    zoneColor = Gfx.COLOR_RED;     // Max
  }

  // Background
  dc.setColor(Gfx.COLOR_DARK_GRAY, Gfx.COLOR_TRANSPARENT);
  dc.setPenWidth(6);
  dc.drawArc(centerX, centerY, radius, Graphics.ARC_CLOCKWISE, 0, 360);

  // Zone indicator arc
  var arcDegrees = Math.round((percent * 360.0)).toNumber();
  dc.setColor(zoneColor, Gfx.COLOR_TRANSPARENT);
  dc.drawArc(centerX, centerY, radius, Graphics.ARC_CLOCKWISE, 90, 90 + arcDegrees);
}
```

### Performance Notes

- **drawArc is slow:** Use `:setPenWidth()` to thicken lines instead of drawing multiple arcs
- **drawLine alternative:** For animated progress, consider drawLine segments (faster)
- **Caching:** Precompute angles in `onLayout()`, not `onUpdate()`

---

## Summary Table: Quick Reference

| Task | API | Notes |
|------|-----|-------|
| Load vector font | `Graphics.getVectorFont({:face => [...], :size => N})` | Returns null if unavailable |
| Load bitmap font | `WatchUi.loadResource(Rez.Fonts.ID)` | Must define in fonts.xml first |
| Measure text width | `dc.getTextWidthInPixels(text, font)` | Fast, single value |
| Measure text dims | `dc.getTextDimensions(text, font)` | Returns [width, height] array |
| Prevent overflow | `truncateToFit()` or repositioning | Check bounds before drawing |
| Draw circular arc | `dc.drawArc(x, y, r, direction, start°, end°)` | 0°=right, 90°=top |
| Draw rounded bar | `dc.fillRoundedRectangle(x, y, w, h, radius)` | Use for progress visualization |
| Test in emulator | Screenshot tool in simulator | Compare to device for AMOLED diffs |

---

## External Resources

- **Official Docs:** https://developer.garmin.com/connect-iq/
- **API Reference:** https://developer.garmin.com/connect-iq/api-docs/Toybox/Graphics.html
- **GitHub Examples:** https://github.com/garmin/connectiq-apps
- **Forums:** https://forums.garmin.com/developer/connect-iq/
- **Device Reference:** SDK folder contains `devices/[DEVICE]/simulator.json` with available fonts/specs

