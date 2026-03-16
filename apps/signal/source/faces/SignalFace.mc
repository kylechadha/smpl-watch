import Toybox.Graphics;
import Toybox.Lang;

// Face 10: Signal — Minimal data-viz with indigo gradient accent bar
class SignalFace {

    function draw(dc as Dc, aod as Boolean) as Void {
        var S = Draw.S;
        var CX = Draw.CX;
        var CY = Draw.CY;

        // Subtle concentric rings (active only)
        if (!aod) {
            dc.setColor(0x080808, Colors.BLACK);
            dc.setPenWidth(1);
            var r = 80;
            while (r < Draw.R) {
                dc.drawArc(CX, CY, r, Graphics.ARC_CLOCKWISE, 0, 360);
                r += 60;
            }
        }

        // Sunset — top right
        Draw.textRight(dc, Data.getSunIcon() + " " + Data.getSunEvent(), S - 85, 78,
            Graphics.FONT_XTINY, Colors.sun(aod));

        // Time — large, light
        Draw.text(dc, Data.getTimeString(), CX, CY - 38,
            Graphics.FONT_NUMBER_THAI_HOT, Colors.time(aod));

        // Date
        Draw.text(dc, Data.getDateString(), CX, CY + 18,
            Graphics.FONT_TINY, Colors.date(aod));

        // Gradient accent line (simplified — just a colored line in Monkey C)
        if (!aod) {
            dc.setColor(Colors.ACCENT, Colors.BLACK);
            dc.setPenWidth(2);
            dc.drawLine(CX - 100, CY + 42, CX + 100, CY + 42);
        } else {
            Draw.hline(dc, CX - 80, CY + 42, CX + 80, Colors.dim(aod));
        }

        // Steps hero
        Draw.text(dc, Data.formatNumber(Data.getSteps()) + " steps", CX, CY + 72,
            Graphics.FONT_SMALL, Colors.accent(aod));

        // Bottom row — HR + battery
        var hrVal = Data.getHeartRate();
        var hrStr = (hrVal > 0) ? hrVal.format("%d") : "--";
        Draw.text(dc, hrStr, CX - 65, CY + 108,
            Graphics.FONT_TINY, Colors.hr(aod));
        Draw.text(dc, Data.getBattery().format("%d") + "%", CX + 65, CY + 108,
            Graphics.FONT_TINY, Colors.bat(aod));
    }
}
