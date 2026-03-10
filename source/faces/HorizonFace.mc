import Toybox.Graphics;
import Toybox.Lang;

// Face 1: Horizon — Clean minimal, sunrise/sunset by time of day
class HorizonFace {

    function draw(dc as Dc, aod as Boolean) as Void {
        var S = Draw.S;
        var CX = Draw.CX;

        // Subtle perimeter ticks
        if (!aod) {
            Draw.ticks(dc, 60, Draw.R - 8, Draw.R - 2, 0x0F0F0F, 1);
        }

        // Time — large, light weight
        Draw.text(dc, Data.getTimeString(), CX, 140,
            Graphics.FONT_NUMBER_THAI_HOT, Colors.time(aod));

        // Date
        Draw.text(dc, Data.getDateString(), CX, 200,
            Graphics.FONT_XTINY, Colors.date(aod));

        // Steps + HR row
        Draw.text(dc, Data.formatNumber(Data.getSteps()), CX - 55, 242,
            Graphics.FONT_TINY, aod ? Colors.steps(aod) : 0x999999);
        var hrVal = Data.getHeartRate();
        var hrStr = (hrVal > 0) ? hrVal.format("%d") : "--";
        Draw.text(dc, hrStr, CX + 55, 242,
            Graphics.FONT_TINY, Colors.hr(aod));

        // Battery + Sun event row
        Draw.text(dc, Data.getBattery().format("%d") + "%", CX - 55, 280,
            Graphics.FONT_TINY, Colors.bat(aod));
        Draw.text(dc, Data.getSunIcon() + " " + Data.getSunEvent(), CX + 55, 280,
            Graphics.FONT_TINY, Colors.sun(aod));
    }
}
