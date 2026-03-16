import Toybox.Graphics;
import Toybox.Lang;

// Face 3: Vitals — Simplified health dashboard
class VitalsFace {

    function draw(dc as Dc, aod as Boolean) as Void {
        var S = Draw.S;
        var CX = Draw.CX;

        // Time — HERO
        Draw.text(dc, Data.getTimeString(), CX, 50,
            Graphics.FONT_NUMBER_HOT, Colors.time(aod));

        // Date
        Draw.text(dc, Data.getDateCompact(), CX, 95,
            Graphics.FONT_XTINY, Colors.date(aod));

        // Separator
        Draw.hline(dc, 70, 110, S - 70, Colors.sep(aod));

        // Steps
        Draw.textLeft(dc, "STEPS", 70, 130,
            Graphics.FONT_XTINY, Colors.label(aod));
        Draw.textRight(dc, Data.formatNumber(Data.getSteps()) + " / " + Data.formatNumber(Data.getStepGoal()), S - 70, 130,
            Graphics.FONT_XTINY, Colors.steps(aod));
        Draw.bar(dc, 70, 150, S - 140, 4, Data.getStepProgress(),
            Colors.track(aod), aod ? Colors.dim(aod) : Colors.STEPS);

        // Heart
        Draw.textLeft(dc, "HEART", 70, 180,
            Graphics.FONT_XTINY, Colors.label(aod));
        var hrVal = Data.getHeartRate();
        var hrStr = (hrVal > 0) ? hrVal.format("%d") + " bpm" : "-- bpm";
        Draw.textRight(dc, hrStr, S - 70, 180,
            Graphics.FONT_XTINY, Colors.hr(aod));

        // Separator
        Draw.hline(dc, 70, 195, S - 70, Colors.sep(aod));

        // Battery + Temperature
        Draw.textLeft(dc, "BAT: " + Data.getBattery().format("%d") + "%", 70, 220,
            Graphics.FONT_XTINY, Colors.bat(aod));
        Draw.textRight(dc, "TEMP: " + Data.getTemperature() + "°F", S - 70, 220,
            Graphics.FONT_XTINY, Colors.temp(aod));
    }
}
