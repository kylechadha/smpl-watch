import Toybox.Application;
import Toybox.WatchUi;

class UtacticalApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [new UtacticalView()];
    }
    function getSettingsView() as [Views] or [Views, InputDelegates] or Null {
        return null;
    }
    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }
}
