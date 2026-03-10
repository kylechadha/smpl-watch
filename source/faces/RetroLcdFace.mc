import Toybox.Graphics;
import Toybox.Lang;

// Face 14: Retro LCD — Amber segments, dual-panel layout
class RetroLcdFace {

    function draw(dc as Dc, aod as Boolean) as Void {
        var S = Draw.S;
        var CX = Draw.CX;

        var amber = aod ? 0x444444 : Colors.AMBER;
        var dimA = aod ? Colors.AOD_DIM : Colors.DIM_AMBER;

        // Panel dimensions
        var px = 85;
        var pw = S - 170;
        var py1 = 65;
        var ph1 = 120;
        var py2 = 195;
        var ph2 = 130;

        // Draw panel borders
        dc.setColor(aod ? 0x111111 : 0x1A1A1A, Colors.BLACK);
        dc.setPenWidth(1);
        dc.drawRectangle(px, py1, pw, ph1);
        dc.drawRectangle(px, py2, pw, ph2);

        // --- Top panel ---
        // Day + Date
        Draw.textLeft(dc, Data.getDateCompact().substring(0, 3), px + 12, 90,
            Graphics.FONT_TINY, amber);
        Draw.textRight(dc, Data.getDateCompact().substring(4, null), px + pw - 12, 90,
            Graphics.FONT_TINY, amber);

        // Labels
        Draw.textLeft(dc, "STEPS", px + 12, 118,
            Graphics.FONT_XTINY, dimA);
        Draw.textRight(dc, "HR", px + pw - 12, 118,
            Graphics.FONT_XTINY, dimA);

        // Values
        Draw.textLeft(dc, Data.formatNumber(Data.getSteps()), px + 12, 142,
            Graphics.FONT_SMALL, amber);
        var hrVal = Data.getHeartRate();
        var hrStr = (hrVal > 0) ? hrVal.format("%d") : "--";
        Draw.textRight(dc, hrStr, px + pw - 12, 142,
            Graphics.FONT_SMALL, amber);

        // Sunset + Battery
        Draw.textLeft(dc, Data.getSunIcon() + " " + Data.getSunEvent(), px + 12, 168,
            Graphics.FONT_XTINY, dimA);
        Draw.textRight(dc, "BAT " + Data.getBattery().format("%d") + "%", px + pw - 12, 168,
            Graphics.FONT_XTINY, dimA);

        // --- Bottom panel: Time ---
        Draw.text(dc, Data.getTimeString(), CX, 260,
            Graphics.FONT_NUMBER_THAI_HOT, amber);

        // Seconds — small, dimmer, below time
        if (!aod) {
            Draw.text(dc, ":" + Data.getSecondsString(), CX + 95, 290,
                Graphics.FONT_XTINY, dimA);
        }

        // Branding
        Draw.text(dc, "VENU 3S", CX, 310,
            Graphics.FONT_XTINY, dimA);
    }
}
