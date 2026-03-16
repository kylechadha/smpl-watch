import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class VitalsView extends WatchUi.WatchFace {
    var _isAwake as Boolean = true;
    var _face as VitalsFace;

    function initialize() {
        WatchFace.initialize();
        _face = new VitalsFace();
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    function onUpdate(dc as Dc) as Void {
        dc.setColor(Colors.BLACK, Colors.BLACK);
        dc.clear();
        dc.setClip(0, 0, Draw.S, Draw.S);
        _face.draw(dc, !_isAwake);
        dc.clearClip();
    }

    function onEnterSleep() as Void {
        _isAwake = false;
        WatchUi.requestUpdate();
    }

    function onExitSleep() as Void {
        _isAwake = true;
        WatchUi.requestUpdate();
    }

    function onPartialUpdate(dc as Dc) as Void {
    }
}
