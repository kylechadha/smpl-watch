import Toybox.Application;
import Toybox.WatchUi;

class UstrataApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [new UstrataView()];
    }
    function getSettingsView() as [Views] or [Views, InputDelegates] or Null {
        return null;
    }
    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }
}
