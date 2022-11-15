import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;
import Components;

class BackgroundView extends Components.BaseDrawable {
    function initialize(params) {
        Components.BaseDrawable.initialize(params);
    }

    function draw(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_TRANSPARENT, self.backgroundColor);
        dc.clear();
    }
}
