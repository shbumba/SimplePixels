import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

typedef CustomIconMenuItemProps as {
        :identifier as Lang.Object,
        :icon as Symbol?,
        :label as Symbol,
        :options as { :drawable as WatchUi.Drawable, :alignment as MenuItem.Alignment }?
    };

class CustomIconMenuItem extends WatchUi.CustomMenuItem {
    private var _label as Symbol;
    private var _icon as Symbol or Null;

    function initialize(params as CustomIconMenuItemProps) {
        var itemParams = params.hasKey(:options) ? params.get(:options) : {};

        WatchUi.CustomMenuItem.initialize(params.get(:identifier), itemParams);

        self._icon = params.get(:icon);
        self._label = params.get(:label);
    }

    function draw(drawContext as Dc) {
        var iconWidth = 40;
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
            iconWidth,
            height / 2,
            font,
            WatchUi.loadResource(self._label),
            Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );

        if (self._icon != null) {
            drawContext.setColor(fontColor, Graphics.COLOR_TRANSPARENT);
            drawContext.drawText(iconWidth / 2, height / 2, WatchUi.loadResource(self._icon), $.ICON_SYMBOL, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }
    }
}
