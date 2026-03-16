import Toybox.Application;
import Toybox.WatchUi;

class SmplWatchApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
        loadActiveFace();
    }

    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [new SmplWatchView()];
    }

    function getSettingsView() as [Views] or [Views, InputDelegates] or Null {
        return [new SettingsView(), new SettingsDelegate()];
    }

    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }

    function loadActiveFace() as Void {
        var faceIdx = Application.Storage.getValue("ActiveFace");
        if (faceIdx == null || faceIdx < 0 || faceIdx >= 7) {
            faceIdx = 0;
            Application.Storage.setValue("ActiveFace", faceIdx);
        }
    }
}
