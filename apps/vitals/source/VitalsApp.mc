import Toybox.Application;
import Toybox.WatchUi;

class VitalsApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [new VitalsView()];
    }
    function getSettingsView() as [Views] or [Views, InputDelegates] or Null {
        return null;
    }
    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }
}
