import Toybox.Graphics;
import Toybox.Lang;

// Face 10: Signal — Minimal data-viz with concentric rings
class SignalFace {

    function draw(dc as Dc, aod as Boolean) as Void {
        var S = Draw.S;
        var CX = Draw.CX;
        var CY = Draw.CY;

        // Concentric rings (active only)
        if (!aod) {
            dc.setColor(0x080808, Colors.BLACK);
            dc.setPenWidth(1);
            var r = 80;
            while (r < Draw.R) {
                dc.drawArc(CX, CY, r, Graphics.ARC_CLOCKWISE, 0, 360);
                r += 60;
            }
        }

        // Date
        Draw.text(dc, Data.getDateCompact(), CX, 80,
            Graphics.FONT_XTINY, Colors.date(aod));

        // Time — HERO
        Draw.text(dc, Data.getTimeString(), CX, 160,
            Graphics.FONT_NUMBER_HOT, Colors.time(aod));

        // Steps hero
        var steps = Data.getSteps();
        Draw.text(dc, Data.formatNumber(steps) + " STEPS", CX, 230,
            Graphics.FONT_SMALL, Colors.steps(aod));

        // HR + Temp + Battery
        var hrVal = Data.getHeartRate();
        var hrStr = (hrVal > 0) ? hrVal.format("%d") + " bpm" : "-- bpm";
        Draw.textLeft(dc, hrStr, 70, 290,
            Graphics.FONT_TINY, Colors.hr(aod));
        Draw.textRight(dc, Data.getTemperature() + "°F", S - 70, 290,
            Graphics.FONT_TINY, Colors.temp(aod));

        Draw.text(dc, "BAT: " + Data.getBattery().format("%d") + "%", CX, 320,
            Graphics.FONT_XTINY, Colors.bat(aod));
    }
}
