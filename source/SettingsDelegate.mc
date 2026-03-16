import Toybox.WatchUi;
import Toybox.Application;
import Toybox.Lang;

class SettingsDelegate extends WatchUi.InputDelegate {

    var _faceNames as Array = ["Horizon", "Vitals", "Strata", "Signal", "Tactical", "Retro LCD", "Grid"];
    var _totalFaces as Number = 7;

    function initialize() {
        InputDelegate.initialize();
    }

    function onKey(keyEvent as KeyEvent) as Boolean {
        var key = keyEvent.getKey();

        if (key == WatchUi.KEY_ENTER) {
            cycleToNextFace();
            return true;
        }

        return false;
    }

    function cycleToNextFace() as Void {
        var currentFace = Application.Storage.getValue("ActiveFace");
        if (currentFace == null || currentFace < 0 || currentFace >= _totalFaces) {
            currentFace = 0;
        }

        // Cycle to next face
        var nextFace = (currentFace + 1) % _totalFaces;
        Application.Storage.setValue("ActiveFace", nextFace);

        // Update UI to show new face
        WatchUi.requestUpdate();
    }
}
