import Toybox.Lang;
import Toybox.Graphics;
import Toybox.Time;
import Components;
import SettingsModule;

class DateView extends Components.Box {
    function initialize(params as Components.BoxProps) {
        Components.Box.initialize(params);
    }

    protected function render(drawContext as Dc) as Void {
        var posX = self.getPosX();
        var posY = self.getPosY();
        var width = self.getWidth();

        var getDateFormat = SettingsModule.getValue(SettingsModule.SettingType.DATE_FORMAT);
        var dateObj = getDateFormat == 0 ? formatDateToEng(Time.now()) : formatDateToMMdd(Time.now());

        var font = self.getFont();
        var fontHeight = drawContext.getFontHeight(font);

        drawContext.setColor(self.infoColor, Graphics.COLOR_TRANSPARENT);
        drawContext.drawText(posX + width, posY, font, dateObj[0], Graphics.TEXT_JUSTIFY_RIGHT);
        drawContext.drawText(posX + width, posY + fontHeight, font, dateObj[1], Graphics.TEXT_JUSTIFY_RIGHT);
    }
}
