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

        // Hour markers — thicker, olive colored
        dc.setPenWidth(2);
        for (var i = 0; i < 12; i++) {
            var angle = (i * 30.0 - 90.0) * Math.PI / 180.0;
            var cos = Math.cos(angle);
            var sin = Math.sin(angle);
            dc.setColor(aod ? 0x222222 : olive, Colors.BLACK);
            dc.drawLine(
                CX + ((R - 16) * cos).toNumber(),
                CY + ((R - 16) * sin).toNumber(),
                CX + ((R - 2) * cos).toNumber(),
                CY + ((R - 2) * sin).toNumber()
            );
        }

        // Time — bold monospace
        Draw.text(dc, Data.getTimeString(), CX, CY - 30,
            Graphics.FONT_NUMBER_HOT, sand);

        // Date — military format
        Draw.text(dc, Data.getMilitaryDate(), CX, CY + 12,
            Graphics.FONT_XTINY, dimO);

        // Separator
        Draw.hline(dc, 85, CY + 30, S - 85, dimO);

        // Key:value data block — centered columns
        var col1 = CX - 15;
        var col2 = CX + 15;
        var baseY = CY + 52;
        var rowH = 22;

        Draw.textRight(dc, "STEPS", col1, baseY,
            Graphics.FONT_XTINY, dimO);
        Draw.textLeft(dc, Data.formatNumber(Data.getSteps()), col2, baseY,
            Graphics.FONT_XTINY, sand);

        var hrVal = Data.getHeartRate();
        var hrStr = (hrVal > 0) ? hrVal.format("%d") + " BPM" : "-- BPM";
        Draw.textRight(dc, "HR", col1, baseY + rowH,
            Graphics.FONT_XTINY, dimO);
        Draw.textLeft(dc, hrStr, col2, baseY + rowH,
            Graphics.FONT_XTINY, sand);

        Draw.textRight(dc, "BAT", col1, baseY + rowH * 2,
            Graphics.FONT_XTINY, dimO);
        Draw.textLeft(dc, Data.getBattery().format("%d") + "%", col2, baseY + rowH * 2,
            Graphics.FONT_XTINY, sand);

        Draw.textRight(dc, "SUNSET", col1, baseY + rowH * 3,
            Graphics.FONT_XTINY, dimO);
        Draw.textLeft(dc, Data.getSunEvent(), col2, baseY + rowH * 3,
            Graphics.FONT_XTINY, sand);
    }
}
