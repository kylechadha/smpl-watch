import Toybox.Graphics;
import Toybox.Lang;

// Face 9: Strata — Layered horizontal bands
class StrataFace {

    function draw(dc as Dc, aod as Boolean) as Void {
        var S = Draw.S;
        var CX = Draw.CX;

        // Top band: date + battery
        Draw.hline(dc, 70, 45, S - 70, Colors.sep(aod));
        Draw.textLeft(dc, "DATE: " + Data.getDateCompact(), 70, 65,
            Graphics.FONT_XTINY, Colors.label(aod));
        Draw.textRight(dc, "BAT: " + Data.getBattery().format("%d") + "%", S - 70, 65,
            Graphics.FONT_XTINY, Colors.bat(aod));
        Draw.hline(dc, 70, 95, S - 70, Colors.sep(aod));

        // Center band: time + steps
        Draw.text(dc, Data.getTimeString(), CX, 165,
            Graphics.FONT_NUMBER_HOT, Colors.time(aod));

        // Steps with progress bar
        var steps = Data.getSteps();
        var stepGoal = Data.getStepGoal();
        Draw.textLeft(dc, "STEPS: " + Data.formatNumber(steps), 70, 220,
            Graphics.FONT_SMALL, Colors.steps(aod));
        Draw.bar(dc, 70, 245, S - 140, 5, Data.getStepProgress(),
            Colors.track(aod), aod ? Colors.dim(aod) : Colors.STEPS);
        Draw.hline(dc, 70, 260, S - 70, Colors.sep(aod));

        // Bottom band: HR + temp
        var hrVal = Data.getHeartRate();
        var hrStr = (hrVal > 0) ? hrVal.format("%d") + " bpm" : "-- bpm";
        Draw.textLeft(dc, "HEART: " + hrStr, 70, 290,
            Graphics.FONT_XTINY, Colors.hr(aod));
        Draw.textRight(dc, "TEMP: " + Data.getTemperature() + "°F", S - 70, 290,
            Graphics.FONT_XTINY, Colors.temp(aod));
    }
}
