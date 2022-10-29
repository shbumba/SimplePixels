import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

typedef CustomIconMenuItemProps as {
        :identifier as Lang.Object,
        :icon as Number?,
        :label as String,
        :options as { :drawable as WatchUi.Drawable, :alignment as MenuItem.Alignment }?
    };

class CustomIconMenuItem extends WatchUi.CustomMenuItem {
    private var _label as String;
    private var _icon as Number;
    private static var _iconFont = WatchUi.loadResource(Rez.Fonts.sensorIcons);

    function initialize(params as CustomIconMenuItemProps) {
        var itemParams = params.hasKey(:options) ? params.get(:options) : {};

        WatchUi.CustomMenuItem.initialize(params.get(:identifier), itemParams);

        self._icon = params.hasKey(:icon) ? params.get(:icon) : null;
        self._label = params.get(:label);
    }

    function draw(drawContext as Dc) {
        var font = Graphics.FONT_SMALL;
        var fontColor = Graphics.COLOR_DK_GRAY;
        var width = drawContext.getWidth();
        var height = drawContext.getHeight();

        if (isFocused()) {
            font = Graphics.FONT_LARGE;
            fontColor = Graphics.COLOR_BLACK;
        }

        drawContext.setColor(fontColor, Graphics.COLOR_TRANSPARENT);
        drawContext.drawText(
            width / 4,
            height / 2,
            font,
            self._label,
            Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );

        drawContext.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        drawContext.fillRectangle(0, 0, width / 5, height);

        if (self._icon) {
            drawContext.setColor(fontColor, Graphics.COLOR_TRANSPARENT);
            drawContext.drawText(
                width / 8,
                height / 3,
                self._iconFont,
                self._icon,
                Graphics.TEXT_JUSTIFY_CENTER
            );
        }
    }
}
