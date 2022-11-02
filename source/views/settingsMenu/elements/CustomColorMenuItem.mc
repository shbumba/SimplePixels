import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

typedef CustomColorMenuItemProps as {
        :identifier as Lang.Object,
        :color as Number,
        :label as Symbol,
        :options as { :drawable as WatchUi.Drawable, :alignment as MenuItem.Alignment }?
    };

class CustomColorMenuItem extends WatchUi.CustomMenuItem {
    private var _label as Symbol;
    private var _color as Number;

    function initialize(params as CustomColorMenuItemProps) {
        var itemParams = params.hasKey(:options) ? params.get(:options) : {};

        WatchUi.CustomMenuItem.initialize(params.get(:identifier), itemParams);

        self._color = params.get(:color);
        self._label = params.get(:label);
    }

    function draw(drawContext as Dc) {
        var iconWidth = 40;
        var textLeftMargin = 10;
        var font = Graphics.FONT_SMALL;
        var fontColor = Graphics.COLOR_DK_GRAY;
        var width = drawContext.getWidth();
        var height = drawContext.getHeight();

        if (isFocused()) {
            font = Graphics.FONT_MEDIUM;
            fontColor = Graphics.COLOR_BLACK;
        }

        drawContext.setColor(fontColor, Graphics.COLOR_TRANSPARENT);
        drawContext.drawText(
            iconWidth + textLeftMargin,
            height / 2,
            font,
            WatchUi.loadResource(self._label),
            Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );

        drawContext.setColor(self._color, Graphics.COLOR_BLACK);
        drawContext.fillRectangle(0, 0, iconWidth, height);
    }
}
