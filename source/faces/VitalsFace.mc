import Toybox.Graphics;
import Toybox.Lang;

// Face 3: Vitals — Dense health dashboard with sparklines and both bars
class VitalsFace {

    // Store recent HR samples for sparkline
    var _hrHistory as Array<Number>;

    function initialize() {
        _hrHistory = [68, 70, 72, 74, 70, 68, 72, 76, 78, 74, 72, 70, 68, 72, 74, 76];
    }

    function draw(dc as Dc, aod as Boolean) as Void {
        var S = Draw.S;
        var CX = Draw.CX;

        // Time (smaller to make room for data)
        Draw.text(dc, Data.getTimeString(), CX, 80,
            Graphics.FONT_NUMBER_HOT, Colors.time(aod));

        // Date
        Draw.text(dc, Data.getDateCompact(), CX, 115,
            Graphics.FONT_XTINY, Colors.date(aod));

        // Separator
        Draw.hline(dc, 80, 132, S - 80, Colors.sep(aod));

        // Steps bar
        var steps = Data.getSteps();
        var stepGoal = Data.getStepGoal();
        Draw.textLeft(dc, Data.formatNumber(steps), 90, 152,
            Graphics.FONT_XTINY, Colors.steps(aod));
        Draw.textRight(dc, "/ " + Data.formatNumber(stepGoal), S - 90, 152,
            Graphics.FONT_XTINY, Colors.label(aod));
        Draw.bar(dc, 90, 165, S - 180, 5, Data.getStepProgress(),
            Colors.track(aod), aod ? Colors.dim(aod) : Colors.STEPS);

        // Battery bar
        Draw.textLeft(dc, Data.getBattery().format("%d") + "%", 90, 190,
            Graphics.FONT_XTINY, Colors.bat(aod));
        Draw.bar(dc, 90, 203, S - 180, 5, Data.getBatteryFloat(),
            Colors.track(aod), aod ? Colors.dim(aod) : Colors.BAT);

        // Separator
        Draw.hline(dc, 80, 218, S - 80, Colors.sep(aod));

        // Health stats 2x2 grid
        var hrVal = Data.getHeartRate();
        var hrStr = (hrVal > 0) ? hrVal.format("%d") + " bpm" : "-- bpm";
        Draw.text(dc, hrStr, CX - 55, 240,
            Graphics.FONT_XTINY, Colors.hr(aod));
        Draw.text(dc, Data.formatNumber(Data.getCalories()) + " cal", CX + 55, 240,
            Graphics.FONT_XTINY, Colors.sun(aod));

        Draw.text(dc, Data.getDistance() + " mi", CX - 55, 268,
            Graphics.FONT_XTINY, Colors.teal(aod));
        Draw.text(dc, Data.getFloors().format("%d") + " fl", CX + 55, 268,
            Graphics.FONT_XTINY, Colors.accent(aod));

        // Separator
        Draw.hline(dc, 80, 286, S - 80, Colors.sep(aod));

        // HR sparkline (active mode only)
        if (!aod) {
            Draw.text(dc, "HR 6h", CX, 300,
                Graphics.FONT_XTINY, Colors.label(aod));

            // Update HR history with current value
            var currentHr = Data.getHeartRate();
            if (currentHr > 0) {
                // Shift left and add new value
                for (var i = 0; i < _hrHistory.size() - 1; i++) {
                    _hrHistory[i] = _hrHistory[i + 1];
                }
                _hrHistory[_hrHistory.size() - 1] = currentHr;
            }

            Draw.sparkline(dc, 90, 310, S - 180, 30, _hrHistory, Colors.HR);
        }
    }
}
