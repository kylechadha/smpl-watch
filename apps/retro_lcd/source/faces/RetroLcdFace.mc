import Toybox.Graphics;
import Toybox.Lang;

// Face 14: Retro LCD — Amber segments, single hero time
class RetroLcdFace {

    function draw(dc as Dc, aod as Boolean) as Void {
        var S = Draw.S;
        var CX = Draw.CX;

        var amber = aod ? 0x444444 : Colors.AMBER;
        var dimA = aod ? Colors.AOD_DIM : Colors.DIM_AMBER;

        var px = 85;
        var pw = S - 170;

        // Top section: Date + Time
        Draw.textLeft(dc, Data.getDateCompact().substring(0, 3), px + 12, 50,
            Graphics.FONT_TINY, amber);
        Draw.textRight(dc, Data.getDateCompact().substring(4, null), px + pw - 12, 50,
            Graphics.FONT_TINY, amber);

        Draw.hline(dc, px, 65, px + pw, dimA);

        Draw.text(dc, Data.getTimeString(), CX, 155,
            Graphics.FONT_NUMBER_HOT, amber);

        Draw.hline(dc, px, 180, px + pw, dimA);

        // Bottom section: Metrics
        Draw.textLeft(dc, "STEPS", px + 12, 215,
            Graphics.FONT_XTINY, dimA);
        Draw.textRight(dc, "HEART", px + pw - 12, 215,
            Graphics.FONT_XTINY, dimA);

        var hrVal = Data.getHeartRate();
        var hrStr = (hrVal > 0) ? hrVal.format("%d") : "--";
        Draw.textLeft(dc, Data.formatNumber(Data.getSteps()), px + 12, 245,
            Graphics.FONT_SMALL, amber);
        Draw.textRight(dc, hrStr, px + pw - 12, 245,
            Graphics.FONT_SMALL, amber);

        Draw.textLeft(dc, "BAT: " + Data.getBattery().format("%d") + "%", px + 12, 285,
            Graphics.FONT_XTINY, dimA);
        Draw.textRight(dc, "TEMP: " + Data.getTemperature() + "°F", px + pw - 12, 285,
            Graphics.FONT_XTINY, dimA);
    }
}
