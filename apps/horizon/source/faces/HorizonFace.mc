import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

// Face 1: Horizon — Clean minimal with battery arc
class HorizonFace {

    function draw(dc as Dc, aod as Boolean) as Void {
        var S = Draw.S;
        var CX = Draw.CX;
        var CY = Draw.CY;
        var R = Draw.R;

        // Subtle perimeter ticks (active only)
        if (!aod) {
            Draw.ticks(dc, 60, R - 8, R - 2, 0x0F0F0F, 1);
        }

        // Date — small, gray, top
        Draw.text(dc, Data.getDateCompact(), CX, 90,
            Graphics.FONT_XTINY, Colors.date(aod));

        // Time — large hero
        Draw.text(dc, Data.getTimeString(), CX, 150,
            Graphics.FONT_NUMBER_HOT, Colors.time(aod));

        // Battery arc (circular, 180px diameter, centered at y=220)
        if (!aod) {
            var arcRadius = 90;
            var batPercent = Data.getBatteryFloat();
            var endDegree = 270 + (batPercent * 3.6).toNumber();  // 270° (bottom) + 0-360° sweep
            dc.setColor(Colors.BAT, Colors.BLACK);
            dc.setPenWidth(3);
            dc.drawArc(CX, 220, arcRadius, Graphics.ARC_CLOCKWISE, 270, endDegree);
        } else {
            // AOD: just dim circle outline
            dc.setColor(Colors.AOD_ACC, Colors.BLACK);
            dc.setPenWidth(2);
            dc.drawArc(CX, 220, 90, Graphics.ARC_CLOCKWISE, 270, 630);
        }

        // Battery label + steps right
        Draw.text(dc, "[●]", CX - 60, 240,
            Graphics.FONT_XTINY, Colors.label(aod));
        Draw.text(dc, Data.formatNumber(Data.getSteps()), CX + 50, 240,
            Graphics.FONT_SMALL, Colors.steps(aod));

        // HR + Temp metrics row
        var hrVal = Data.getHeartRate();
        var hrStr = (hrVal > 0) ? hrVal.format("%d") + " bpm" : "-- bpm";
        Draw.text(dc, hrStr, CX - 55, 285,
            Graphics.FONT_TINY, Colors.hr(aod));
        Draw.text(dc, Data.getTemperature() + "°F", CX + 55, 285,
            Graphics.FONT_TINY, Colors.temp(aod));
    }
}
