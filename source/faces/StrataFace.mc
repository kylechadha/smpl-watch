import Toybox.Graphics;
import Toybox.Lang;

// Face 9: Strata — Layered horizontal bands with step goal
class StrataFace {

    function draw(dc as Dc, aod as Boolean) as Void {
        var S = Draw.S;
        var CX = Draw.CX;
        var CY = Draw.CY;

        // Band separators
        Draw.hline(dc, 70, 102, S - 70, Colors.sep(aod));
        Draw.hline(dc, 60, CY + 42, S - 60, Colors.sep(aod));
        Draw.hline(dc, 70, CY + 112, S - 70, Colors.sep(aod));

        // Top band — date + battery
        Draw.text(dc, Data.getDateCompact(), CX - 30, 80,
            Graphics.FONT_TINY, Colors.date(aod));
        Draw.text(dc, Data.getBattery().format("%d") + "%", CX + 80, 80,
            Graphics.FONT_TINY, Colors.bat(aod));

        // Time — large centered
        Draw.text(dc, Data.getTimeString(), CX, CY - 12,
            Graphics.FONT_NUMBER_THAI_HOT, Colors.time(aod));

        // Steps with goal
        var steps = Data.getSteps();
        var stepGoal = Data.getStepGoal();
        Draw.textRight(dc, Data.formatNumber(steps), CX - 32, CY + 65,
            Graphics.FONT_SMALL, Colors.steps(aod));
        Draw.textLeft(dc, "/ " + Data.formatNumber(stepGoal), CX - 28, CY + 65,
            Graphics.FONT_XTINY, Colors.label(aod));

        // Steps progress bar
        Draw.bar(dc, 85, CY + 82, S - 170, 4, Data.getStepProgress(),
            Colors.track(aod), aod ? Colors.dim(aod) : Colors.STEPS);

        // Bottom band — HR + sunset
        var hrVal = Data.getHeartRate();
        var hrStr = (hrVal > 0) ? hrVal.format("%d") : "--";
        Draw.text(dc, hrStr, CX - 55, CY + 132,
            Graphics.FONT_TINY, Colors.hr(aod));
        Draw.text(dc, Data.getSunIcon() + " " + Data.getSunEvent(), CX + 55, CY + 132,
            Graphics.FONT_TINY, Colors.sun(aod));
    }
}
