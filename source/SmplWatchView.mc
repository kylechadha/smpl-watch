import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class SmplWatchView extends WatchUi.WatchFace {

    var _isAwake as Boolean = true;
    var _faces as Array;

    function initialize() {
        WatchFace.initialize();
        _faces = [
            new HorizonFace(),
            new VitalsFace(),
            new StrataFace(),
            new SignalFace(),
            new TacticalFace(),
            new RetroLcdFace(),
            new GridFace(),
        ];
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    function onUpdate(dc as Dc) as Void {
        // Clear to black (AMOLED efficient)
        dc.setColor(Colors.BLACK, Colors.BLACK);
        dc.clear();

        // Clip to circle
        dc.setClip(0, 0, Draw.S, Draw.S);

        // Get active face from storage (persists on sideloaded apps)
        var faceIdx = Application.Storage.getValue("ActiveFace");
        if (faceIdx == null || faceIdx < 0 || faceIdx >= _faces.size()) {
            faceIdx = 0;
        }

        // Draw the active face
        var face = _faces[faceIdx];
        face.draw(dc, !_isAwake);
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
        // In AOD, we could do minimal updates here
        // For now, just do a full redraw (Garmin handles the
        // partial update clipping for AMOLED burn-in protection)
    }
}
