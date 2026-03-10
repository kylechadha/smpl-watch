import Toybox.Graphics;
import Toybox.Lang;

// Face 17: Grid — Clean 2x3 stat cells with thin dividers
class GridFace {

    function draw(dc as Dc, aod as Boolean) as Void {
        var S = Draw.S;
        var CX = Draw.CX;
        var CY = Draw.CY;

        // Time centered
        Draw.text(dc, Data.getTimeString(), CX, CY - 50,
            Graphics.FONT_NUMBER_HOT, Colors.time(aod));

        // Date
        Draw.text(dc, Data.getDateCompact(), CX, CY - 6,
            Graphics.FONT_XTINY, Colors.date(aod));

        // Grid: 2 cols x 3 rows
        var gx1 = 80;
        var gx3 = S - 80;
        var gy0 = CY + 20;
        var rowH = 36;

        // Horizontal dividers
        Draw.hline(dc, gx1, gy0, gx3, Colors.sep(aod));
        Draw.hline(dc, gx1, gy0 + rowH, gx3, Colors.sep(aod));
        Draw.hline(dc, gx1, gy0 + rowH * 2, gx3, Colors.sep(aod));

        // Vertical divider
        dc.setColor(Colors.sep(aod), Colors.BLACK);
        dc.setPenWidth(1);
        dc.drawLine(CX, gy0, CX, gy0 + rowH * 3);

        // Cell positions
        var cl = (gx1 + CX) / 2;  // Left column center
        var cr = (CX + gx3) / 2;  // Right column center

        // Row 1: Steps | Heart
        Draw.text(dc, "STEPS", cl, gy0 + 10,
            Graphics.FONT_XTINY, Colors.label(aod));
        Draw.text(dc, Data.formatNumber(Data.getSteps()), cl, gy0 + 26,
            Graphics.FONT_SMALL, Colors.steps(aod));

        var hrVal = Data.getHeartRate();
        var hrStr = (hrVal > 0) ? hrVal.format("%d") : "--";
        Draw.text(dc, "HEART", cr, gy0 + 10,
            Graphics.FONT_XTINY, Colors.label(aod));
        Draw.text(dc, hrStr, cr, gy0 + 26,
            Graphics.FONT_SMALL, Colors.hr(aod));

        // Row 2: Battery | Sunset
        Draw.text(dc, "BATTERY", cl, gy0 + rowH + 10,
            Graphics.FONT_XTINY, Colors.label(aod));
        Draw.text(dc, Data.getBattery().format("%d") + "%", cl, gy0 + rowH + 26,
            Graphics.FONT_SMALL, Colors.bat(aod));

        Draw.text(dc, "SUNSET", cr, gy0 + rowH + 10,
            Graphics.FONT_XTINY, Colors.label(aod));
        Draw.text(dc, Data.getSunEvent(), cr, gy0 + rowH + 26,
            Graphics.FONT_SMALL, Colors.sun(aod));

        // Row 3: Distance | Calories
        Draw.text(dc, "DISTANCE", cl, gy0 + rowH * 2 + 10,
            Graphics.FONT_XTINY, Colors.label(aod));
        Draw.text(dc, Data.getDistance() + " mi", cl, gy0 + rowH * 2 + 26,
            Graphics.FONT_SMALL, Colors.teal(aod));

        Draw.text(dc, "CALORIES", cr, gy0 + rowH * 2 + 10,
            Graphics.FONT_XTINY, Colors.label(aod));
        Draw.text(dc, Data.formatNumber(Data.getCalories()), cr, gy0 + rowH * 2 + 26,
            Graphics.FONT_SMALL, Colors.sun(aod));
    }
}
