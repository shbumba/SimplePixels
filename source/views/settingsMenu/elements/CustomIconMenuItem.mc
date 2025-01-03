import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;
import GlobalKeys;

typedef CustomIconMenuItemProps as {
    :identifier as Object or Number or String,
    :icon as ResourceId?,
    :label as ResourceId or String
};

class CustomIconMenuItem extends WatchUi.CustomMenuItem {
    var _label as ResourceId;
    var _icon as ResourceId?;

    function initialize(params as CustomIconMenuItemProps) {
        WatchUi.CustomMenuItem.initialize(params.get(:identifier), {});

        self._icon = params.get(:icon);
        self._label = params.get(:label);
    }

    function draw(drawContext as Dc) as Void {
        var iconWidth = 40;
        var font = Graphics.FONT_SMALL;
        var fontColor = Graphics.COLOR_DK_GRAY;
        var height = drawContext.getHeight();
        var labelText = self._label instanceof Lang.String ? self._label : WatchUi.loadResource(self._label);

        if (isFocused()) {
            font = Graphics.FONT_MEDIUM;
            fontColor = Graphics.COLOR_BLACK;
        }

        drawContext.setColor(fontColor, Graphics.COLOR_TRANSPARENT);
        drawContext.drawText(
            iconWidth,
            height / 2,
            font,
            labelText,
            Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );

        if (self._icon != null) {
            drawContext.setColor(fontColor, Graphics.COLOR_TRANSPARENT);
            drawContext.drawText(
                iconWidth / 2,
                height / 2,
                WatchUi.loadResource(self._icon),
                GlobalKeys.ICON_SYMBOL,
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
            );
        }
    }
}
