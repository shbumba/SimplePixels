import Toybox.Lang;
import Toybox.Graphics;
import Toybox.Time;
import Components;
import SettingsModule;
import SettingsModule.SettingType;

class DateView extends Components.Box {
    private var _dateFormatType as FormatDate.DisplayDateFormatType.Enum = FormatDate.DisplayDateFormatType.DDMM;

    function initialize(params as Components.BoxProps) {
        Components.Box.initialize(params);
        self.updateDateFormatType();
    }

    function onSettingsChanged() as Void {
        Components.Box.onSettingsChanged();
        self.updateDateFormatType();
    }

    private function updateDateFormatType() as Void {
        self._dateFormatType =
            SettingsModule.getValue(SettingType.DATE_FORMAT) as FormatDate.DisplayDateFormatType.Enum;
    }

    protected function render(drawContext as Dc) as Void {
        var posX = self.getPosX();
        var posY = self.getPosY();
        var width = self.getWidth();

        var dateObj = FormatDate.formatDateByType(Time.now(), self._dateFormatType);

        var font = self.getFont();
        var fontHeight = drawContext.getFontHeight(font);
        if (self.isAod) {
            drawContext.setColor(self.aodColor, Graphics.COLOR_TRANSPARENT);
        } else {
            drawContext.setColor(self.infoColor, Graphics.COLOR_TRANSPARENT);
        }

        drawContext.drawText(posX + width, posY, font, dateObj[0], Graphics.TEXT_JUSTIFY_RIGHT);
        drawContext.drawText(posX + width, posY + fontHeight, font, dateObj[1], Graphics.TEXT_JUSTIFY_RIGHT);
    }
}
