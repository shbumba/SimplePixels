import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

class DrawableMenuTitle extends WatchUi.Drawable {
    var _title as String;

    function initialize(title) {
        Drawable.initialize({});
        self._title = title;
    }

    function draw(drawContext as Dc) as Void {
        var posX = drawContext.getWidth() / 2;
        var posY = drawContext.getHeight() / 2;

        drawContext.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        drawContext.clear();

        drawContext.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        drawContext.drawText(
            posX,
            posY,
            Graphics.FONT_SMALL,
            self._title,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }
}
