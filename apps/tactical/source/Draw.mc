import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

// Shared drawing utilities used across all face renderers
module Draw {

    const S = 390;
    const CX = 195;
    const CY = 195;
    const R = 193;

    // Draw a horizontal line
    function hline(dc as Dc, x1 as Number, y as Number, x2 as Number, color as Number) as Void {
        dc.setColor(color, Colors.BLACK);
        dc.setPenWidth(1);
        dc.drawLine(x1, y, x2, y);
    }

    // Draw a progress bar
    function bar(dc as Dc, x as Number, y as Number, w as Number, h as Number,
                 pct as Float, bgColor as Number, fgColor as Number) as Void {
        // Background track
        dc.setColor(bgColor, Colors.BLACK);
        dc.fillRoundedRectangle(x, y, w, h, h / 2);
        // Filled portion
        if (pct > 0.0) {
            var fw = (w * pct).toNumber();
            if (fw < h) { fw = h; }
            dc.setColor(fgColor, Colors.BLACK);
            dc.fillRoundedRectangle(x, y, fw, h, h / 2);
        }
    }

    // Draw tick marks around the perimeter
    function ticks(dc as Dc, count as Number, innerR as Number, outerR as Number,
                   color as Number, penWidth as Number) as Void {
        dc.setColor(color, Colors.BLACK);
        dc.setPenWidth(penWidth);
        for (var i = 0; i < count; i++) {
            var angle = (i * (360.0 / count) - 90.0) * Math.PI / 180.0;
            var cos = Math.cos(angle);
            var sin = Math.sin(angle);
            dc.drawLine(
                CX + (innerR * cos).toNumber(),
                CY + (innerR * sin).toNumber(),
                CX + (outerR * cos).toNumber(),
                CY + (outerR * sin).toNumber()
            );
        }
    }

    // Draw a sparkline from an array of values
    function sparkline(dc as Dc, x as Number, y as Number, w as Number, h as Number,
                       data as Array<Number>, color as Number) as Void {
        if (data.size() < 2) { return; }
        var mx = data[0];
        var mn = data[0];
        for (var i = 1; i < data.size(); i++) {
            if (data[i] > mx) { mx = data[i]; }
            if (data[i] < mn) { mn = data[i]; }
        }
        var range = mx - mn;
        if (range == 0) { range = 1; }
        var step = w.toFloat() / (data.size() - 1);

        dc.setColor(color, Colors.BLACK);
        dc.setPenWidth(2);
        for (var i = 0; i < data.size() - 1; i++) {
            var x1 = x + (i * step).toNumber();
            var y1 = y + h - ((data[i] - mn).toFloat() / range * h).toNumber();
            var x2 = x + ((i + 1) * step).toNumber();
            var y2 = y + h - ((data[i + 1] - mn).toFloat() / range * h).toNumber();
            dc.drawLine(x1, y1, x2, y2);
        }
    }

    // Draw centered text helper
    function text(dc as Dc, str as String, x as Number, y as Number,
                  font as Graphics.FontType, color as Number) as Void {
        dc.setColor(color, Colors.TRANS);
        dc.drawText(x, y, font, str, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    // Draw left-aligned text
    function textLeft(dc as Dc, str as String, x as Number, y as Number,
                      font as Graphics.FontType, color as Number) as Void {
        dc.setColor(color, Colors.TRANS);
        dc.drawText(x, y, font, str, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    // Draw right-aligned text
    function textRight(dc as Dc, str as String, x as Number, y as Number,
                       font as Graphics.FontType, color as Number) as Void {
        dc.setColor(color, Colors.TRANS);
        dc.drawText(x, y, font, str, Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}
