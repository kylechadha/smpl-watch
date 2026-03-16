import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Application;

class SettingsView extends WatchUi.View {

    var _faceNames as Array = ["Horizon", "Vitals", "Strata", "Signal", "Tactical", "Retro LCD", "Grid"];

    function initialize() {
        View.initialize();
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    function onUpdate(dc as Dc) as Void {
        // Get current active face
        var currentFace = Application.Storage.getValue("ActiveFace");
        if (currentFace == null) {
            currentFace = 0;
        }

        // Draw a simple menu showing available faces
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var screenHeight = dc.getHeight();
        var screenWidth = dc.getWidth();
        var centerY = screenHeight / 2;
        var centerX = screenWidth / 2;

        // Title
        dc.drawText(centerX, centerY - 80, Graphics.FONT_MEDIUM, "Watch Faces", Graphics.TEXT_JUSTIFY_CENTER);

        // Current face
        dc.drawText(centerX, centerY - 20, Graphics.FONT_SMALL, "Press SELECT to", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, centerY, Graphics.FONT_SMALL, "cycle faces", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, centerY + 30, Graphics.FONT_MEDIUM, _faceNames[currentFace], Graphics.TEXT_JUSTIFY_CENTER);

        // Available faces list
        dc.drawText(centerX, centerY + 70, Graphics.FONT_SMALL, "1. " + _faceNames[0], Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, centerY + 90, Graphics.FONT_SMALL, "2. " + _faceNames[1], Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, centerY + 110, Graphics.FONT_SMALL, "3. " + _faceNames[2], Graphics.TEXT_JUSTIFY_CENTER);
    }
}
