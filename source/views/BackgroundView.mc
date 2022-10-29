import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

class BackgroundView extends Component.BaseDrawable {
    function initialize(params as Dictionary<String, String?>) {
        Component.BaseDrawable.initialize(params);
    }

    function draw(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_TRANSPARENT, self.backgroundColor);
        dc.clear();
    }
}
