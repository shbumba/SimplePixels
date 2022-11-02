import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

class BackgroundView extends Component.BaseDrawable {
    function initialize(params) {
        Component.BaseDrawable.initialize(params);
    }

    function draw(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_TRANSPARENT, self.backgroundColor);
        dc.clear();
    }
}
