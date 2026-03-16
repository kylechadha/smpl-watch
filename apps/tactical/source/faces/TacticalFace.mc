import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

// Face 13: Tactical — Military field watch, olive/sand
class TacticalFace {

    function draw(dc as Dc, aod as Boolean) as Void {
        var S = Draw.S;
        var CX = Draw.CX;
        var CY = Draw.CY;
        var R = Draw.R;

        var olive = aod ? Colors.AOD_ACC : Colors.OLIVE;
        var sand = aod ? Colors.AOD_TIME : Colors.SAND;
        var dimO = aod ? Colors.AOD_DIM : Colors.DIM_OLIVE;

        // Minute ticks
        Draw.ticks(dc, 60, R - 8, R - 2, aod ? 0x111111 : 0x1A1A1A, 1);

        // Hour markers (active only)
        if (!aod) {
            dc.setPenWidth(2);
            for (var i = 0; i < 12; i++) {
                var angle = (i * 30.0 - 90.0) * Math.PI / 180.0;
                var cos = Math.cos(angle);
                var sin = Math.sin(angle);
                dc.setColor(olive, Colors.BLACK);
                dc.drawLine(
                    CX + ((R - 16) * cos).toNumber(),
                    CY + ((R - 16) * sin).toNumber(),
                    CX + ((R - 2) * cos).toNumber(),
                    CY + ((R - 2) * sin).toNumber()
                );
            }
        }

        // Date — military format
        Draw.text(dc, Data.getMilitaryDate(), CX, 75,
            Graphics.FONT_XTINY, dimO);

        // Time — HERO
        Draw.text(dc, Data.getTimeString(), CX, 155,
            Graphics.FONT_NUMBER_HOT, sand);

        // Divider
        Draw.hline(dc, 85, 190, S - 85, dimO);

        // Data rows
        Draw.textLeft(dc, "STEPS: " + Data.formatNumber(Data.getSteps()), 85, 220,
            Graphics.FONT_XTINY, sand);

        var hrVal = Data.getHeartRate();
        var hrStr = (hrVal > 0) ? hrVal.format("%d") + " bpm" : "-- bpm";
        Draw.textLeft(dc, "HEART: " + hrStr, 85, 250,
            Graphics.FONT_XTINY, sand);

        Draw.textLeft(dc, "BAT: " + Data.getBattery().format("%d") + "%", 85, 310,
            Graphics.FONT_XTINY, sand);

        Draw.textLeft(dc, "TEMP: " + Data.getTemperature() + "°F", 85, 340,
            Graphics.FONT_XTINY, sand);
    }
}
