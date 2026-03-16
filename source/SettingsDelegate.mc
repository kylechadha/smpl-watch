import Toybox.WatchUi;
import Toybox.Application;

class SettingsDelegate extends WatchUi.InputDelegate {

    var _faceNames as Array = ["Horizon", "Vitals", "Strata", "Signal", "Tactical", "Retro LCD", "Grid"];
    var _totalFaces as Number = 7;

    function initialize() {
        InputDelegate.initialize();
    }

    function onKey(keyEvent as KeyEvent) as Boolean {
        var key = keyEvent.getKey();

        if (key == WatchUi.KEY_SELECT) {
            cycleToNextFace();
            return true;
        } else if (key == WatchUi.KEY_BACK) {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            return true;
        }

        return false;
    }

    function cycleToNextFace() as Void {
        var currentFace = Application.Storage.getValue("ActiveFace");
        if (currentFace == null) {
            currentFace = 0;
        }

        // Cycle to next face
        var nextFace = (currentFace + 1) % _totalFaces;
        Application.Storage.setValue("ActiveFace", nextFace);

        // Update UI to show new face
        WatchUi.requestUpdate();

        // Show notification of face change
        var faceName = _faceNames[nextFace];
        if (WatchUi has :Tooltip) {
            WatchUi.showBriefly(faceName);
        }
    }
}
