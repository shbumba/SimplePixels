import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;
import Components;

class BackgroundView extends Components.BaseDrawable {
    var _isAwake as Boolean = AwakeObserver.isAwake;
    function initialize(params) {
        Components.BaseDrawable.initialize(params);
    }

    function draw(dc as Dc) as Void {
        if (self._isAwake) {
            dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        } else {
            dc.setColor(Graphics.COLOR_TRANSPARENT, self.backgroundColor);
        }
        dc.clear();
    }

    function setViewProps(isAwake as Boolean) as Void {
        self._isAwake = isAwake;
        // self.setVisibility();
    }
}
